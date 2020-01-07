namespace :srp do 
  task :carrier_api_response => :environment do 
     
   one_way_url="https://apistaging.cleartrip.com/air/1.0/search?from=DEL&to=BOM&depart-date=2019-10-24&adults=2&children=2&infants=2&jsonVersion=1.0&carrier=6E&limit=30"
   response_body = HTTParty.get(one_way_url,headers:{"X-CT-API-KEY": "dcc5b435bbda864a8a0df08bfd26cbc8","X-CT-SOURCETYPE": "B2C","Accept-encoding": "gzip"})
   # response_body = HTTParty.get(one_way_url)
   airline_routes_info = []
   if response_body.present? & response_body["fare"].present?
    available_airlines_fromatted = []
    response_body["jsons"]["airline_names"].keys.each do |k|
      aName = k == "AI" ? "Air India" : response_body["jsons"]["airline_names"][k]
      ov_link = format_overview_link(aName)
      fAirline =  aName.downcase.gsub(" ",'-').gsub('--','-')
      obj ={
        airline_name:  aName,
        airline_code: k,
        link:ov_link,
        formated_airline:fAirline
      }
      available_airlines_fromatted.push << obj
    end
    response_body["fare"].each do |key,fdata|
      airline_route_obj = {}
      hbag = false
      if  fdata["HBAG"].present?
        fdata = fdata["HBAG"]
        hbag = true
      end
      data = fdata["dfd"] == "R" ? fdata["R"] : fdata["N"]
      airline_route_obj["refundable"] = fdata["dfd"] == "R" ? true : false
      airline_route_obj["hbag"] =  hbag
      airline_route_obj["route_total_fare"] = data["pr"] rescue ""
      airline_route_obj["out_fare_key"] = data["fk"] rescue ""
      airline_route_obj ["session_id"] = response_body["sid"] rescue ""
      response_body["mapping"]["onward"].each do |maping|
        if maping["f"] == key
          map_data = maping["c"][0].kind_of?(Array) ? maping["c"][0] :  maping["c"]
          if map_data.length > 1
            airline_route_obj["dep_time"] =  map_data.map{|c| response_body["content"][c]["fk"].split("_").reverse[1]}[0]
            airline_route_obj["arr_time"] =   map_data.map{|c| response_body["content"][c]["a"]}.last
            airline_route_obj['flight_number'] = map_data.map{|c| response_body["content"][c]["fk"].split("_").reverse[3]}[0]
            dep_date = map_data.map{|c| response_body["content"][c]["fk"].split("_").reverse[2]}[0].insert(2, '/').insert(5, '/')
            airline_route_obj["dep_date"] =  dep_date
            airline_route_obj["arr_date"] = map_data.map{|c| response_body["content"][c]["ad"]}.last
            from_cities = map_data.map{|c| response_body["content"][c]["fr"]}
            to_cities = map_data.map{|c| response_body["content"][c]["to"]}
            airline_route_obj["via_info"] = (from_cities+to_cities).uniq
            duration = map_data.map{|c| response_body["content"][c]["dr"].to_i}.reduce(:+)
            airline_route_obj["formated_duration"] = duration
            airline_route_obj["duration"] =  Time.at(duration).utc.strftime("%Hh %Mm")
            airline_route_obj["no_of_stops"] = airline_route_obj["via_info"].length-2
            airline_route_obj["dep_airport_name"] = response_body["jsons"]["ap"][airline_route_obj["via_info"].first]["n"]
            airline_route_obj["arr_airport_name"] = response_body["jsons"]["ap"][airline_route_obj["via_info"].last]["n"]
            airline_route_obj["dep_city_name"] = response_body["jsons"]["ap"][airline_route_obj["via_info"].first]["c"]
            airline_route_obj["arr_city_name"] = response_body["jsons"]["ap"][airline_route_obj["via_info"].last]["c"]
            dep_city_code = airline_route_obj["via_info"].first
            arr_city_code = airline_route_obj["via_info"].last
            airline_route_obj["dep_city_code"] = dep_city_code
            airline_route_obj["arr_city_code"] = arr_city_code
            airline_route_obj['dep_flight_key_format'] =  map_data.map{|c| response_body["content"][c]["fk"].split("_").reverse[3]}.first 
            airline_route_obj['arr_flight_key_format'] =  map_data.map{|c| response_body["content"][c]["fk"].split("_").reverse[3]}.last
            flight_key_format = "#{airline_route_obj['dep_flight_key_format']}_#{airline_route_obj['arr_flight_key_format']}"
            dep_date_format =  map_data.map{|c| response_body["content"][c]["ad"]}.first.split("/").take(2).join("")
            arr_date_format =  map_data.map{|c| response_body["content"][c]["ad"]}.last.split("/").take(2).join("")
            dep_time_format = airline_route_obj["dep_time"]
            arr_time_format = airline_route_obj["arr_time"]
            airline_route_obj["unique_flight_key"] = "#{dep_city_code}#{dep_date_format}_#{arr_city_code}#{arr_date_format}_#{dep_time_format}_#{arr_time_format}_#{flight_key_format}"
            content_arr = []
            airline_route_obj["format_dep_time"] = Time.strptime(airline_route_obj["dep_time"],"%H:%M").to_time.strftime("%I:%M %p")
            airline_route_obj["format_arr_time"] = Time.strptime(airline_route_obj["arr_time"],"%H:%M").to_time.strftime("%I:%M %p")
            map_data.each do |c|
              obj = {}
              content = response_body["content"][c] 
              flight_key = content["fk"].split("_").reverse
              airline_route_obj["class"] = flight_key[0]
              airline_route_obj["seat_availability"] = content["sa"]
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
                "waiting_time": "",
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
            airline_route_obj["flight_itinerary"] = content_arr
          else
            maping_content = response_body["content"][maping["c"][0]] rescue ""
            content_arr = []
            if maping_content.present?
              obj = {}
              flight_key = maping_content["fk"].split("_").reverse  
              airline_route_obj["via_info"] = [maping_content["fr"],maping_content["to"]]
              airline_route_obj["dep_time"] = flight_key[1]
              airline_route_obj["arr_time"] = maping_content["a"]
              airline_route_obj['flight_number'] = flight_key[3]
              airline_route_obj["duration"] = Time.at(maping_content["dr"]).utc.strftime("%Hh %Mm")
              airline_route_obj["formated_duration"] = maping_content["dr"]
              airline_route_obj["no_of_stops"]= 0
              airline_route_obj["seat_availability"] =  maping_content["sa"]
              airline_route_obj["dep_date"] =flight_key[2].scan(/^(\d{2})(\d{2})(\d{4})$/)[0].join("/")
              airline_route_obj["arr_date"] = maping_content["ad"]
              airline_route_obj["dep_airport_name"] = response_body["jsons"]["ap"][maping_content["fr"]]["n"]
              airline_route_obj["arr_airport_name"] = response_body["jsons"]["ap"][maping_content["to"]]["n"]
              airline_route_obj["dep_city_name"] = response_body["jsons"]["ap"][maping_content["fr"]]["c"]
              airline_route_obj["arr_city_name"] = response_body["jsons"]["ap"][maping_content["to"]]["c"]
              dep_city_code = maping_content["fr"]
              arr_city_code = maping_content["to"]
              airline_route_obj["dep_city_code"] = dep_city_code
              airline_route_obj["arr_city_code"] = arr_city_code
              airline_route_obj["departure_flight_key"] = maping_content["fk"]
              airline_route_obj["arrival_flight_key"] = maping_content["fk"]
              airline_route_obj['dep_flight_key_format'] =  map_data.map{|c| response_body["content"][c]["fk"].split("_").reverse[3]}.first 
              airline_route_obj['arr_flight_key_format'] =  map_data.map{|c| response_body["content"][c]["fk"].split("_").reverse[3]}.last
              flight_key_format = "#{airline_route_obj['dep_flight_key_format']}_#{airline_route_obj['arr_flight_key_format']}"
              dep_date_format =  map_data.map{|c| response_body["content"][c]["ad"]}.first.split("/").take(2).join("")
              arr_date_format =  map_data.map{|c| response_body["content"][c]["ad"]}.last.split("/").take(2).join("")
              dep_time_format = airline_route_obj["dep_time"]
              arr_time_format = airline_route_obj["arr_time"]
              airline_route_obj["unique_flight_key"] = "#{dep_city_code}#{dep_date_format}_#{arr_city_code}#{arr_date_format}_#{dep_time_format}_#{arr_time_format}_#{flight_key_format}"
              airline_route_obj["class"] = flight_key[0]
              airline_route_obj["format_dep_time"] = Time.strptime(airline_route_obj["dep_time"],"%H:%M").to_time.strftime("%I:%M %p")
              airline_route_obj["format_arr_time"] = Time.strptime(airline_route_obj["arr_time"],"%H:%M").to_time.strftime("%I:%M %p")
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
            airline_route_obj["flight_itinerary"] = content_arr
          end
          airline_routes_info << airline_route_obj
        end
      end
    end
  end
  airline_routes_info = airline_routes_info.sort_by{|r| r["route_total_fare"]}
  return {airline_routes_info: airline_routes_info,available_airlines: available_airlines_fromatted}

  end
end
     
