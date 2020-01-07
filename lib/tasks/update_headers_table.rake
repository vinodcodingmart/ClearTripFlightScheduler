# nohup bundle exec rake header_table:update_header_details QUEUE="*" --trace > rake.out 2>&1 &

namespace :header_table do
	desc "create_routes in header"
	task create_routes: :environment do
		# routes = UniqueRoute.all
		routes = FlightRoute.where(page_type: 'flight_schedule',route_type: 'direct',data_source: 'new_route',section: ['IN-int','IN-dom'])
		count = 0
		puts "insertion started!"
		routes.find_each do |r|
			route = Header.find_or_create_by(dep_city_code: r.dep_city_code,arr_city_code: r.arr_city_code,header_status: 'new_route')
			puts "#{count+=1} routes inseterd successfully!"
		end
		puts "insertion completed!"
	end


	desc "create_routes in header"
	task create_routes_from_postgres: :environment do

		routes = FlightRoute.where(page_type: 'flight_schedule',route_type: 'direct')
		count = 0
		puts "insertion started!"
		routes.find_each do |r|
			route = Header.find_by(dep_city_code: r.dep_city_code,arr_city_code: r.arr_city_code)
			if route.nil? || route==""
				hop = r.route_type==="direct" ? 0 : 1
				route = PackageFlightSchedule.find_by(dep_city_code: r.dep_city_code,arr_city_code: r.arr_city_code)
				distance = route.distance
				dep_airport_code = route.dep_airport_code
				arr_airport_code = route.arr_airport_code
				unique_route = UniqueRoute.create(dep_city_code: r.dep_city_code,arr_city_code: r.arr_city_code,dep_city_name: r.dep_city_name,arr_city_name: r.arr_city_name,dep_country_code: r.dep_country_code,arr_country_code: r.arr_country_code,weekly_flights_count: r.flight_count,hop: hop,distance: distance,dep_airport_code: dep_airport_code,arr_airport_code: arr_airport_code)
				header_route = Header.create(dep_city_code: r.dep_city_code,arr_city_code: r.arr_city_code )
				puts "#{count+=1} inseterd successfully! for == #{r.dep_city_code}-#{r.arr_city_code}"
			end
		end
		puts "insertion completed!"
	end

	desc "update dep_city_names and arr_city_names in unique_routes table"
	task :dep_and_arr_cities_name => :environment do
		CSV.foreach("public/updated_city_list.csv", :headers=>true).each_with_index do |row,index|
  		begin
        city_code = row[0]
        city_name_en = row[1]

        dep_cities = Header.where(dep_city_code: row[0])

        dep_cities.each do |dep_city|
        	dep_city.dep_city_name = city_name_en
        	dep_city.save!
        end

        arr_cities = Header.where(arr_city_code: row[0])
        arr_cities.each do |arr_city|
        	arr_city.arr_city_name = city_name_en
        	arr_city.save!
        end
        puts "#{index}-city_code=#{city_code} with dep_city_count=#{dep_cities.count} and arr_city_count=#{arr_cities.count}"
      rescue StandardError => e
        	
      end
		end
	end
	desc "create header details for routes"
	task update_header_details: :environment do
		def url_escape(url_string)
      unless url_string.blank?
        result = url_string.encode("UTF-8", :invalid => :replace, :undef => :replace).to_s
        result = result.gsub(/[\/]/,'-')
        result = result.gsub(/[^\x00-\x7F]+/, '') # Remove anything non-ASCII entirely (e.g. diacritics).
        result = result.gsub(/[^\w_ \-]+/i,   '') # Remove unwanted chars.
        result = result.gsub(/[ \-]+/i,      '-') # No more than one of the separator in a row.
        result = result.gsub(/^\-|\-$/i,      '') # Remove leading/trailing separator.
        result = result.downcase
      end
    end
		routes = Header.where(header_status: ["new_route","failed"])
		
		events_cities = ["Bangalore","Mumbai","Hyderabad","New Delhi"]
    weekend_getaway_cities = ["Agra", "Bhopal", "Goa", "Dehradun", "Ahmedabad", "Jammu", "Patna", "Kochi", "New Delhi", "Coorg", "Bangalore", "Mumbai", "Udaipur", "Chennai", "Pune"]
    featured_cities  =  ["Agra", "Gangtok", "Bhopal", "Goa", "Chandigarh", "Amritsar", "Gurgaon", "Dehradun", "Wayanad", "Ahmedabad", "Kolkata", "Kochi", "Jaipur", "Thekkady", "New Delhi", "Coorg", "Kullu", "Bangalore", "Alleppey", "Manali", "Mumbai", "Lucknow", "Hyderabad", "Indore", "Chennai", "Pune"]
    package_cities = ["Dehradun","Ahmedabad","Vijayawada","Rajkot","Belgaum","Leh","Mangalore","Vadodara","Mumbai","Lucknow","Madurai","Goa","Guwahati","Indore","Jaipur","Calicut","Tiruchirappally","Port Blair","Aizawl","Udaipur","Cochin","Raipur","Visakhapatnam","Hyderabad","Coimbatore","Khajuraho","Kullu Manali","Porbandar","Bhopal","Agra","Bangalore","Pune","Kanpur","Ranchi","Jorhat","Visakhapatnam","Mysore","Ranchi","Jodhpur","Dharamsala","Ludhiana","New Delhi","Agartala","Diu","Pantnagar","Bhubaneswar","Srinagar","Jammu","Patna","Hubli","Aurangabad","Shillong","Allahabad","Surat","Imphal","Jabalpur","Kolkata","Trivandrum","Chandigarh","Rajahmundry","Nagpur","Dibrugarh","Varanasi","Bhavnagar","Bhuj","Chennai","Amritsar","Jamnagar","Gwalior","Tirupati","Gorakhpur"]
    things_to_do_cities = ["Coorg","Madikeri","Bhimtal","Agra","Gangtok","Amboli","Junagadh","Srinagar","Munnar","Goa","Mysore","Chandigarh","Mohali","Ghaziabad","Amritsar","Ramanagara","Gadag","Nainital","Gurgaon","New delhi","Noida","Faridabad","Sonipat","Cherrapunjee","Lonavala","Mussoorie","Dehradun","Rishikesh","Jaisalmer","Dharamshala","Ahmedabad","Kolkata","Kochi","Jaipur","Pondicherry","Haridwar","Thekkady","Guwahati","Nashik","Shillong","Hassan","Bandipur","Jodhpur","Trivandrum","Kumbhalgarh","Mahabaleshwar","Binsar","Baiguney","Vijayawada","Ooty","Shimla","Kullu","Bangalore","Alleppey","Manali","Mumbai","Kollam","Alibaug","Kanha","Hyderabad","Udaipur","Chamba","Naukuchiyatal","Chennai","Pune"]
		count = 0
		begin
			routes.find_each do |r|
				begin
				route = UniqueRoute.find_by(dep_city_code: r.dep_city_code,arr_city_code: r.arr_city_code)

					if (route.dep_city_name != nil || route.arr_city_name != nil )
						dep_city_event = events_cities.include?(route.dep_city_name.titleize) ? "yes" : "no"
						dep_city_weekend_getaway = weekend_getaway_cities.include?(route.dep_city_name.titleize) ? "yes" : "no"
						dep_city_featured = featured_cities.include?(route.dep_city_name.titleize) ? "yes" : "no"
						dep_city_package = package_cities.include?(route.dep_city_name.titleize) ? "yes" : "no"
						dep_city_things_todo = things_to_do_cities.include?(route.dep_city_name.titleize) ? "yes" : "no"
						arr_city_event = events_cities.include?(route.arr_city_name.titleize) ? "yes" : "no"
						arr_city_weekend_getaway = weekend_getaway_cities.include?(route.dep_city_name.titleize) ? "yes" : "no"
						arr_city_featured = featured_cities.include?(route.arr_city_name.titleize) ? "yes" : "no"
						arr_city_package = package_cities.include?(route.arr_city_name.titleize) ? "yes" : "no"
						arr_city_things_todo = things_to_do_cities.include?(route.arr_city_name.titleize) ? "yes" : "no"

						if r.arr_city_code.present? && route.arr_country_code.present?
							airport_data = Airport.where(city_code: r.arr_city_code).first
							unless airport_data.present?
								airport_data = Airport.where(city_code: r.dep_city_code).first
							end
							lat =''
							long =''
							if airport_data.present?
								lat = airport_data.latitude.present? ? airport_data.latitude: ""
								long = airport_data.longitude.present? ? airport_data.longitude: ""
								country_name = airport_data.country_name
							end
							hotel_details = {"near_by_hotels" => [],
								"city_top_hotels" => [],
								"types_of_hotels" => []
							}
							train_details = { "origin_from" => [],
								"passing_from" => [],
								"train_stations" => { "dep_stations" => [],
									"arr_stations" => []
								}
							}

							if country_name.present?
								hotels_near_by_airport_url = "http://54.169.90.61/hotels/api/#{url_escape(country_name)}/near-by-hotels?lat=#{lat}&long=#{long}"
								arr_city_hotels_trains_url = "http://54.169.90.61/hotels/api/#{url_escape(country_name)}/#{url_escape(airport_data.city_name)}.json"

								hotels_near_by_airport_response = HTTParty.get(hotels_near_by_airport_url) if lat.present? && long.present?
								parsing_near_by_hotels = JSON.parse(hotels_near_by_airport_response.body) if hotels_near_by_airport_response.present? && hotels_near_by_airport_response.code == 200

								arr_city_hotels_trians_response = HTTParty.get(arr_city_hotels_trains_url)

								parsing_arr_city_hotels_trains = JSON.parse(arr_city_hotels_trians_response.body) if  arr_city_hotels_trians_response.present? && arr_city_hotels_trians_response.code == 200

								if parsing_near_by_hotels == nil
									parsing_near_by_hotels["hotels"] = parsing_arr_city_hotels_trains["hotels"] rescue []
								end
								hotel_details["near_by_hotels"] = parsing_near_by_hotels["hotels"] rescue []
								hotel_details["city_top_hotels"] = parsing_arr_city_hotels_trains["hotels"]  rescue []
								hotel_details["types_of_hotels"] = parsing_arr_city_hotels_trains["properties"] rescue []
								train_details["origin_from"] = parsing_arr_city_hotels_trains["trains"][0]["origin_from"] rescue []
								train_details["passing_from"] = parsing_arr_city_hotels_trains["trains"][1]["passing_from"] rescue []
								train_details["train_stations"]["dep_stations"] = parsing_dep_city_hotels_trains["train_stations"] rescue []
								train_details["train_stations"]["arr_stations"] = parsing_arr_city_hotels_trains["train_stations"] rescue []
							end
						end
						unless hotel_details.nil? || hotel_details==''
							r.update(header_status: "new_route_updated")
						else
							r.update(header_status: "new_route_failed")
						end
						# r_type = r.hop==0 ? "direct" : 'hop'
						r.dep_city_name = route.dep_city_name
						r.arr_city_name = route.arr_city_name
						r.route_type = "direct"
						r.hotel_details = hotel_details.to_s rescue nil
						r.trains_details = train_details.to_s rescue nil
						r.dep_city_event = dep_city_event rescue ""
						r.dep_city_weekend_getaway = dep_city_weekend_getaway rescue ""
						r.dep_city_featured = dep_city_featured rescue ""
						r.dep_city_package = dep_city_package rescue ""
						r.dep_city_things_todo = dep_city_things_todo rescue ""
						r.arr_city_event = arr_city_event rescue ""
						r.arr_city_weekend_getaway = arr_city_weekend_getaway rescue ""
						r.arr_city_featured = arr_city_featured rescue ""
						r.arr_city_package = arr_city_package rescue ""
						r.arr_city_things_todo = arr_city_things_todo rescue ""
						r.save
						puts "#{count+=1} header record inserted successfully! == #{r.dep_city_code}-#{r.arr_city_code} "
					else
						r.update(header_status: "no_unique_route_present")
					end
				rescue StandardError => e
					
					e.message
					e.backtrace
				end
			end
			puts "#{count}- Total Header insetions completed successfully!"
		rescue StandardError => e
			
			e.message
			e.backtrace
		end
	end
	desc "checking airline_overview structure"
	task :airline_overview => :environment do
			@carrier_code = '9W'
			@country_code = 'IN'
			@carrier_name = AirlineBrand.find_by(carrier_code: '9W').carrier_name
		  airline_dom_dom_routes =  UniqueRoute.joins(:flight_schedule_collectives).where(["flight_schedule_collectives.carrier_code=? and flight_schedule_collectives.dep_country_code= ? and flight_schedule_collectives.arr_country_code=?",@carrier_code,@country_code,@country_code]).group("flight_schedule_collectives.dep_city_code,flight_schedule_collectives.arr_city_code,unique_routes.weekly_flights_count,flight_schedule_collectives.flight_no").order("unique_routes.weekly_flights_count desc").limit(30)
		  popular_routes = {"dom_dom" => [],
		  									"dom_int" => [],
		  								  "int_int" => []}
		  # flight_schedule_service = FlightScheduleService.new {}
		  airline_dom_dom_routes.each do |route|
		  	record = FlightScheduleCollective.find_by(unique_route_id: route.id,carrier_code: @carrier_code)

		  	# min_price,max_price = flight_schedule_service.get_price_new(route.dep_city_code,route.arr_city_code,@carrier_code,@carrier_name)
		  	popular_routes["dom_dom"] << {
		  			"carrier_code" => @carrier_code,
		  			"carrier_name" => @carrier_name,
		  			"dep_city_name" => route.dep_city_name,
		  			"arr_city_name" => route.arr_city_name,
		  			"dep_city_code" => route.dep_city_code,
		  			"arr_city_code" => route.arr_city_code,
		  			"dep_airport_code" => route.dep_airport_code,
		  			"arr_airport_code" => route.arr_airport_code,
		  			"dep_time" => record.dep_time,
		  			"arr_time" => record.arr_time,
		  			"op_days" => record.days_of_operation,
		  			"flight_no"=> record.flight_no
		  			# "min_price" => min_price,
		  			# "max_price" => max_price
		  	}
		  end
		  	

	  airline_dom_int_routes =  UniqueRoute.joins(:flight_schedule_collectives).where(["flight_schedule_collectives.carrier_code=? and (flight_schedule_collectives.dep_country_code=? and flight_schedule_collectives.arr_country_code!=?)OR(flight_schedule_collectives.dep_country_code!=? and flight_schedule_collectives.arr_country_code=?)  ",@carrier_code,@country_code,@country_code,@country_code,@country_code]).group("flight_schedule_collectives.dep_city_code,flight_schedule_collectives.arr_city_code,unique_routes.weekly_flights_count").order("unique_routes.weekly_flights_count desc").limit(30)
	  airline_int_int_routes =  UniqueRoute.joins(:flight_schedule_collectives).where(["flight_schedule_collectives.carrier_code=? and (flight_schedule_collectives.dep_country_code!=? and flight_schedule_collectives.arr_country_code!=?)",@carrier_code,@country_code,@country_code]).group("flight_schedule_collectives.dep_city_code,flight_schedule_collectives.arr_city_code,unique_routes.weekly_flights_count").order("unique_routes.weekly_flights_count desc").limit(30)
	  
	end
	task update_city_names: :environment do
	 puts '--------Start adding Cities --------'
   csv_file = "#{Rails.root}/public/updated_city_list.csv"

   csv_text = File.read(csv_file)
   csv = CSV.parse(csv_text, headers: :first_row, col_sep: ",")
   count = 0
   csv.each do |row|
	    begin
	      city_code = row[0]
	      city_name_en = row[1]
	      dep_cities = Header.where(dep_city_code: city_code).update_all(dep_city_name: city_name_en)
	      # dep_cities.each do |dep_city|
	      # 	dep_city.dep_city_name =  city_name_en
	      # 	dep_city.save
	      # end
	      arr_cities = Header.where(arr_city_code: city_code).update_all(arr_city_name: city_name_en)
	      # arr_cities.each do |arr_city|
	      # 	arr_city.arr_city_name = city_name_en
	      # 	arr_city.save
	      # end
	    puts "#{count+=1} updated - #{city_code} with dep_cities = #{dep_cities} and arr_cities = #{arr_cities}"
	    rescue StandardError => e
	    	
	    end
    end
	end
end
