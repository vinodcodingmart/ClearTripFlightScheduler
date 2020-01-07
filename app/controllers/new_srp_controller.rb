class NewSrpController < ApplicationController
	def response_json
		from ="BLR"
		to="DXB"
		flight_routes_data = []
		one_way_url="https://apistaging.cleartrip.com/air/1.0/search?from=#{from}&to=#{to}&depart-date=2019-10-05&adults=1&country=IN&currency=INR&&jsonVersion=1.0"

		response_body = HTTParty.get(one_way_url,headers:{"X-CT-API-KEY": "dcc5b435bbda864a8a0df08bfd26cbc8","X-CT-SOURCETYPE": "B2C","Accept-encoding": "gzip"})
		if response_body.present? & response_body["fare"].present?
			response_body["fare"].each do |key,fdata|
				flight_details_obj = {}
				if  fdata["HBAG"].present?
					fdata = fdata["HBAG"]
				end
				data = fdata["dfd"] == "R" ? fdata["R"] : fdata["N"]
				flight_details_obj["route_total_fare"] = data["pr"]
				flight_details_obj["out_fare_key"] = data["fk"]
				flight_details_obj["session_id"] = data["sid"]
				response_body["mapping"]["onward"].each do |maping|
					if maping["f"] == key
						map_data = maping["c"][0].kind_of?(Array) ? maping["c"][0] :  maping["c"]
						if map_data.length > 1
							flight_details_obj["carrier_codes"] = map_data.map{|c| response_body["content"][c]["fk"].split("_").reverse[3].split('-')[0]}.uniq
							flight_details_obj["dep_time"] =  map_data.map{|c| response_body["content"][c]["fk"].split("_").reverse[1]}[0]
							flight_details_obj["arr_time"] =   map_data.map{|c| response_body["content"][c]["a"]}.last
							flight_details_obj['flight_number'] = map_data.map{|c| response_body["content"][c]["fk"].split("_").reverse[3]}[0]
							dep_and_arr_flight_number =   map_data.map{|c| response_body["content"][c]["fk"]}
							flight_details_obj['departure_flight_key'] = dep_and_arr_flight_number.first 
							flight_details_obj['arrival_flight_key'] = dep_and_arr_flight_number.last 
							dep_date = map_data.map{|c| response_body["content"][c]["fk"].split("_").reverse[2]}[0].insert(2, '/').insert(5, '/')
							flight_details_obj["departure_date"] =  dep_date
							flight_details_obj["arrival_date"] = map_data.map{|c| response_body["content"][c]["ad"]}.last
							from_cities = map_data.map{|c| response_body["content"][c]["fr"]}
							to_cities = map_data.map{|c| response_body["content"][c]["to"]}
							flight_details_obj["via_info"] = (from_cities+to_cities).uniq
							duration = map_data.map{|c| response_body["content"][c]["dr"].to_i}.reduce(:+)
							flight_details_obj["duration"] =  Time.at(duration).utc.strftime("%Hh %Mm")
							flight_details_obj["no_of_stops"] = flight_details_obj["via_info"].length-2
							flight_details_obj["dep_airport_name"] = response_body["jsons"]["ap"][flight_details_obj["via_info"].first]["n"]
							flight_details_obj["arr_airport_name"] = response_body["jsons"]["ap"][flight_details_obj["via_info"].last]["n"]
							flight_details_obj["dep_city_name"] = response_body["jsons"]["ap"][flight_details_obj["via_info"].first]["c"]
							flight_details_obj["arr_city_name"] = response_body["jsons"]["ap"][flight_details_obj["via_info"].last]["c"]
							dep_city_code = flight_details_obj["via_info"].first
							arr_city_code = flight_details_obj["via_info"].last
							flight_details_obj["dep_city_code"] = dep_city_code
							flight_details_obj["arr_city_code"] = arr_city_code

							flight_details_obj['dep_flight_key_format'] =  map_data.map{|c| response_body["content"][c]["fk"].split("_").reverse[3]}.first 
							flight_details_obj['arr_flight_key_format'] =  map_data.map{|c| response_body["content"][c]["fk"].split("_").reverse[3]}.last
							flight_key_format = "#{flight_details_obj['dep_flight_key_format']}_#{flight_details_obj['arr_flight_key_format']}"
						
							dep_date_format =  map_data.map{|c| response_body["content"][c]["ad"]}.first.split("/").take(2).join("")
							arr_date_format =  map_data.map{|c| response_body["content"][c]["ad"]}.last.split("/").take(2).join("")
							dep_time_format = flight_details_obj["dep_time"]
							arr_time_format = flight_details_obj["arr_time"]
							flight_details_obj["unique_flight_key"] = "#{dep_city_code}#{dep_date_format}_#{arr_city_code}#{arr_date_format}_#{dep_time_format}_#{arr_time_format}_#{flight_key_format}"
							content_arr = []
							map_data.each do |c|
								obj = {}
								content = response_body["content"][c] 
								flight_key = content["fk"].split("_").reverse
								flight_details_obj["class"] = flight_key[0]
								flight_details_obj["seat_availability"] = content["sa"]
								obj = {
									"airline_code": flight_key[3].split('-')[0],
									"flight_number": flight_key[3],
									"from_city_code": content["fr"],
									"to_city_code": content["to"],
									"dep_airport_name": response_body["jsons"]["ap"][content["fr"]]["n"],
									"arr_airport_name": response_body["jsons"]["ap"][content["to"]]["n"],
									"depart_terminal": content["dt"],
									"arrival_terminal": content["at"],
									"duration": Time.at(content["dr"]).utc.strftime("%Hh %Mm"),
									"departure_time": flight_key[1],
									"arrival_time": content["a"],
									"waiting_time":"",
									"departure_date": flight_key[2].insert(2, '/').insert(5, '/'),
									"arrival_date": content["ad"],
									"flight_key": content["fk"]
								}
								content_arr << obj
							end
							dep_waiting_time = content_arr.map{|a| Time.parse("#{a[:departure_date]} #{a[:departure_time]}")}
							arr_waiting_time = content_arr.map{|a| Time.parse("#{a[:arrival_date]} #{a[:arrival_time]}")}
							dep_waiting_time.each_with_index do |wait,i|
								if i !=0
									a = wait
									b = arr_waiting_time[i-1]
									waiting_time = a-b
									content_arr[i]["waiting_time"] = Time.at(waiting_time).utc.strftime("%Hh %Mm")
								end
							end
							flight_details_obj["flight_itinerary"] = content_arr
						else
							maping_content = response_body["content"][maping["c"][0]] rescue ""
							content_arr = []
							if maping_content.present?
								obj = {}
								flight_key = maping_content["fk"].split("_").reverse
								flight_details_obj["carrier_codes"]= [flight_key[3].split('-')[0]]
								flight_details_obj["via_info"] = [maping_content["fr"],maping_content["to"]]
								flight_details_obj["dep_time"] = flight_key[1]
								flight_details_obj["arr_time"] = maping_content["a"]
								flight_details_obj['flight_number'] = flight_key[3]
								flight_details_obj["duration"] = Time.at(maping_content["dr"]).utc.strftime("%Hh %Mm")
								flight_details_obj["no_of_stops"]= 0
								flight_details_obj["seat_availability"] =  maping_content["sa"]
								flight_details_obj["dep_date"] =flight_key[2].scan(/^(\d{2})(\d{2})(\d{4})$/)[0].join("/")
								flight_details_obj["arr_date"] = maping_content["ad"]
								flight_details_obj["dep_airport_name"] = response_body["jsons"]["ap"][maping_content["fr"]]["n"]
								flight_details_obj["arr_airport_name"] = response_body["jsons"]["ap"][maping_content["to"]]["n"]
								flight_details_obj["dep_city_name"] = response_body["jsons"]["ap"][maping_content["fr"]]["c"]
								flight_details_obj["arr_city_name"] = response_body["jsons"]["ap"][maping_content["to"]]["c"]
								dep_city_code = maping_content["fr"]
								arr_city_code = maping_content["to"]
								flight_details_obj["dep_city_code"] = dep_city_code
								flight_details_obj["arr_city_code"] = arr_city_code
								flight_details_obj["departure_flight_key"] = maping_content["fk"]
								flight_details_obj["arrival_flight_key"] = maping_content["fk"]
								flight_details_obj['dep_flight_key_format'] =  map_data.map{|c| response_body["content"][c]["fk"].split("_").reverse[3]}.first 
							flight_details_obj['arr_flight_key_format'] =  map_data.map{|c| response_body["content"][c]["fk"].split("_").reverse[3]}.last
							flight_key_format = "#{flight_details_obj['dep_flight_key_format']}_#{flight_details_obj['arr_flight_key_format']}"
							dep_date_format =  map_data.map{|c| response_body["content"][c]["ad"]}.first.split("/").take(2).join("")
							arr_date_format =  map_data.map{|c| response_body["content"][c]["ad"]}.last.split("/").take(2).join("")
							dep_time_format = flight_details_obj["dep_time"]
							arr_time_format = flight_details_obj["arr_time"]
							flight_details_obj["unique_flight_key"] = "#{dep_city_code}#{dep_date_format}_#{arr_city_code}#{arr_date_format}_#{dep_time_format}_#{arr_time_format}_#{flight_key_format}"
								flight_details_obj["class"] = flight_key[0]
								obj = {
									"airline_code": flight_key[3].split('-')[0],
									"flight_number": flight_key[3],
									"from_city_code": maping_content["fr"],
									"to_city_code": maping_content["to"],
									"dep_airport_name": response_body["jsons"]["ap"][maping_content["fr"]]["n"],
									"arr_airport_name": response_body["jsons"]["ap"][maping_content["to"]]["n"],
									"depart_terminal": maping_content["dt"],
									"arrival_terminal": maping_content["at"],
									"duration": Time.at(maping_content["dr"]).utc.strftime("%Hh %Mm"),
									"departure_time": flight_key[1],
									"arrival_time": maping_content["a"],
									"waiting_time": "",
									"departure_date": flight_key[2].scan(/^(\d{2})(\d{2})(\d{4})$/)[0].join("/"),
									"arrival_date": maping_content["ad"],
									"flight_key": maping_content["fk"]
								}
								content_arr << obj
							end
							flight_details_obj["flight_itinerary"] = content_arr
						end
						flight_routes_data << flight_details_obj
						
					end
				end
			end
		end
		
		render json: flight_routes_data
	end
end