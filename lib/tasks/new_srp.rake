require 'openssl'
require 'base64'
class KeyGen
	ENCRYPTIONKEY = "{0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 12, 15, 14}"
	APIKEY = 'dcc5b435bbda864a8a0df08bfd26cbc8'
	def self.encryption
		input = APIKEY.bytes
		rem = input.length % 16
		if rem > 0
			padArr = input.length+16-rem
			input = input.first(padArr)
		end
		begin
			cipher = OpenSSL::Cipher.new("AES-128-ECB")
			cipher.encrypt()
			cipher.key = ENCRYPTIONKEY
			crypt = cipher.update(APIKEY) + cipher.final()
			crypt_string = (Base64.encode64(crypt))
			return crypt_string 
		rescue Exception => exc
			puts ("Message for the encryption #{APIKEY} = #{exc.message}")
		end
	end

	def self.decryption
		begin
			cipher = OpenSSL::Cipher.new("AES-128-ECB")
			cipher.decrypt()
			cipher.key = ENCRYPTIONKEY
			tempkey = Base64.decode64(msg)
			crypt = cipher.update(tempkey)
			crypt << cipher.final()
			return crypt
		rescue Exception => exc
			puts ("Message for the decryption #{msg} = #{exc.message}")
		end
	end
end

namespace :new_srp do 
	task generate_enckey: :environment do 
		from ="BLR"
		to = "HYD"
		one_way_url="https://apistaging.cleartrip.com/air/1.0/search?from=#{from}&to=#{to}&depart-date=2019-09-28&adults=1&country=IN&currency=INR&&jsonVersion=1.0"
		two_way_url  = "https://apistaging.cleartrip.com/air/1.0/search?from=BOM&to=DEL&depart-date=2019-09-28&return-date=2019-09-30&adults=1&country=IN&currency=INR&&jsonVersion=1.0"
		p "Api Hit start #{Time.now.strftime("%H:%M:%S")}"
		one_way_response = HTTParty.get(one_way_url,headers:{"X-CT-API-KEY": "dcc5b435bbda864a8a0df08bfd26cbc8","X-CT-SOURCETYPE": "B2C","Accept-encoding": "gzip"})
		two_way_response = HTTParty.get(two_way_url,headers:{"X-CT-API-KEY": "dcc5b435bbda864a8a0df08bfd26cbc8","X-CT-SOURCETYPE": "B2C","Accept-encoding": "gzip"})
		p "Api Hit end #{Time.now.strftime("%H:%M:%S")}"
		one_way_result = {"psid"=>"","api_result" => []}
		two_way_result = {"psid"=>"","api_result" => []}
		uid = KeyGen.encryption
		uid = uid.gsub!("\n",'')
		one_way_fare_count = JSON.parse(one_way_response.body)["fare"].count
		two_way_fare_count = JSON.parse(two_way_response.body)["fare"].count
		one_way_result["psid"] = one_way_response["sid"]
		one_way_fares = one_way_response["fare"].values.flatten.take(10)
		two_way_fares = two_way_response["fare"].values.flatten.take(10)
		two_way_fares.each do |f|
			out_fare_key = f["N"]["fk"].split("|")[2]
			out_price = f["N"]["pr"].to_i
			return_price = ""
			return_fare_key = ""
			# intiate_booking_url = "https://apiweb.cleartrip.com/flights/initiate-booking?from=BLR&to=DEL&depart_date=28/09/2019&adults=1&childs=0&infants=0&class=Economy&psid=#{one_way_result['psid']}&out_price=#{out_price}&out_fare_key=#{out_fare_key}&uid=#{uid}"
			intiate_booking_url = "https://apiweb.cleartrip.com/flights/initiate-booking?from=BLR&to=DEL&depart_date=28/09/2019&adults=1&childs=0&infants=0&class=Economy&psid=#{one_way_result['psid']}&out_price=#{out_price}&out_fare_key=#{out_fare_key}&uid=#{uid}"
			fr = {out_fare_key: out_fare_key,out_price: out_price,intiate_booking_url: intiate_booking_url}
			one_way_result["api_result"]  << fr
		end
	end



	task one_response_iteration: :environment do 
		from ="BLR"
		to = "DXB"
		
		flight_routes_data = []
		one_way_url="https://apistaging.cleartrip.com/air/1.0/search?from=#{from}&to=#{to}&depart-date=2019-09-28&adults=1&country=IN&currency=INR&&jsonVersion=1.0"
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
				response_body["mapping"]["onward"].each do |maping|
					if maping["f"] == key
						map_data = maping["c"][0].kind_of?(Array) ? maping["c"][0] :  maping["c"]
						if map_data.length > 1
							flight_details_obj["carrier_codes"] = map_data.map{|c| response_body["content"][c]["fk"].split("_").reverse[3].split('-')[0]}.uniq
							flight_details_obj["dep_time"] =  map_data.map{|c| response_body["content"][c]["fk"].split("_").reverse[1]}[0]
							flight_details_obj["arr_time"] =   map_data.map{|c| response_body["content"][c]["a"]}.last
							flight_details_obj['flight_number'] = map_data.map{|c| response_body["content"][c]["fk"].split("_").reverse[3]}[0]
							dep_date = map_data.map{|c| response_body["content"][c]["fk"].split("_").reverse[2]}[0].insert(2, '/').insert(5, '/')
							flight_details_obj["dep_date"] =  dep_date
							flight_details_obj["arr_date"] = map_data.map{|c| response_body["content"][c]["ad"]}.last
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
							flight_details_obj["dep_city_code"] = flight_details_obj["via_info"].first
							flight_details_obj["arr_city_code"] = flight_details_obj["via_info"].last
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
								flight_details_obj["dep_city_code"] = maping_content["fr"]
								flight_details_obj["arr_city_code"] = maping_content["to"]
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
	end

	task two_way_response: :environment do 
		popular_routes = PopularRoute.where(section: "dom")
  	# flight_routes_data = []
  	count = 0
  	yesterday_date = (Date.today - 1).to_s
  	PopularRouteInfo.where(dep_date: yesterday_date).delete_all
  	popular_routes.each do |r|
  		count += 1
  		date = r.section == "dom" ? Date.today.to_s :  (Date.today+1).to_s
  		from = r.dep_city_code
  		to = r.arr_city_code
			flight_routes_data = []
			available_airlines = []
			two_way_result = {"route_total_fare"=>"","out_fare_key"=> "","session_id" =>"", "hbag"=>"","onward" => [],"return" => []}										
			two_way_url="https://apistaging.cleartrip.com/air/1.0/search?from=#{from}&to=#{to}&depart-date=#{date}&return-date=#{date}&adults=1&country=IN&currency=INR&jsonVersion=1.0"
			response_body = HTTParty.get(two_way_url,headers:{"X-CT-API-KEY": "dcc5b435bbda864a8a0df08bfd26cbc8","X-CT-SOURCETYPE": "B2C","Accept-encoding": "gzip"})
			if response_body.present? & response_body["fare"].present?
				response_body["fare"].each do |key,fdata|
					flight_details_onward_obj = {}
					flight_details_return_obj = {}
					if fdata["HBAG"].present?
						fdata = fdata["HBAG"]
					end
					data = fdata["dfd"] == "R" ? fdata["R"] : fdata["N"]
					two_way_result["route_total_fare"] = data["pr"].to_s rescue ""
					two_way_result["out_fare_key"] = data["fk"] rescue ""
					two_way_result ["session_id"] = response_body["sid"] rescue ""
					response_body["mapping"]["onward"].each do |maping|
						if maping["f"] == key
							map_data = maping["c"][0].kind_of?(Array) ? maping["c"][0] :  maping["c"]
							if map_data.length > 1
								flight_details_onward_obj["carrier_codes"] = map_data.map{|c| response_body["content"][c]["fk"].split("_").reverse[3].split('-')[0]}.uniq
								flight_details_onward_obj["dep_time"] =  map_data.map{|c| response_body["content"][c]["fk"].split("_").reverse[1]}[0]
								flight_details_onward_obj["arr_time"] =   map_data.map{|c| response_body["content"][c]["a"]}.last
								flight_details_onward_obj['flight_number'] = map_data.map{|c| response_body["content"][c]["fk"].split("_").reverse[3]}[0]
								dep_date = map_data.map{|c| response_body["content"][c]["fk"].split("_").reverse[2]}[0].insert(2, '/').insert(5, '/')
								flight_details_onward_obj["dep_date"] =  dep_date
								flight_details_onward_obj["arr_date"] = map_data.map{|c| response_body["content"][c]["ad"]}.last
								from_cities = map_data.map{|c| response_body["content"][c]["fr"]}
								to_cities = map_data.map{|c| response_body["content"][c]["to"]}
								flight_details_onward_obj["via_info"] = (from_cities+to_cities).uniq
								duration = map_data.map{|c| response_body["content"][c]["dr"].to_i}.reduce(:+)
								flight_details_onward_obj["duration"] =  Time.at(duration).utc.strftime("%Hh %Mm")
								flight_details_onward_obj["no_of_stops"] = flight_details_onward_obj["via_info"].length-2
								flight_details_onward_obj["dep_airport_name"] = response_body["jsons"]["ap"][flight_details_onward_obj["via_info"].first]["n"]
								flight_details_onward_obj["arr_airport_name"] = response_body["jsons"]["ap"][flight_details_onward_obj["via_info"].last]["n"]
								flight_details_onward_obj["dep_city_name"] = response_body["jsons"]["ap"][flight_details_onward_obj["via_info"].first]["c"]
								flight_details_onward_obj["arr_city_name"] = response_body["jsons"]["ap"][flight_details_onward_obj["via_info"].last]["c"]
								dep_city_code = flight_details_onward_obj["via_info"].first
								arr_city_code = flight_details_onward_obj["via_info"].last
								flight_details_onward_obj["dep_city_code"] = dep_city_code
								flight_details_onward_obj["arr_city_code"] = arr_city_code

								flight_details_onward_obj['dep_flight_key_format'] =  map_data.map{|c| response_body["content"][c]["fk"].split("_").reverse[3]}.first 
								flight_details_onward_obj['arr_flight_key_format'] =  map_data.map{|c| response_body["content"][c]["fk"].split("_").reverse[3]}.last
								flight_key_format = "#{flight_details_onward_obj['dep_flight_key_format']}_#{flight_details_onward_obj['arr_flight_key_format']}"
							
								dep_date_format =  map_data.map{|c| response_body["content"][c]["ad"]}.first.split("/").take(2).join("")
								arr_date_format =  map_data.map{|c| response_body["content"][c]["ad"]}.last.split("/").take(2).join("")
								dep_time_format = flight_details_onward_obj["dep_time"]
								arr_time_format = flight_details_onward_obj["arr_time"]
								flight_details_onward_obj["unique_flight_key"] = "#{dep_city_code}#{dep_date_format}_#{arr_city_code}#{arr_date_format}_#{dep_time_format}_#{arr_time_format}_#{flight_key_format}"
								content_arr = []
								map_data.each do |c|
									obj = {}
									content = response_body["content"][c] 
									flight_key = content["fk"].split("_").reverse
									flight_details_onward_obj["class"] = flight_key[0]
									flight_details_onward_obj["seat_availability"] = content["sa"]
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
								flight_details_onward_obj["flight_itinerary"] = content_arr
							else
								maping_content = response_body["content"][maping["c"][0]] rescue ""
								content_arr = []
								if maping_content.present?
									obj = {}
									flight_key = maping_content["fk"].split("_").reverse
									flight_details_onward_obj["carrier_codes"]= [flight_key[3].split('-')[0]]
									flight_details_onward_obj["via_info"] = [maping_content["fr"],maping_content["to"]]
									flight_details_onward_obj["dep_time"] = flight_key[1]
									flight_details_onward_obj["arr_time"] = maping_content["a"]
									flight_details_onward_obj['flight_number'] = flight_key[3]
									flight_details_onward_obj["duration"] = Time.at(maping_content["dr"]).utc.strftime("%Hh %Mm")
									flight_details_onward_obj["no_of_stops"]= 0
									flight_details_onward_obj["seat_availability"] =  maping_content["sa"]
									flight_details_onward_obj["dep_date"] =flight_key[2].scan(/^(\d{2})(\d{2})(\d{4})$/)[0].join("/")
									flight_details_onward_obj["arr_date"] = maping_content["ad"]
									flight_details_onward_obj["dep_airport_name"] = response_body["jsons"]["ap"][maping_content["fr"]]["n"]
									flight_details_onward_obj["arr_airport_name"] = response_body["jsons"]["ap"][maping_content["to"]]["n"]
									flight_details_onward_obj["dep_city_name"] = response_body["jsons"]["ap"][maping_content["fr"]]["c"]
									flight_details_onward_obj["arr_city_name"] = response_body["jsons"]["ap"][maping_content["to"]]["c"]
									dep_city_code = maping_content["fr"]
									arr_city_code = maping_content["to"]
									flight_details_onward_obj["dep_city_code"] = dep_city_code
									flight_details_onward_obj["arr_city_code"] = arr_city_code
									flight_details_onward_obj["departure_flight_key"] = maping_content["fk"]
									flight_details_onward_obj["arrival_flight_key"] = maping_content["fk"]
									flight_details_onward_obj['dep_flight_key_format'] =  map_data.map{|c| response_body["content"][c]["fk"].split("_").reverse[3]}.first 
									flight_details_onward_obj['arr_flight_key_format'] =  map_data.map{|c| response_body["content"][c]["fk"].split("_").reverse[3]}.last
									flight_key_format = "#{flight_details_onward_obj['dep_flight_key_format']}_#{flight_details_onward_obj['arr_flight_key_format']}"
									dep_date_format =  map_data.map{|c| response_body["content"][c]["ad"]}.first.split("/").take(2).join("")
									arr_date_format =  map_data.map{|c| response_body["content"][c]["ad"]}.last.split("/").take(2).join("")
									dep_time_format = flight_details_onward_obj["dep_time"]
									arr_time_format = flight_details_onward_obj["arr_time"]
									flight_details_onward_obj["unique_flight_key"] = "#{dep_city_code}#{dep_date_format}_#{arr_city_code}#{arr_date_format}_#{dep_time_format}_#{arr_time_format}_#{flight_key_format}"
									flight_details_onward_obj["class"] = flight_key[0]
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
								flight_details_onward_obj["flight_itinerary"] = content_arr
							end
							two_way_result["onward"] << flight_details_onward_obj
						end
					end

					response_body["mapping"]["return"].each do |maping|
						if maping["f"] == key
							map_data = maping["c"][0].kind_of?(Array) ? maping["c"][0] :  maping["c"]
							if map_data.length > 1
								flight_details_return_obj["carrier_codes"] = map_data.map{|c| response_body["content"][c]["fk"].split("_").reverse[3].split('-')[0]}.uniq
								flight_details_return_obj["dep_time"] =  map_data.map{|c| response_body["content"][c]["fk"].split("_").reverse[1]}[0]
								flight_details_return_obj["arr_time"] =   map_data.map{|c| response_body["content"][c]["a"]}.last
								flight_details_return_obj['flight_number'] = map_data.map{|c| response_body["content"][c]["fk"].split("_").reverse[3]}[0]
								dep_date = map_data.map{|c| response_body["content"][c]["fk"].split("_").reverse[2]}[0].insert(2, '/').insert(5, '/')
								flight_details_return_obj["dep_date"] =  dep_date
								flight_details_return_obj["arr_date"] = map_data.map{|c| response_body["content"][c]["ad"]}.last
								from_cities = map_data.map{|c| response_body["content"][c]["fr"]}
								to_cities = map_data.map{|c| response_body["content"][c]["to"]}
								flight_details_return_obj["via_info"] = (from_cities+to_cities).uniq
								duration = map_data.map{|c| response_body["content"][c]["dr"].to_i}.reduce(:+)
								flight_details_return_obj["duration"] =  Time.at(duration).utc.strftime("%Hh %Mm")
								flight_details_return_obj["no_of_stops"] = flight_details_return_obj["via_info"].length-2
								flight_details_return_obj["dep_airport_name"] = response_body["jsons"]["ap"][flight_details_return_obj["via_info"].first]["n"]
								flight_details_return_obj["arr_airport_name"] = response_body["jsons"]["ap"][flight_details_return_obj["via_info"].last]["n"]
								flight_details_return_obj["dep_city_name"] = response_body["jsons"]["ap"][flight_details_return_obj["via_info"].first]["c"]
								flight_details_return_obj["arr_city_name"] = response_body["jsons"]["ap"][flight_details_return_obj["via_info"].last]["c"]
								dep_city_code = flight_details_return_obj["via_info"].first
								arr_city_code = flight_details_return_obj["via_info"].last
								flight_details_return_obj["dep_city_code"] = dep_city_code
								flight_details_return_obj["arr_city_code"] = arr_city_code
								flight_details_return_obj['dep_flight_key_format'] =  map_data.map{|c| response_body["content"][c]["fk"].split("_").reverse[3]}.first 
								flight_details_return_obj['arr_flight_key_format'] =  map_data.map{|c| response_body["content"][c]["fk"].split("_").reverse[3]}.last
								flight_key_format = "#{flight_details_return_obj['dep_flight_key_format']}_#{flight_details_return_obj['arr_flight_key_format']}"
								dep_date_format =  map_data.map{|c| response_body["content"][c]["ad"]}.first.split("/").take(2).join("")
								arr_date_format =  map_data.map{|c| response_body["content"][c]["ad"]}.last.split("/").take(2).join("")
								dep_time_format = flight_details_return_obj["dep_time"]
								arr_time_format = flight_details_return_obj["arr_time"]
								flight_details_return_obj["unique_flight_key"] = "#{dep_city_code}#{dep_date_format}_#{arr_city_code}#{arr_date_format}_#{dep_time_format}_#{arr_time_format}_#{flight_key_format}"
								content_arr = []
								map_data.each do |c|
									obj = {}
									content = response_body["content"][c] 
									flight_key = content["fk"].split("_").reverse
									flight_details_return_obj["class"] = flight_key[0]
									flight_details_return_obj["seat_availability"] = content["sa"]
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
								flight_details_return_obj["flight_itinerary"] = content_arr
							else
								maping_content = response_body["content"][maping["c"][0]] rescue ""
								content_arr = []
								if maping_content.present?
									obj = {}
									flight_key = maping_content["fk"].split("_").reverse
									flight_details_return_obj["carrier_codes"]= [flight_key[3].split('-')[0]]
									flight_details_return_obj["via_info"] = [maping_content["fr"],maping_content["to"]]
									flight_details_return_obj["dep_time"] = flight_key[1]
									flight_details_return_obj["arr_time"] = maping_content["a"]
									flight_details_return_obj['flight_number'] = flight_key[3]
									flight_details_return_obj["duration"] = Time.at(maping_content["dr"]).utc.strftime("%Hh %Mm")
									flight_details_return_obj["no_of_stops"]= 0
									flight_details_return_obj["seat_availability"] =  maping_content["sa"]
									flight_details_return_obj["dep_date"] =flight_key[2].scan(/^(\d{2})(\d{2})(\d{4})$/)[0].join("/")
									flight_details_return_obj["arr_date"] = maping_content["ad"]
									flight_details_return_obj["dep_airport_name"] = response_body["jsons"]["ap"][maping_content["fr"]]["n"]
									flight_details_return_obj["arr_airport_name"] = response_body["jsons"]["ap"][maping_content["to"]]["n"]
									flight_details_return_obj["dep_city_name"] = response_body["jsons"]["ap"][maping_content["fr"]]["c"]
									flight_details_return_obj["arr_city_name"] = response_body["jsons"]["ap"][maping_content["to"]]["c"]
									dep_city_code = maping_content["fr"]
									arr_city_code = maping_content["to"]
									flight_details_return_obj["dep_city_code"] = dep_city_code
									flight_details_return_obj["arr_city_code"] = arr_city_code
									flight_details_return_obj["departure_flight_key"] = maping_content["fk"]
									flight_details_return_obj["arrival_flight_key"] = maping_content["fk"]
									flight_details_return_obj['dep_flight_key_format'] =  map_data.map{|c| response_body["content"][c]["fk"].split("_").reverse[3]}.first 
									flight_details_return_obj['arr_flight_key_format'] =  map_data.map{|c| response_body["content"][c]["fk"].split("_").reverse[3]}.last
									flight_key_format = "#{flight_details_return_obj['dep_flight_key_format']}_#{flight_details_return_obj['arr_flight_key_format']}"
									dep_date_format =  map_data.map{|c| response_body["content"][c]["ad"]}.first.split("/").take(2).join("")
									arr_date_format =  map_data.map{|c| response_body["content"][c]["ad"]}.last.split("/").take(2).join("")
									dep_time_format = flight_details_return_obj["dep_time"]
									arr_time_format = flight_details_return_obj["arr_time"]
									flight_details_return_obj["unique_flight_key"] = "#{dep_city_code}#{dep_date_format}_#{arr_city_code}#{arr_date_format}_#{dep_time_format}_#{arr_time_format}_#{flight_key_format}"
									flight_details_return_obj["class"] = flight_key[0]
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
								flight_details_return_obj["flight_itinerary"] = content_arr
							end
							two_way_result["return"] << flight_details_return_obj
						end
					end
					flight_routes_data << two_way_result
				end

				available_airlines = response_body["jsons"]["airline_names"].to_json
				flight_routes_data_json = flight_routes_data.to_json

				# route_info = PopularRouteInfo.find_or_create_by(dep_city_code: from,arr_city_code: to,dep_date: date)
				# route_info.en_route_info = flight_routes_data_json
				# route_info.save
				puts "#{count} -- #{from} --- #{to}---#{date} inserted !"
			end
	  end
	end

  task insert_popular_routes_info: :environment do 
  	popular_routes = PopularRoute.where(section: "int")
  	flight_routes_data = []
  	count = 0
  	yesterday_date = (Date.today - 1).to_s
  	PopularRouteInfo.where(dep_date: yesterday_date).delete_all
  	popular_routes.each do |r|
  		count += 1
  		dates = r.section == "dom" ? [Date.today.to_s] :  [(Date.today+1).to_s]
  		dates.each do |date|
	  		from = r.dep_city_code
	  		to = r.arr_city_code
				flight_routes_data = []
				available_airlines = []
				one_way_url="https://apistaging.cleartrip.com/air/1.0/search?from=#{from}&to=#{to}&depart-date=#{date}&adults=1&country=IN&currency=INR&&jsonVersion=1.0&limit50"
				response_body = HTTParty.get(one_way_url,headers:{"X-CT-API-KEY": "dcc5b435bbda864a8a0df08bfd26cbc8","X-CT-SOURCETYPE": "B2C","Accept-encoding": "gzip"})
				if response_body.present? & response_body["fare"].present?
					response_body["fare"].each do |key,fdata|
						flight_details_obj = {}
						if  fdata["HBAG"].present?
							fdata = fdata["HBAG"]
						end
						data = fdata["dfd"] == "R" ? fdata["R"] : fdata["N"]
						flight_details_obj["route_total_fare"] = data["pr"] rescue ""
						flight_details_obj["out_fare_key"] = data["fk"] rescue ""
						flight_details_obj ["session_id"] = response_body["sid"] rescue ""
						
						response_body["mapping"]["onward"].each do |maping|
							if maping["f"] == key
								map_data = maping["c"][0].kind_of?(Array) ? maping["c"][0] :  maping["c"]
								if map_data.length > 1
									flight_details_obj["carrier_codes"] = map_data.map{|c| response_body["content"][c]["fk"].split("_").reverse[3].split('-')[0]}.uniq
									flight_details_obj["dep_time"] =  map_data.map{|c| response_body["content"][c]["fk"].split("_").reverse[1]}[0]
									flight_details_obj["arr_time"] =   map_data.map{|c| response_body["content"][c]["a"]}.last
									flight_details_obj['flight_number'] = map_data.map{|c| response_body["content"][c]["fk"].split("_").reverse[3]}[0]
									dep_date = map_data.map{|c| response_body["content"][c]["fk"].split("_").reverse[2]}[0].insert(2, '/').insert(5, '/')
									flight_details_obj["dep_date"] =  dep_date
									flight_details_obj["arr_date"] = map_data.map{|c| response_body["content"][c]["ad"]}.last
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
					available_airlines = response_body["jsons"]["airline_names"].to_json
					flight_routes_data_json = flight_routes_data.to_json
					route_info = PopularRouteInfo.find_or_create_by(dep_city_code: from,arr_city_code: to,dep_date: date)
					route_info.en_route_info = flight_routes_data_json
					route_info.save
					puts "#{count} -- #{from} --- #{to}---#{date} inserted !"

					else
				end
					
  		end
	  end
  end
end