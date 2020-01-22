require 'net/http'
class FlightBookingService
	include ApplicationHelper
	attr_accessor :no_price
	def initialize(args={})
		@dep_city_code =  args[:dep_city_code]
		@arr_city_code = args[:arr_city_code]
		@dep_city_name = args[:dep_city_name]
		@arr_city_name = args[:arr_city_name]
		@dep_city_name_ar = args[:dep_city_name_ar]
		@arr_city_name_ar = args[:arr_city_name_ar]
		@dep_country_code = args[:dep_country_code]
		@arr_country_code = args[:arr_country_code]
		@carrier_code = args[:carrier_code]
		@carrier_name = args[:carrier_name]
		@carrier_name_ar = args[:carrier_name_ar]
		@country_code = args[:country_code]
		@section = args[:section]
		@language = args[:language]
		@airline_brand_collective = "#{@country_code.titleize}AirlineBrandCollective".constantize
	end

		def overview_search_widget_popular_routes
		popular_cities =  {"sa" =>  [
												{city_code: 'AUH',city_name: "Abu Dhabi",airport_name: "AE - Abu Dhabi International Airport"},
												{city_code: "BAH" ,city_name: "Bahrain",airport_name: "BH - Bahrain"},
												{city_code: "DMM" ,city_name: "Dammam",airport_name: "SA - King Fahad"},
												{city_code: "DOH" ,city_name: "Doha",airport_name: "QA - Doha"},
												{city_code: "DXB" ,city_name: "Dubai",airport_name: "AE - Dubai International Airport"},
												{city_code: "JED" ,city_name: "Jeddah",airport_name: "SA - Jeddah"},
												{city_code: "KWI" ,city_name: "Kuwait",airport_name: "KW - Kuwait"},
												{city_code: "MCT" ,city_name: "Muscat",airport_name: "OM - Seeb"},
												{city_code: "RUH" ,city_name: "Riyadh",airport_name: "SA - King Khaled"},
												{city_code: "SHJ" ,city_name: "Sharjah" , airport_name: "AE - Sharjah]"}
									],
									"bh" => [
										{city_code: "AUH" , city_name: "Abu Dhabi" , airport_name: "AE - Abu Dhabi International Airport " },
										{city_code: "BAH"  , city_name: "Bahrain" ,  airport_name: "BH - Bahrain " } , 
										{city_code: "DMM" , city_name: "Dammam" ,  airport_name: "SA - King Fahad "} , 
										{city_code: "DOH" , city_name: "Doha" ,  airport_name: "QA - Doha" } , 
										{city_code: "DXB" , city_name: "Dubai" ,  airport_name: "Dubai International Airport"} , 
										{city_code: "JED" , city_name: "Jeddah" ,  airport_name: " SA - Jeddah" } , 
										{city_code: "KWI"  , city_name: "Kuwait" ,  airport_name: "KW - Kuwait"} , 
										{city_code: "MCT" , city_name:  "Muscat" ,  airport_name: "OM - Seeb "} , 
										{city_code: "MED" , city_name: "Madinah" ,  airport_name: "Prince Mohammad Bin Abdulaziz" } , 
										{city_code: "RUH" , city_name: "Riyadh" ,  airport_name: "SA - King Khaled " } , 
										{city_code: "SHJ"  , city_name:  "Sharjah" ,  airport_name: "AE - Sharjah" }
									]}
		return popular_cities["#{@country_code.downcase}"]
	end

	def airline_more_routes_new
		int_to_int_query = "select * from airline_unique_routes where carrier_code='#{@carrier_code}' and dep_country_code!='#{@country_code}' and arr_country_code!='#{@country_code}' and dep_city_code != '#{@dep_city_code}' and arr_city_code != '#{@arr_city_code}' order by flight_count  desc"
		dom_to_int_query = "select * from airline_unique_routes where carrier_code='#{@carrier_code}' and dep_country_code='#{@country_code}' and arr_country_code!='#{@country_code}' and dep_city_code != '#{@dep_city_code}' and arr_city_code != '#{@arr_city_code}' order by flight_count desc"
		int_to_dom_query = "select * from airline_unique_routes where carrier_code = '#{@carrier_code}' and dep_country_code != '#{@country_code}' and arr_country_code = '#{@country_code}' and dep_city_code != '#{@dep_city_code}' and arr_city_code != '#{@arr_city_code}' order by flight_count  desc"
		dom_to_dom_query = "select * from airline_unique_routes where carrier_code = '#{@carrier_code}' and dep_country_code = '#{@country_code}' and arr_country_code = '#{@country_code}' and dep_city_code != '#{@dep_city_code}' and arr_city_code != '#{@arr_city_code}' order by flight_count  desc"
		airline_int_int_routes = AirlineUniqueRoute.find_by_sql(int_to_int_query)
		airline_dom_int_routes = AirlineUniqueRoute.find_by_sql(int_to_int_query)
		airline_int_dom_routes = AirlineUniqueRoute.find_by_sql(int_to_dom_query)
		airline_dom_dom_routes = AirlineUniqueRoute.find_by_sql(dom_to_dom_query)
		more_routes  = airline_dom_dom_routes + airline_dom_int_routes + airline_int_dom_routes + airline_int_int_routes
		return more_routes
	end

	# TOdo: optimize the query
	def airline_more_routes
		collecitves = "#{@country_code.downcase}_flight_schedule_collectives"
		collectives_symbol = collecitves.to_sym
		@airline_dom_dom_routes =  UniqueRoute.joins(collectives_symbol).where(["#{collecitves}.carrier_code=? and #{collecitves}.dep_city_code!=#{collecitves}.arr_city_code and #{collecitves}.dep_country_code= ? and #{collecitves}.arr_country_code=?",@carrier_code,@country_code,@country_code]).group("#{collecitves}.dep_city_code,#{collecitves}.arr_city_code,unique_routes.weekly_flights_count,#{collecitves}.flight_no").order("unique_routes.weekly_flights_count desc").limit(100)
		@airline_dom_int_routes =  UniqueRoute.joins(collectives_symbol).where(["#{collecitves}.carrier_code=? and #{collecitves}.dep_city_code!=#{collecitves}.arr_city_code and (#{collecitves}.dep_country_code=? and #{collecitves}.arr_country_code!=?)OR(#{collecitves}.dep_country_code!=? and #{collecitves}.arr_country_code=?)",@carrier_code,@country_code,@country_code,@country_code,@country_code]).group("#{collecitves}.dep_city_code,#{collecitves}.arr_city_code,unique_routes.weekly_flights_count").order("unique_routes.weekly_flights_count desc").limit(100)
		@airline_int_int_routes =  UniqueRoute.joins(collectives_symbol).where(["#{collecitves}.carrier_code=? and #{collecitves}.dep_city_code!=#{collecitves}.arr_city_code and (#{collecitves}.dep_country_code!=? and #{collecitves}.arr_country_code!=?)",@carrier_code,@country_code,@country_code]).group("#{collecitves}.dep_city_code,#{collecitves}.arr_city_code,unique_routes.weekly_flights_count").order("unique_routes.weekly_flights_count desc").limit(100)
		more_routes = @airline_dom_dom_routes + @airline_dom_int_routes + @airline_int_int_routes
		return more_routes
	end

	def rhs_top_hotels
		rhs_hotel = RhsHotel.first
		top_rhs_hotels = eval(rhs_hotel.city)
		current_value = rhs_hotel.current_value
		if current_value <= 19
			top_hotels = top_rhs_hotels[current_value,10]
			current_value = current_value+10
			rhs_hotel.update(current_value:current_value)
		else
			remaining_value = (29 % current_value )
			extra_value = 10-remaining_value
			top_hotels1 = top_rhs_hotels[current_value,remaining_value]
			top_hotels2 =  top_rhs_hotels[0,extra_value]
			top_hotels = top_hotels1 + top_hotels2
			rhs_hotel.update(current_value:extra_value)
		end
		return {rhs_top_hotels: top_hotels}
	end

	def header_airline_routes
		header_routes = { "dom_dom" => [],
			"dom_int" => [],
			"int_int" => []}
			unless @airline_dom_dom_routes.nil? || @airline_dom_dom_routes.count == 0
				@airline_dom_dom_routes[0...10].each do |route|
					record = @airline_brand_collective.find_by(carrier_code: @carrier_code,unique_route_id: route.id)
					if record.present? && record != nil
						header_routes["dom_dom"] << {
							"carrier_code" => @carrier_code,
							"carrier_name" => @carrier_name,
							"dep_city_name" => route.dep_city_name,
							"arr_city_name" => route.arr_city_name,
							"dep_city_name_ar" => route.dep_city_name_ar,
							"arr_city_name_ar" => route.arr_city_name_ar,
						}
					end
				end
			end
			unless @airline_dom_int_routes.nil? || @airline_dom_int_routes.count == 0
				@airline_dom_int_routes[0...10].each do |route|
					record = @airline_brand_collective.find_by(carrier_code: @carrier_code,unique_route_id: route.id)
					if record.present? && record != nil
						header_routes["dom_int"] << {
							"carrier_code" => @carrier_code,
							"carrier_name" => @carrier_name,
							"dep_city_name" => route.dep_city_name,
							"dep_city_name_ar" => CityName.find_by(city_code: route.dep_city_code).city_name_ar,
							"arr_city_name" => route.arr_city_name,
							"arr_city_name_ar" => CityName.find_by(city_code: route.arr_city_code).city_name_ar
						}
					end
				end
			end
			unless @airline_dom_int_routes.nil? || @airline_dom_int_routes.count == 0
				@airline_dom_int_routes[0...10].each do |route|
					record = @airline_brand_collective.find_by(carrier_code: @carrier_code,unique_route_id: route.id)
					if record.present? && record != nil
						header_routes["int_int"] << {
							"carrier_code" => @carrier_code,
							"carrier_name" => @carrier_name,
							"dep_city_name" => route.dep_city_name,
							"dep_city_name_ar" => CityName.find_by(city_code: route.dep_city_code).city_name_ar,
							"arr_city_name" => route.arr_city_name,
							"arr_city_name_ar" => CityName.find_by(city_code: route.arr_city_code).city_name_ar
						}
					end
				end
			end
			if header_routes['dom_int'].count == 0 || header_routes['dom_int'].nil?
				header_routes['dom_int'] = header_routes['int_int']
			elsif header_routes['dom_int'].count > 0
				header_routes['dom_int'] = header_routes['dom_int'] + header_routes['int_int']
			end
			return header_routes
		end


		def airline_popular_routes

			@popular_routes = {"dom_dom" => [],
				"dom_int" => [],
				"int_int" => []
			}
			brand_collective = "#{@country_code.downcase}_airline_brand_collectives"
			brand_collective_sym = brand_collective.to_sym
			airline_dom_dom_routes = 	UniqueRoute.joins(brand_collective_sym).where("#{brand_collective}.carrier_code=? and unique_routes.dep_country_code=? and unique_routes.arr_country_code=?",@carrier_code,@country_code,@country_code).group("#{brand_collective}.flight_no,unique_routes.dep_city_code,unique_routes.arr_city_code").order("unique_routes.weekly_flights_count desc").limit(10)
			airline_dom_int_routes = 	UniqueRoute.joins(brand_collective_sym).where("#{brand_collective}.carrier_code=? and(( unique_routes.dep_country_code!=? and unique_routes.arr_country_code=?) OR (unique_routes.dep_country_code=? and unique_routes.arr_country_code!=?))",@carrier_code,@country_code,@country_code,@country_code,@country_code).group("#{brand_collective}.flight_no,unique_routes.dep_city_code,unique_routes.arr_city_code").order("unique_routes.weekly_flights_count desc").limit(10)
			airline_int_int_routes = 	UniqueRoute.joins(brand_collective_sym).where("#{brand_collective}.carrier_code=? and unique_routes.dep_country_code!=? and unique_routes.arr_country_code!=?",@carrier_code,@country_code,@country_code).group("#{brand_collective}.flight_no,unique_routes.dep_city_code,unique_routes.arr_city_code").order("unique_routes.weekly_flights_count desc").limit(10)
			unless airline_dom_dom_routes.nil? || @airline_dom_dom_routes.count == 0
				airline_dom_dom_routes.each do |route|
					record = @airline_brand_collective.find_by(unique_route_id: route.id)
					if record.present? && record != nil
							min_price,max_price = get_price(route.dep_city_code,route.arr_city_code,@carrier_code,@carrier_name,@country_code)
								@popular_routes["dom_dom"] << {
								"carrier_code" => @carrier_code,
								"carrier_name" => @carrier_name,
								"dep_city_name" => route.dep_city_name,
								"dep_city_name_ar" => route.dep_city_name_ar,
								"arr_city_name" => route.arr_city_name,
								"arr_city_name_ar" => route.arr_city_name_ar,
								"dep_city_code" => route.dep_city_code,
								"arr_city_code" => route.arr_city_code,
								"dep_airport_code" => route.dep_airport_code,
								"arr_airport_code" => route.arr_airport_code,
								"dep_time" => record.dep_time,
								"arr_time" => record.arr_time,
								"op_days" => record.days_of_operation,
								"flight_no"=> record.flight_no,
								"min_price" => min_price,
								"max_price" => max_price
							}
					end
				end
			end
			unless airline_dom_int_routes.nil? || airline_dom_int_routes.count == 0
			airline_dom_int_routes.each do |route|
				record = @airline_brand_collective.find_by(unique_route_id: route.id)
					if record.present? && record != nil
						min_price,max_price = get_price(route.dep_city_code,route.arr_city_code,@carrier_code,@carrier_name,@country_code)
						@popular_routes["dom_int"] << {
							"carrier_code" => @carrier_code,
							"carrier_name" => @carrier_name,
							"dep_city_name" => route.dep_city_name,
							"dep_city_name_ar" => route.dep_city_name_ar,
							"arr_city_name" => route.arr_city_name,
							"arr_city_name_ar" => route.arr_city_name_ar,
							"dep_city_code" => route.dep_city_code,
							"arr_city_code" => route.arr_city_code,
							"dep_airport_code" => route.dep_airport_code,
							"arr_airport_code" => route.arr_airport_code,
							"dep_time" => record.dep_time,
							"arr_time" => record.arr_time,
							"op_days" => record.days_of_operation,
							"flight_no"=> record.flight_no,
							"min_price" => min_price,
							"max_price" => max_price
						}
					end
				end
			end

			unless airline_int_int_routes.nil? || airline_int_int_routes.count == 0
			airline_int_int_routes.each do |route|
				record = @airline_brand_collective.find_by(unique_route_id: route.id)
					if record.present? && record != nil
						min_price,max_price = get_price(route.dep_city_code,route.arr_city_code,@carrier_code,@carrier_name,@country_code)
						@popular_routes["int_int"] << {
							"carrier_code" => @carrier_code,
							"carrier_name" => @carrier_name,
							"dep_city_name" => route.dep_city_name,
							"dep_city_name_ar" => route.dep_city_name_ar,
							"arr_city_name" => route.arr_city_name,
							"arr_city_name_ar" => route.arr_city_name_ar,
							"dep_city_code" => route.dep_city_code,
							"arr_city_code" => route.arr_city_code,
							"dep_airport_code" => route.dep_airport_code,
							"arr_airport_code" => route.arr_airport_code,
							"dep_time" => record.dep_time,
							"arr_time" => record.arr_time,
							"op_days" => record.days_of_operation,
							"flight_no"=> record.flight_no,
							"min_price" => min_price,
							"max_price" => max_price
						}
					end
				end
			end
			if @popular_routes['dom_int'].count == 0 || @popular_routes['dom_int'].nil?
				@popular_routes['dom_int'] = @popular_routes['int_int']
			elsif @popular_routes['dom_int'].count > 0
				@popular_routes['dom_int'] = @popular_routes['dom_int'] + @popular_routes['int_int']
			end
			return @popular_routes
		end

		def brand_top_sectors
			brand_layout_values = {}
			to = I18n.t("to")
			if @popular_routes["dom_dom"].present?
				dom_routes = @popular_routes["dom_dom"].take(4)
				if dom_routes.count==1
					if @language == "en"
						brand_layout_values["airline_route_list"] = "<a href=\"/flight-schedule/#{url_escape(dom_routes.first["dep_city_name"])}-#{url_escape(dom_routes.first["arr_city_name"])}-flights.html\">  #{dom_routes.first['dep_city_name']} #{to} #{dom_routes.first['arr_city_name']}  </a>"
					else
						brand_layout_values["airline_route_list"] = "<a href=\"/flight-schedule/#{url_escape(dom_routes.first["dep_city_name"])}-#{url_escape(dom_routes.first["arr_city_name"])}-flights.html\">  #{dom_routes.first['dep_city_name_ar']} #{to} #{dom_routes.first['arr_city_name_ar']}  </a>"
					end
					brand_layout_values["occasional_flights"] = nil
				else
					if @language == "en"
						brand_layout_values["airline_route_list"] = (dom_routes.collect{|r| "<a href=\"/flight-schedule/#{url_escape(r['dep_city_name'])}-#{url_escape(r['arr_city_name'])}-flights.html\">  #{r['dep_city_name']} #{to} #{r['arr_city_name']} </a>"}.compact.join(", "))
						brand_layout_values["occasional_flights"] = (dom_routes.collect{|r| "#{r['dep_city_name']} #{to}  #{r['arr_city_name']}"}.compact.to_sentence) rescue []
					else
						brand_layout_values["airline_route_list"] = (dom_routes.collect{|r| "<a href=\"/#{@language}/flight-schedule/#{url_escape(r['dep_city_name'])}-#{url_escape(r['arr_city_name'])}-flights.html\">  #{r['dep_ciry_name_ar']} #{to}  #{r['arr_city_name_ar']}  </a>".html_safe}.compact.to_sentence(:last_word_connector => ' و '))
						brand_layout_values["occasional_flights"] = (dom_routes.collect{|r| "#{r['dep_city_name_ar']} #{to}  #{r['arr_city_name_ar']}"}.compact.to_sentence(:last_word_connector => ' و ')) rescue []
					end
				end
			end
			if @popular_routes["int_int"].present?
				int_routes = @popular_routes["int_int"].take(4)
				int_occasional_routes = @popular_routes["int_int"].reverse.take(4)
				if int_routes.count == 1
					if @language == "en"
						brand_layout_values["airline_route_list"] = "<a href=\"/flight-schedule/#{url_escape(int_routes.first['dep_city_name'])}-#{url_escape(int_routes.first['arr_city_name'])}-flights.html\">  #{int_routes.first['dep_city_name']} #{to} #{int_routes.first['arr_city_name']}  </a>"
					else
						brand_layout_values["airline_route_list"] = "<a href=\"/flight-schedule/#{url_escape(int_routes.first['dep_city_name'])}-#{url_escape(int_routes.first['arr_city_name'])}-flights.html\">  #{int_routes.first['dep_city_name_ar']} #{to} #{int_routes.first['arr_city_name_ar']}  </a>"
					end
					brand_layout_values["occasional_flights"] = nil
				else
					if @language == "en"
						brand_layout_values["airline_route_list"] = (int_routes.collect{|r| "<a href=\"/flight-schedule/#{url_escape(r['dep_city_name'])}-#{url_escape(r['arr_city_name'])}-flights.html\">  #{r['dep_city_name']} #{to} #{r['arr_city_name']} </a>"}.compact.join(", "))
						brand_layout_values["occasional_flights"] = (int_occasional_routes.collect{|r| "#{r['dep_city_name']} #{to}  #{r['arr_city_name']}"}.compact.to_sentence) rescue []
					else
						brand_layout_values["airline_route_list"] = (int_routes.collect{|r| "<a href=\"/#{@language}/flight-schedule/#{url_escape(r['dep_city_name'])}-#{url_escape(r['arr_city_name'])}-flights.html\">  #{r['dep_ciry_name_ar']} #{to}  #{r['arr_city_name_ar']}  </a>"}.compact.to_sentence(:last_word_connector => ' و '))
						brand_layout_values["occasional_flights"] = (int_occasional_routes.collect{|r| "#{r['dep_city_name_ar']} #{to} #{r['arr_city_name_ar']}"}.compact.to_sentence(:last_word_connector => ' و ')) rescue []
					end
				end
			end
			return brand_layout_values
		end

		def airline_route_schedule_values(airline_route_schedules)
			model_name = "#{@country_code.titleize}AirlineRouteSchedule".constantize
			
			route_with_price = []
			min_pr = min_price_new_changes(@dep_city_code,@arr_city_code,@carrier_code,@country_code)
			min_price = min_pr[:airline_min_price][@carrier_code].to_i rescue 0
			max_price = min_pr[:airline_max_price][@carrier_code].to_i rescue 0
			airline_route_schedules.each do |route|
				route_json = eval(route.to_json)
				route_json[:cc_min_price] = min_price
				route_json[:cc_route_max_price] = max_price
				route_with_price << route_json
			end
			# routes = route_with_price.sort_by{|k| k[:days_of_operation].length}.reverse
			return route_with_price
		end

		def airline_top_header_routes
			header_routes = { "dom_dom" => [],
				"dom_int" => [],
				"int_int" => []}
				model_name = "#{@country_code.titleize}FlightScheduleCollective".constantize
				dom_routes = model_name.where("dep_city_code!=? and arr_city_code != ? and carrier_code = ? and dep_country_code=? and arr_country_code=?",@dep_city_code,@arr_city_code,@carrier_code,@country_code,@country_code).limit(10)
				dom_int_routes = model_name.where("dep_city_code!=? and arr_city_code != ? and carrier_code = ? and ((dep_country_code!=? and arr_country_code=?)OR(dep_country_code=? and arr_country_code!=?))",@dep_city_code,@arr_city_code,@carrier_code,@country_code,@country_code,@country_code,@country_code).limit(10)
				int_routes = model_name.where("dep_city_code!=? and arr_city_code != ? and carrier_code = ? and (dep_country_code!=? and arr_country_code!=?)",@dep_city_code,@arr_city_code,@carrier_code,@country_code,@country_code).limit(10)
				dom_routes.each do |r|
					dep_city = CityName.find_by(city_code: r.dep_city_code)
					arr_city = CityName.find_by(city_code: r.arr_city_code)
					if dep_city.present? && arr_city.present?
						header_routes["dom_dom"] << {
							"dep_city_name" => dep_city.city_name_en ,
							"arr_city_name" => arr_city.city_name_en ,
							"dep_city_name_ar" => dep_city.city_name_ar ,
							"arr_city_name_ar" => arr_city.city_name_ar ,
							"carrier_code" => @carrier_code,
							"carrier_name" => @carrier_name
						}
					end
				end
				dom_int_routes.each do |r|
					dep_city = CityName.find_by(city_code: r.dep_city_code)
					arr_city = CityName.find_by(city_code: r.arr_city_code)
					if dep_city.present? && arr_city.present?
						header_routes["dom_int"] << {
							"dep_city_name" => dep_city.city_name_en ,
							"arr_city_name" => arr_city.city_name_en ,
							"dep_city_name_ar" => dep_city.city_name_ar ,
							"arr_city_name_ar" => arr_city.city_name_ar ,
							"carrier_code" => @carrier_code,
							"carrier_name" => @carrier_name
						}
					end
				end
				int_routes.each do |r|
					dep_city = CityName.find_by(city_code: r.dep_city_code)
					arr_city = CityName.find_by(city_code: r.arr_city_code)
					if dep_city.present? && arr_city.present?
						header_routes["int_int"] << {
							"dep_city_name" => dep_city.city_name_en ,
							"arr_city_name" => arr_city.city_name_en ,
							"dep_city_name_ar" => dep_city.city_name_ar ,
							"arr_city_name_ar" => arr_city.city_name_ar ,
							"carrier_code" => @carrier_code,
							"carrier_name" => @carrier_name
						}
					end
				end
				if header_routes['dom_int'].count == 0 || header_routes['dom_int'].nil?
					header_routes['dom_int'] = header_routes['int_int']
				elsif header_routes['dom_int'].count > 0
					header_routes['dom_int'] = header_routes['dom_int'] + header_routes['int_int']
				end
				return header_routes
			end
			def top_dom_int_airports
				airports = {"dom_airports" => [],
					"int_airports" => []
				}
				dom_airport_records = Airport.where("country_code='#{@country_code}' and  airport_routes_count is not NULL").order('airport_routes_count desc').limit(5)
				int_airport_records = Airport.where("country_code!='#{@country_code}' and airport_routes_count is not NULL").order('airport_routes_count desc').limit(5)
				if  dom_airport_records.present?
					dom_airport_records.each do |airport|

						airports["dom_airports"] << {
							"airport_name" => airport.airport_name ,
							"airport_code" => airport.airport_code ,
							"airport_name_ar" => airport.airport_name_ar ,
							"city_name" => airport.city_name ,
							"city_code" => airport.city_code
						}
					end
				end
				if int_airport_records.present?
					int_airport_records.each do |airport|
						airports["int_airports"] << {
							"airport_name" => airport.airport_name ,
							"airport_name_ar" => airport.airport_name_ar ,
							"airport_code" => airport.airport_code ,
							"city_name" => airport.city_name  ,
							"city_code" => airport.city_code
						}
					end
				end
				return airports
			end
			def fetch_arabic_content
				contents = {}
				model_name = "#{@country_code.titleize}AirlineContent".constantize
				airline = model_name.find_by(carrier_code: @carrier_code)
				overview_content_en = airline.overview_content_en rescue ""
				meta_title_en = airline.meta_title_en rescue ""
				meta_description_en = airline.meta_description_en rescue ""
				overview_keywords_en = airline.overview_keywords_en rescue ""
				overview_keywords_ar = airline.overview_keywords_ar rescue ""
				overview_content_ar = airline.overview_content_ar rescue ""
				meta_title_ar = airline.meta_title_ar rescue ""
				meta_description_ar = airline.meta_description_ar rescue ""
				pnr_content_en = airline.pnr_content_en rescue ""
				cancellation_content_en = airline.cancellation_content_en rescue ""
				customer_support_content_en = airline.customer_support_content_en rescue ""
				web_checkin_content_en = airline.web_checkin_content_en rescue ""
				special_assistance_en = airline.special_assistance_en rescue ""
				travel_document_en = airline.travel_document_en rescue ""
				baggage_content_en = airline.baggage_content_en rescue ""
				baggage_content_ar = airline.baggage_content_ar rescue ""
				customer_support_content_ar=airline.customer_support_content_ar rescue ""
				cancellation_content_ar=airline.cancellation_content_ar rescue ""
				contents["overview_content_en"] = overview_content_en
				contents["meta_description_en"] = meta_description_en
				contents["meta_title_en"] = meta_title_en
				contents["overview_content_ar"] = overview_content_ar
				contents["meta_description_ar"] = meta_description_ar
				contents["meta_title_en_ar"] = meta_title_ar
				contents["overview_keywords_en"] = overview_keywords_en
				contents["overview_keywords_ar"] = overview_keywords_ar
				contents["pnr_content_en"]=pnr_content_en
				contents["travel_document_en"]=travel_document_en
				contents["special_assistance_en"]=special_assistance_en
				contents["web_checkin_content_en"]=web_checkin_content_en
				contents["customer_support_content_en"]=customer_support_content_en
				contents["cancellation_content_en"]=cancellation_content_en
				contents["baggage_content_en"]=baggage_content_en
				contents["baggage_content_ar"]=baggage_content_ar
				contents["customer_support_content_ar"]=customer_support_content_ar
				contents["cancellation_content_ar"]=cancellation_content_ar

 				unless !["IN","SA"].include?(@country_code)
					contents["review_content"] = File.read("#{Rails.root}/public/#{@country_code.downcase}/#{@language.downcase}/booking/#{@country_code.downcase}_airline_reviews/#{@carrier_code}.txt") rescue ""
					unless !(contents["review_content"].present? && contents["review_content"]!= "")
						contents["review_content_presence"] = true
					end
				end
				return contents
			end
		
			def check_airline_special_pages_existence
				special_pages = 	{}
				model_name = "#{@country_code.titleize}AirlineContent".constantize
				airline = model_name.find_by(carrier_code: @carrier_code)
				if @language == "ar" 
					special_pages["cancellation_content"] =  airline.cancellation_content_ar.present? ? true : false rescue false
					special_pages["travel_document_ar"] = airline.travel_document_ar.present? ? true : false rescue false
					special_pages["customer_support_content"] = airline.customer_support_content_ar.present? ? true : false rescue false
					special_pages["baggage_content"]  = airline.baggage_content_ar.present? ? true : false rescue false
					special_pages["special_assistance"] = airline.special_assistance_ar.present? ? true : false rescue false
				else
					special_pages["cancellation_content"] =  airline.cancellation_content_en.present? ? true : false rescue false
					special_pages["travel_document"] = airline.travel_document_en.present? ? true : false rescue false
					special_pages["customer_support_content"] = airline.customer_support_content_en.present? ? true : false rescue false
					special_pages["baggage_content"]  = airline.baggage_content_en.present? ? true : false rescue false
					special_pages["special_assistance"] = airline.special_assistance_en.present? ? true : false rescue false
				end
        return special_pages
			end
			def fetch_review_content
				contents = {"review_content" => "",
							"review_content_presence" => false}
				model_name = "#{@country_code.titleize}AirlineContent".constantize

				airline = model_name.find_by(carrier_code: @carrier_code)
				
 				overview_content_en = airline.overview_content_en rescue ""
				meta_title_en = airline.meta_title_en rescue ""
				meta_description_en = airline.meta_description_en rescue ""
				overview_keywords_en = airline.overview_keywords_en rescue ""
				overview_keywords_ar = airline.overview_keywords_ar rescue ""
				overview_content_ar = airline.overview_content_ar rescue ""
				meta_title_ar = airline.meta_title_ar rescue ""
				meta_description_ar = airline.meta_description_ar rescue ""
				pnr_content_en = airline.pnr_content_en rescue ""
				cancellation_content_en = airline.cancellation_content_en rescue ""
				customer_support_content_en = airline.customer_support_content_en rescue ""
				web_checkin_content_en = airline.web_checkin_content_en rescue ""
				special_assistance_en = airline.special_assistance_en rescue ""
				travel_document_en = airline.travel_document_en rescue ""
				baggage_content_en = airline.baggage_content_en rescue ""
				baggage_content_ar = airline.baggage_content_ar rescue ""
				customer_support_content_ar=airline.customer_support_content_ar rescue ""
				cancellation_content_ar=airline.cancellation_content_ar rescue ""
				contents["overview_content_en"] = overview_content_en
				contents["meta_description_en"] = meta_description_en
				contents["meta_title_en"] = meta_title_en
				contents["overview_content_ar"] = overview_content_ar
				contents["meta_description_ar"] = meta_description_ar
				contents["meta_title_en_ar"] = meta_title_ar
				contents["overview_keywords_en"] = overview_keywords_en
				contents["overview_keywords_ar"] = overview_keywords_ar
				contents["pnr_content_en"]=pnr_content_en
				contents["travel_document_en"]=travel_document_en
				contents["special_assistance_en"]=special_assistance_en
				contents["web_checkin_content_en"]=web_checkin_content_en
				contents["customer_support_content_en"]=customer_support_content_en
				contents["cancellation_content_en"]=cancellation_content_en
				contents["baggage_content_en"]=baggage_content_en
				contents["baggage_content_ar"]=baggage_content_ar
				contents["customer_support_content_ar"]=customer_support_content_ar
				contents["cancellation_content_ar"]=cancellation_content_ar
 				unless !["IN","SA","AE"].include?(@country_code)
					contents["review_content"] = File.read("#{Rails.root}/public/#{@country_code.downcase}/#{@language.downcase}/booking/#{@country_code.downcase}_airline_reviews/#{@carrier_code}.txt") rescue ""
					unless !(contents["review_content"].present? && contents["review_content"]!= "")
						contents["review_content_presence"] = true
					end
				end
				
				return contents
			end
			def fetch_cms_airline_route_content(min_price,page_type,page_subtype,top_sectors,host,airport_details)
				result  = {}
				dep_city_name = @dep_city_name 
				arr_city_name = @arr_city_name 

				carrier_name = @carrier_name.gsub(/\sairlines$/i,"").gsub(/\sair$/i,"") rescue @carrier_name
				carrier_name = carrier_name.gsub(/\sairlines\s$/i,"").gsub(/\sair$/i,"") rescue @carrier_name
				section =  @section.include?("dom") ? "dom" : "int"
				page_subtype = page_subtype.include?('pnr') ? "pnr" : page_subtype
				page_subtype = page_subtype.include?('web_checkin') ? "web-checkin" : page_subtype
			  model_name = check_model_type(page_type,page_subtype)
				unique_record = model_name.where(source: @dep_city_name,destination: @arr_city_name,language: @language,domain: @country_code, airline_name: @carrier_name,is_approved: true).first rescue nil
				common_record = CMS::Common.where(language: @language,domain: @country_code,page_type: page_type,page_subtype: page_subtype,section:section,is_approved: true).last
					
				if @language == "ar"
					airline_name = @carrier_name_ar rescue ""
					carrier_name = @carrier_name_ar rescue ""
					dep_city_name = @dep_city_name_ar rescue ""
					arr_city_name = @arr_city_name_ar rescue ""
				else
					airline_name = 	carrier_name rescue ""
					carrier_name = 	carrier_name rescue ""
					dep_city_name = @dep_city_name rescue ""
					arr_city_name = @arr_city_name rescue ""
				end	

					if page_subtype == "routes"
						unique_record
						unique_title = unique_record.title rescue ""
						unique_description = unique_record.description rescue ""
						unique_keywords = unique_record.keyword rescue ""
						unique_content = unique_record.content rescue ""
						unique_h1_title = unique_record.h1_title rescue ""
						unique_content = unique_record.content rescue ""
						unique_faq = unique_record.faq_object rescue []
						place_holder_list    = common_record.title.scan(/\{(.*?)\}/) rescue []
						if place_holder_list.flatten.include?("least_rate") 
							least_price =  min_price > 0 ? min_price : 0
							title = least_price > 0 ? common_record.title%{dep_city_name:dep_city_name,arr_city_name:arr_city_name,least_rate:least_price,airline_name:carrier_name,carrier_name: carrier_name} : ""
						end
						common_title = title.present? ? title : "" rescue ""
						common_description = common_record.description%{dep_city_name:dep_city_name,arr_city_name:arr_city_name,airline_name:carrier_name} rescue ""
						common_keywords = common_record.keyword%{dep_city_name:dep_city_name,arr_city_name:arr_city_name,airline_name:carrier_name} rescue ""
						common_h1_title = common_record.heading.html_safe%{dep_city_name:dep_city_name,arr_city_name:arr_city_name,airline_name:carrier_name,carrier_name:carrier_name} rescue ""
						common_content = ""
						common_faq = common_record.faq_object rescue []
						if airport_details[:airline_route_schedules].present?
						 	airline_route_schedules = airport_details[:airline_route_schedules]
							min_rate = airline_route_schedules.first[:cc_route_min_price] rescue nil
							max_rate = airline_route_schedules.first[:cc_route_max_price] rescue nil
							total_flights = airline_route_schedules.count
							first_flight_dep = airline_route_schedules.first[:dep_time] rescue nil
							first_flight_dep_time = Time.strptime(first_flight_dep,"%H:%M").to_time.strftime("%I:%M %p")
							dep_first_flight_no = airline_route_schedules.first[:flight_no]
							dep_last_flight_no = airline_route_schedules.last[:flight_no]
							last_flight_dep = airline_route_schedules.last[:dep_time]
							last_flight_dep_time = Time.strptime(last_flight_dep,"%H:%M").to_time.strftime("%I:%M %p")
							time_of_flying = airline_route_schedules.first[:duration].include?(":") ?  airline_route_schedules.first[:duration].to_time.strftime("%Hh %Mm") : Time.at(airline_route_schedules.first[:duration].to_i*60).utc.strftime("%Hh %Mm") rescue 
							dep_airport_code = airport_details[:dep_airport_code] rescue nil
							arr_airport_code = airport_details[:arr_airport_code] rescue nil
							if @language == "en"
								dep_airport_name = airport_details[:dep_airport_name] rescue nil
								arr_airport_name = airport_details[:arr_airport_name] rescue nil
							else
								dep_airport_name = airport_details[:dep_airport_name_ar] rescue nil
								arr_airport_name = airport_details[:arr_airport_name_ar] rescue nil
							end	
							if total_flights.present? && first_flight_dep_time.present? && last_flight_dep_time.present? && airport_details[:dep_airport_code].present? && airport_details[:arr_airport_code].present? && dep_airport_name.present? && arr_airport_name.present? && dep_city_name.present? && arr_city_name.present? 
								common_content = common_record.content%{dep_city_name:dep_city_name, arr_city_name:arr_city_name,airline_name: carrier_name, carrier_name:carrier_name, dep_airport_name:dep_airport_name, dep_airport_code: dep_airport_code, arr_airport_name:arr_airport_name, arr_airport_code:arr_airport_code, first_flight_dep_time:first_flight_dep_time, last_flight_dep_time:last_flight_dep_time,dep_first_flight_no: dep_first_flight_no,dep_last_flight_no: dep_last_flight_no,time_of_flying: time_of_flying , total_flights:total_flights, min_rate:"#{currency_code(@country_code)}.#{min_rate}", max_rate:"#{currency_code(@country_code)}.#{max_rate}"} rescue ""
							end
						end
					end
					result["title"] = (unique_title.present? && unique_title!="") ? unique_title : common_title rescue ""
					result["description"] = (unique_description.present? && unique_description!="") ? unique_description : common_description rescue ""
					result["keywords"] = (unique_keywords.present? && unique_keywords!="") ? unique_keywords : common_keywords rescue ""
					result["content"] = (unique_content.present? && unique_content!="") ? unique_content : common_content rescue ""
					result["h1_title"] = (unique_h1_title.present? && unique_h1_title!="" ) ? unique_h1_title : common_h1_title rescue ""
					result["faq"] = unique_faq.present? ? unique_faq : common_faq rescue []
					result["content"] = result["content"].gsub("<p data-f-id=\"pbf\" style=\"text-align: center; font-size: 14px; margin-top: 30px; opacity: 0.65; font-family: sans-serif;\">Powered by <a href=\"https://www.froala.com/wysiwyg-editor?pb=1\" title=\"Froala Editor\">Froala Editor</a></p>","") rescue nil
				return result
			end


		def fetch_cms_airline_content(min_price,page_type,page_subtype,top_sectors,host,airport_details)
				result  = {}
				dep_city_name = @dep_city_name 
				arr_city_name = @arr_city_name 
				carrier_name = @carrier_name.gsub(/\sairlines$/i,"").gsub(/\sair$/i,"") rescue @carrier_name
				carrier_name = carrier_name.gsub(/\sairlines\s$/i,"").gsub(/\sair$/i,"") rescue @carrier_name
				#carrier_name = @carrier_name.include?("airlines") || @carrier_name.include?("Airlines") ? @carrier_name.gsub(/airlines/i,'') : @carrier_name
				section =  @section.include?("dom") ? "dom" : "int"
				page_subtype = page_subtype.include?('pnr') ? "pnr" : page_subtype
				page_subtype = page_subtype.include?('web_checkin') ? "web-checkin" : page_subtype
			  	model_name = check_model_type(page_type,page_subtype)
				unique_record = model_name.where(language: @language,domain: @country_code, airline_name: @carrier_name,is_approved: true,page_subtype: page_subtype).first rescue nil
				common_record = CMS::Common.where(language: @language,domain: @country_code,page_type: page_type,page_subtype: page_subtype,section:section,is_approved: true).last rescue nil
				unique_title = unique_record.title rescue ""
				unique_description = unique_record.description rescue ""
				unique_keywords = unique_record.keyword rescue ""
				unique_h1_title = unique_record.heading rescue ""
				unique_content = unique_record.content rescue ""
				unique_reviews = unique_record.reviews_object.first rescue ""
				unique_faq = unique_record.faq_object rescue ""
				common_content = ""
				common_reviews = []
				common_faq = []
				if @language == "ar"
					airline_name = @carrier_name_ar
					carrier_name = @carrier_name_ar
				else
					airline_name = carrier_name
					carrier_name = carrier_name
				end
				if page_subtype == "overview"
					common_title = common_record.title%{carrier_name:carrier_name,airline_name:carrier_name} rescue ""
					common_description = common_record.description%{carrier_name:carrier_name,airline_name:carrier_name} rescue ""
					common_keywords = common_record.keyword%{carrier_name:carrier_name,airline_name:carrier_name} rescue ""
					common_h1_title = common_record.heading%{carrier_name:carrier_name,airline_name:carrier_name} rescue ""
					if top_sectors["airline_route_list"].present? && top_sectors["occasional_flights"].present?
						common_content = common_record.content%{carrier_name: carrier_name,airline_name:carrier_name,airline_route_list:top_sectors["airline_route_list"],occasional_flights:top_sectors["occasional_flights"],host:host} rescue ""
					end
					common_reviews = common_record.reviews_object.first rescue []
				elsif page_subtype == "pnr" || page_subtype == "web-checkin"
					common_title = common_record.title%{carrier_name:carrier_name,airline_name:carrier_name} rescue ""
					common_description = common_record.description%{carrier_name:carrier_name,airline_name:carrier_name} rescue ""
					common_keywords = common_record.keyword%{carrier_name:carrier_name,airline_name:carrier_name} rescue ""
					common_h1_title = common_record.heading%{carrier_name:carrier_name,airline_name:carrier_name} rescue ""
					common_content = common_record.content%{carrier_name:carrier_name,airline_name:carrier_name} rescue ""
				
				else
					common_title = common_record.title rescue ""
					common_description = common_record.description rescue ""
					common_keywords = common_record.keyword rescue ""
					common_content = common_record.content rescue ""
					common_h1_title = common_record.heading%{country:booking_index_host_country_code(@country_code)} rescue ""
				end
			
				result["title"] = (unique_title.present? && unique_title!="") ? unique_title : common_title
				result["description"] = (unique_description.present? && unique_description!="") ? unique_description : common_description
				result["keywords"] = (unique_keywords.present? && unique_keywords!="") ? unique_keywords : common_keywords
				result["content"] = (unique_content.present? && unique_content!="") ? unique_content : common_content
				result["h1_title"] = (unique_h1_title.present? && unique_h1_title!="" ) ? unique_h1_title : common_h1_title
				result["reviews"] = (unique_reviews.present?) ? unique_reviews : common_reviews 
				result["faq"] = unique_faq.present? ? unique_faq : [] rescue []
				result["content"] = result["content"].gsub("<p data-f-id=\"pbf\" style=\"text-align: center; font-size: 14px; margin-top: 30px; opacity: 0.65; font-family: sans-serif;\">Powered by <a href=\"https://www.froala.com/wysiwyg-editor?pb=1\" title=\"Froala Editor\">Froala Editor</a></p>","") .gsub("<meta charset=\"utf-8\"><span style=\"color: rgb(68, 68, 68); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">","") rescue ""
				
				return result
			end

			def fetch_cms_booking_index_content(min_price,page_type,page_subtype,top_sectors,host,airport_details)
				result = {}
				section =  @section.include?("dom") ? "dom" : "int"
				page_subtype = page_subtype
				common_record = CMS::Common.where(language: @language,domain: @country_code,page_type: page_type,page_subtype: page_subtype,section:section,is_approved: true).last rescue nil
				common_title = common_record.title rescue ""
				common_description = common_record.description rescue ""
				common_keywords = common_record.keyword
				common_record = common_record.keyword rescue ""
				common_content = common_record.content rescue ""
				common_h1_title = common_record.heading%{country: @country } rescue ""
				result["title"] =  common_title
				result["description"] = common_description
				result["keywords"] =  common_keywords
				result["content"] =  common_content
				result["h1_title"] = common_h1_title
				result["content"] = result["content"].gsub("<p data-f-id=\"pbf\" style=\"text-align: center; font-size: 14px; margin-top: 30px; opacity: 0.65; font-family: sans-serif;\">Powered by <a href=\"https://www.froala.com/wysiwyg-editor?pb=1\" title=\"Froala Editor\">Froala Editor</a></p>","") .gsub("<meta charset=\"utf-8\"><span style=\"color: rgb(68, 68, 68); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">","") rescue ""
				return result

			end
		
			def check_model_type(page_type,page_subtype)
				if page_type == "flight-booking"
					case page_subtype
					when "overview"
						model_name = "CMS::UniqueFbOverview".constantize
					when "routes"
						model_name = "CMS::UniqueFbRoute".constantize
					when "pnr" ,"web-checkin"
						model_name = "CMS::UniqueFbPnrWeb".constantize
					end
				elsif page_type == "flight-schedule"
					case page_subtype
					when "routes"
						model_name = "CMS::UniqueFsRoute".constantize
					when "from"
						model_name = "CMS::UniqueFsFrom".constantize
					when "to"
						model_name = "CMS::UniqueFsTo".constantize
					end
				elsif page_type == "flight-tickets"
					if page_subtype == "routes"
						model_name = "CMS::UniqueFtRoute".constantize
					end
				end
				return model_name
			end
			def rhs_top_airlines
				dom_airlines = AirlineBrand.where(country_code: @country_code).order(brand_routes_count:  :desc).limit(8).pluck(:carrier_code)
				dom_airlines = dom_airlines.delete_if{|c| c == "9W"}
				int_airlines = INTERNATIONAL_AIRLINES[@country_code].take(8)
				return {dom_airlines: dom_airlines,int_airlines: int_airlines}
			end

			def overview_top_schedule_routes_sa
			  top_routes = []
			  routes = ["riyadh to jeddah flights","jeddah to riyadh flights","dammam to jeddah flights","riyadh to dubai flights","riyadh to hyderabad flights","riyadh to manila flights","jeddah to dammam flights","jeddah to dubai flights","dammam to dubai flights","riyadh to lucknow flights","dammam to hyderabad flights","riyadh to madinah flights","riyadh to dammam flights","dammam to riyadh flights","riyadh to lahore flights","riyadh to mumbai flights","jeddah to manila flights","dammam to mumbai flights","dammam to madinah flights","jeddah to mumbai flights","riyadh to islamabad flights","jeddah to madinah flights","jeddah to hyderabad flights","dammam to manila flights","dubai to riyadh flights","jeddah to cairo flights","jeddah to islamabad flights","riyadh to istanbul flights","dammam to trivandrum flights","jeddah to istanbul flights","dammam to islamabad flights","dammam to kochi flights","riyadh to cairo flights","jeddah to lahore flights","dammam to lahore flights","riyadh to beirut flights","mumbai to riyadh flights","madinah to jeddah flights","riyadh to bangalore flights","dammam to karachi flights","dammam to bangalore flights","dammam to lucknow flights","riyadh to trivandrum flights","riyadh to amman flights","riyadh to kochi flights","abha to jeddah flights","jeddah to abha flights","riyadh to abha flights","jeddah to beirut flights","abha to riyadh flights","riyadh to karachi flights","dammam to kolkata flights","jeddah to karachi flights","riyadh to tabuk flights","dammam to cairo flights","dammam to mangalore flights","mumbai to dammam flights","tabuk to riyadh flights","hail to riyadh flights","hyderabad to riyadh flights","madinah to dammam flights","yanbu to jeddah flights","jeddah to amman flights","riyadh to taif flights","tabuk to jeddah flights","madinah to riyadh flights","jeddah to tabuk flights","dammam to abha flights","jeddah to kochi flights","taif to riyadh flights","jeddah to yanbu flights","dammam to sialkot flights","riyadh to muscat flights","dammam to patna flights","jeddah to kozhikode flights","jeddah to dhaka flights","abha to dammam flights","hyderabad to dammam flights","lahore to riyadh flights","cairo to riyadh flights","riyadh to kozhikode flights","jeddah to multan flights","riyadh to hail flights","cairo to jeddah flights","dammam to kathmandu flights","riyadh to kuala lumpur flights","dammam to dhaka flights","jeddah to peshawar flights","riyadh to dhaka flights","riyadh to colombo flights","dammam to kozhikode flights","riyadh to sharjah flights","istanbul to jeddah flights","lahore to dammam flights","lahore to jeddah flights","riyadh to khartoum flights","jazan to dammam flights","manila to cotabato flights","kochi to riyadh flights","kochi to dammam flights","jazan to jeddah flights","dammam to sharjah flights","riyadh to new delhi flights","yanbu to cairo flights","riyadh to kathmandu flights","madinah to lahore flights","karachi to dammam flights","jeddah to alexandria flights","karachi to jeddah flights","mangalore to dammam flights","kozhikode to dammam flights","kozhikode to riyadh flights","trivandrum to riyadh flights","islamabad to dammam flights","jeddah to new delhi flights","islamabad to jeddah flights","jeddah to buraidah flights","new delhi to patna flights","jeddah to sharjah flights","dammam to new delhi flights","madinah to cairo flights","riyadh to alexandria flights","alexandria to jeddah flights","new delhi to srinagar flights","riyadh to jakarta flights","new delhi to riyadh flights"]
			  top_routes = routes.shuffle.take(20)
			  top_routes = top_routes.map{|r| r.gsub(" to ","-").gsub(" flights", "")}
			  return top_routes
			end

			def rhs_top_schedule_routes
				header_routes = []
				sa_top_airlines = ["SV","XY","F3","GF","FZ","G9","9W","WY","EY","MS","AI","TK","EK","UL","KU","NE","LH","RJ","NP","SM","8Q"]
				if sa_top_airlines.include?(@carrier_code)
					sa_header_routes = overview_top_schedule_routes_sa
					sa_header_routes.each do |r|
						route = 	UniqueRoute.find_by(schedule_route_url: r)
						routes = {}
						routes["dep_city_name_en"] = route.dep_city_name  rescue ""
						routes["arr_city_name_en"] = route.arr_city_name rescue ""
						routes["url"] = route.schedule_route_url  rescue ""
						header_routes << routes
					end
				end
				dom_routes = AirlineUniqueRoute.where("carrier_code = ? and dep_country_code = ? and arr_country_code = ?",@carrier_code,@country_code,@country_code).order(flight_count: :desc).limit(10)
				int_routes = AirlineUniqueRoute.where("carrier_code = ? and ((dep_country_code = ? and arr_country_code != ?) || (dep_country_code != ? and arr_country_code = ?) || (dep_country_code != ? and arr_country_code != ?))",@carrier_code,@country_code,@country_code,@country_code,@country_code,@country_code,@country_code).order(flight_count: :desc).limit(10)
				# dom_routes = UniqueRoute.where(dep_country_code: @country_code,arr_country_code: @country_code).order(weekly_flights_count:  :desc).limit(15)
				# int_routes = UniqueRoute.where("(dep_country_code= ? and arr_country_code!=?)OR(dep_country_code!= ? and arr_country_code=?) ",@country_code,@country_code,@country_code,@country_code).order(weekly_flights_count:  :desc).limit(15)
				# if int_routes.nil? || !int_routes.present?
				# 	int_routes = UniqueRoute.where("(dep_country_code!= ? and arr_country_code!=?",@country_code,@country_code).order(weekly_flights_count:  :desc).limit(15)
				# end
				return {dom_routes: dom_routes,int_routes: int_routes,header_routes: header_routes}
			end

			def rhs_top_schedule_routes_ar
				header_routes = []
				sa_top_airlines = ["SV","XY","F3","GF","FZ","G9","9W","WY","EY","MS","AI","TK","EK","UL","KU","NE","LH","RJ","NP","SM","8Q"]
				if sa_top_airlines.include?(@carrier_code)
					sa_header_routes = overview_top_schedule_routes_sa
					sa_header_routes.each do |r|
						route = 	UniqueRoute.find_by(schedule_route_url: r)
						routes = {}
						routes["dep_city_name_ar"] = route.dep_city_name_ar  rescue ""
						routes["arr_city_name_ar"] = route.arr_city_name_ar rescue ""
						routes["url"] = route.schedule_route_url + "-flights.html" rescue ""
						header_routes << routes
					end
				end
				dom_routes = UniqueRoute.where(dep_country_code: @country_code,arr_country_code: @country_code).order(weekly_flights_count:  :desc).limit(15)
				int_routes = UniqueRoute.where("(dep_country_code= ? and arr_country_code!=?)OR(dep_country_code!= ? and arr_country_code=?) ",@country_code,@country_code,@country_code,@country_code).order(weekly_flights_count:  :desc).limit(15)
				if int_routes.nil? || !int_routes.present?
					int_routes = UniqueRoute.where("(dep_country_code!= ? and arr_country_code!=?",@country_code,@country_code).order(weekly_flights_count:  :desc).limit(15)
				end
				return {dom_routes: dom_routes,int_routes: int_routes,header_routes: header_routes}
			end


			def booking_footer
				model_name = "#{@country_code.titleize}Footer".constantize
				footer_links = model_name.where(city_code: @dep_city_code).first
				if footer_links.present?
					if @language == "en"
						if footer_links.volume_routes_en.present?
							footer_links_data =  eval(footer_links.volume_routes_en).compact.shuffle.sample(10)
							footer_links_data_arabic = []
						else
							footer_links_data = []
						end
					else
						if footer_links.volume_routes_ar.present?
							footer_links_data_arabic =  eval(footer_links.volume_routes_ar).compact.shuffle.sample(10)
							footer_links_data = []
						else
							footer_links_data_arabic = []
						end
					end
				end
				volume_route_model_name = "#{@country_code.titleize}VolumeRoute".constantize
				volume_routes = volume_route_model_name.where("url != ' ' and volume_count >= ?",1000).limit(10).order("RAND()")
				dom_airlines = AirlineBrand.where(country_code: @country_code,publish_status: 'active').limit(8).order("brand_routes_count desc").pluck(:carrier_code).uniq
				int_airlines = AirlineBrand.where.not(country_code: @country_code,publish_status: 'inactive').limit(8).order("RAND()").pluck(:carrier_code).uniq
				dom_airlines = dom_airlines.delete_if{|c| c == "9W" }
				int_airlines = int_airlines.delete_if{|c| c == "9W" }
		#Ending of footer randamization code
		footer_model_name = "#{@country_code.titleize}AirlineFooter".constantize
		@footer_data = footer_model_name.first
		total_footer_count =   eval(@footer_data.airline_footer_en).count
		if @footer_data.current_count == 0
			@footer_data_limit_10 =  eval(@footer_data.airline_footer_en).first(10)
			@footer_data.update(current_count:@footer_data.current_count+10)
		elsif @footer_data.current_count < total_footer_count
			@footer_data_limit_10 =  eval(@footer_data.airline_footer_en).drop(@footer_data.current_count).first(10)
			@footer_data.update(current_count: @footer_data.current_count+10)
		else
			@footer_data.update(current_count:0)
			@footer_data_limit_10 =  eval(@footer_data.airline_footer_en).first(10)
		end
		if @footer_data_limit_10.count < 10
			@footer_data_limit_10 =  eval(@footer_data.airline_footer_en).first(10)
			@footer_data.update(current_count:0)
		end
		@footer_data_limit_10 = @footer_data_limit_10.map{|a|  [url_escape(format_overview_link(a[:carrier_name_en]))+".html", a[:carrier_code]] if a[:carrier_code].present? && a[:carrier_name_en].present?}
		footer_airline_data = @footer_data_limit_10.present?  ? @footer_data_limit_10 : []
		return {footer_links_data: footer_links_data,footer_links_data_arabic: footer_links_data_arabic,dom_airlines: dom_airlines,int_airlines: int_airlines,footer_airline_data: footer_airline_data,volume_routes: volume_routes}
	end
	def min_price_new_changes(dep_city_code,arr_city_code,carrier_code='',country_code='')
    result={}
    date_res={}
    result1={}
    data_res_30={}
    min30={}
    max30={}
    min90={}
    max90={}
    max_rate= 0
    max_rate_90= 0
    max_rate_30= 0
    # today_date = Date.today
    # today = today_date.to_s.split('-').join('')
    # next_thirty_days = (today_date + 30).to_s.split('-').join('')
    # headers = {"user-agent" => "seo-codingmart"}
    # calendar_url = "https://www.cleartrip.com/flights/calendar/calendarstub.json?from=#{dep_city_code}&to=#{arr_city_code}&start_date=#{today}&end_date=#{next_thirty_days}"
    # calendar_url_response = HTTParty.get(calendar_url,:headers => headers)
    # calendar_data_30 = JSON.parse(calendar_url_response.body.gsub('\"','"')) if calendar_url_response.present? && calendar_url_response.code == 200   rescue ""
		if ["IN","AE","SA"].include?(@country_code)
			calendar_data_30 = Calendar.where({source_city_code: @dep_city_code, destination_city_code: @arr_city_code,:section=>@country_code}).first rescue {}
	    calendar_data_90 = FareCalendar.where({source_city_code: @dep_city_code, destination_city_code: @arr_city_code,:section=>@country_code}).first rescue {}

	    if calendar_data_90.present? && calendar_data_90.calendar_json.present? &&  calendar_data_30.present? && calendar_data_30.calendar_json.present? && !calendar_data_90.calendar_json.include?("<HTML><HEAD>") 
	      calendar_json_90 = JSON.parse(calendar_data_90.calendar_json)['calendar_json']
	      if !calendar_data_30.calendar_json.include?("<HTML><HEAD>")
          calendar_json_30 = JSON.parse(calendar_data_30.calendar_json)['calendar_json']  
        else
          calendar_json_30 = JSON.parse(calendar_data_90.calendar_json)['calendar_json'] 
        end
	      calendar_data_90 = calendar_json_90.values.flatten.group_by{|g| g["al"]}
	      calendar_data_30 = calendar_json_30.values.flatten.group_by{|g| g["al"]}
	      calendar_data_90.take(6).each do |al,rows|
	        early_morning=0
	        morning=0
	        noon=0
	        evening=0
	        night= 0
	        if rows.present?
	          rows.each do |val|
		          if val["dt"].present? 
		            time = val["dt"].to_time
		            if time.hour >= 0 && time.hour < 8
		              early_morning += 1
		            end
		            if time.hour >= 8 && time.hour < 12
		              morning += 1
		            end
		            if time.hour >= 12 && time.hour < 16
		              noon += 1
		            end
		            if time.hour >= 16 && time.hour < 20
		              evening += 1
		            end
		            if time.hour >= 20 && time.hour < 24
		              night += 1
		            end
		          end
	          end
	        end
	        result[al] = rows.min{ |a,b| (a["pr"].to_f)<=>(b["pr"].to_f) }["pr"]  if rows.present?
	        min90[al] = rows.min{ |a,b| (a["pr"].to_f)<=>(b["pr"].to_f) }  if rows.present?
	        min90[al]["emorn"] = early_morning
	        min90[al]["morn"] = morning
	        min90[al]["noon"] = noon
	        min90[al]["even"] = evening
	        min90[al]["night"] = night
	      end
	      calendar_data_90.each do |al,rows|
	        result1[al] = rows.max{ |a,b| (a["pr"].to_f)<=>(b["pr"].to_f) }["pr"]  if rows.present?
	        max90[al] = rows.max{ |a,b| (a["pr"].to_f)<=>(b["pr"].to_f) }  if rows.present?
	      end
	      calendar_json_90.each do |date,rows|
	        date_res[date] = rows.min{ |a,b| (a["pr"].to_f)<=>(b["pr"].to_f) }["pr"] if rows.present?
	      end

	      calendar_data_30.each do |al,rows|
	        min30[al] = rows.min{ |a,b| (a["pr"].to_f)<=>(b["pr"].to_f) }  if rows.present?
	      end
	      calendar_data_30.each do |al,rows|
	        max30[al] = rows.max{ |a,b| (a["pr"].to_f)<=>(b["pr"].to_f) }  if rows.present?
	      end
	      min_rate_90 = calendar_json_90.values.flatten.min{ |a,b| (a["pr"].to_f)<=>(b["pr"].to_f) }["pr"] rescue 0
	      max_rate_90 = calendar_json_90.values.flatten.max{ |a,b| (a["pr"].to_f)<=>(b["pr"].to_f) }["pr"] rescue 0
	      min_rate_30 = calendar_json_30.values.flatten.min{ |a,b| (a["pr"].to_f)<=>(b["pr"].to_f) }["pr"] rescue 0
	      max_rate_30 = calendar_json_30.values.flatten.max{ |a,b| (a["pr"].to_f)<=>(b["pr"].to_f) }["pr"] rescue 0
	      @no_price = true if (max_rate_90 == 0 && max_rate_30 == 0)
	    else
	      @no_price = true
	    end
		end
	    return {:airline_min_price=>result,:airline_max_price => result1,:cc=>result,:dt=>date_res,:min=>min_rate_90.to_i,:max=>max_rate_90.to_i,:cm=>result1,:cc1=>min30,:max1=>max_rate_30,:cm1=>max30,:cc2=>min90,:max2=>max_rate_30.to_i,:cm2=>max90,:min_price_30 => min_rate_30.to_i }
	end
	def min_price(dep_city_code,arr_city_code,carrier_code='')
			result = {}
			result1 = {}
			date_res = {}
			max_rate=0
			min_rate=0
			# calendar_data_json = Calendar.where({source_city_code: dep_city_code, destination_city_code: arr_city_code,:section=>@country_code}).first rescue {}
			today_date = Date.today
			today = today_date.to_s.split('-').join('')
			next_ninety_days = (today_date + 90).to_s.split('-').join('')
			# headers = {"user-agent" => "seo-codingmart"}
			# calendar_url = "https://www.cleartrip.com/flights/calendar/calendarstub.json?from=#{dep_city_code}&to=#{arr_city_code}&start_date=#{today}&end_date=#{next_ninety_days}"
			# calendar_url_response = HTTParty.get(calendar_url,:headers => headers)
			calendar_data_json = FareCalendar.where({source_city_code: @dep_city_code, destination_city_code: @arr_city_code,:section=>@country_code}).first rescue {}
			if calendar_data_json.present? && calendar_data_json.calendar_json.present? && !calendar_data_json.calendar_json.include?("<HTML><HEAD>")
			# if calendar_data_json.present? && calendar_data_json["calendar_json"].present?
				calendar_json = calendar_data_json.calendar_json

				calendar_data = calendar_json.values.flatten.group_by{|g| g["al"]}
				calendar_data.each do |al,rows|
					result[al] = rows.min{ |a,b| (a["pr"].to_f)<=>(b["pr"].to_f) }["pr"]  if rows.present?
				end
				calendar_data.each do |al,rows|
					result1[al] = rows.max{ |a,b| (a["pr"].to_f)<=>(b["pr"].to_f) }["pr"]  if rows.present?
				end
				calendar_json.each do |date,rows|
					date_res[date] = rows.min{ |a,b| (a["pr"].to_f)<=>(b["pr"].to_f) }["pr"] if rows.present?
				end
				max_rate = calendar_json.values.flatten.max{ |a,b| (a["pr"].to_f)<=>(b["pr"].to_f) }["pr"] rescue 0
				min_rate = calendar_json.values.flatten.min{ |a,b| (a["pr"].to_f)<=>(b["pr"].to_f) }["pr"] rescue 0
				@no_price = true if max_rate == 0
			else
				@no_price = true
			end

		return {:cc=>result,:dt=>date_res,:max=>max_rate.to_i,:min=>min_rate.to_i,:cm=>result1}
	end

  def get_price(dep_city_code,arr_city_code,carrier_code='',carrier_name='',country_code='')
    day_least_rate = {"pr"=>0}
    day_max_rate = {"pr"=>0}
		if ["IN","AE","SA"].include?(country_code)
	    calendar_data_json = FareCalendar.where({source_city_code: dep_city_code, destination_city_code: arr_city_code, section: @country_code}).first
	    if calendar_data_json.present? && calendar_data_json.calendar_json.present? && !calendar_data_json.calendar_json.include?("<HTML><HEAD>")
	      calendar_data = JSON.parse(calendar_data_json.calendar_json)['calendar_json'].values.flatten
	      if carrier_code.present?
	        cal_data =  calendar_data.group_by{|c| c["al"]}[carrier_code]
	        day_least_rate = cal_data.min{|a,b| (a["pr"].to_f)<=>(b["pr"].to_f) } ||  {"pr"=>0} rescue ""
	        day_max_rate = cal_data.max{|a,b| (a["pr"].to_f)<=>(b["pr"].to_f)} || {"pr"=>0} rescue ""
	      else
	        day_least_rate = calendar_data.min{|a,b| (a["pr"].to_f)<=>(b["pr"].to_f) } ||  {"pr"=>0}
	        day_max_rate = calendar_data.max{|a,b| (a["pr"].to_f)<=>(b["pr"].to_f)} || {"pr"=>0}
	      end
	    end
		end
    [day_least_rate["pr"].to_i,day_max_rate["pr"].to_i]
  end

  def h1_title_temp
  	return {"SV" => "الخطوط السعودية","XY" => "طيران ناس","MS" => "مصر للطيران","FZ" => "فلاي دبي","GF" => "طيران الخليج","NE" => "نسمة ايرلاينز","G9" => "العربية للطيران","TK" => "الخطوط الجوية التركية","EK" => "الخطوط الاماراتية","NP" => "طيران النيل","EY" => "الاتحاد للطيران","2Q" => "إير كايرو","PC" => "خطوط بيغاسوس الجوية","R5" => "الخطوط الاردنية","PR" => "الخطوط الجوية الفلبينية","AT" => "الخطوط الملكية المغربية","P4" => "السلام الجوي","ME" => "طيران الشرق الاوسط"}
  end
  def self.get_schedule_routes(airlines,lang,country_code)
    schedule_layout_values = {}
    airlines.each{|airline|
      schedule_layout_values["schedule_routes"] ||= []
      @carrier_name = airline.carrier_name
      @carrier_name_ar = airline.carrier_name_ar
      @carrier_code = airline.carrier_code
      @dep_city_code = airline.dep_city_code
      @arr_city_code = airline.arr_city_code
      @dep_city_name = airline.dep_city_name
      @arr_city_name = airline.arr_city_name
      @dep_country_code = airline.dep_country_code
      @arr_country_code = airline.arr_country_code
      @dep_city_name_ar = CityName.find_by(city_code: airline.dep_city_code).city_name_ar rescue ""
      @arr_city_name_ar = CityName.find_by(city_code: airline.arr_city_code).city_name_ar rescue ""
      @country_code = country_code
      @language = lang
      @section = ( @dep_country_code == @country_code && @arr_country_code ==  @country_code ) ? "#{@country_code}-dom" : "#{@country_code}-int"
      # airports = Hash[Airport.where(:city_code=>[@dep_city_code,@arr_city_code]).map{|c| [c.city_code,c]}]
      # @dep_airport_code = airports[@dep_city_code].airport_code rescue @dep_city_code
      # @arr_airport_code = airports[@arr_city_code].airport_code rescue @arr_city_code
      # @dep_airport_name = airports[@dep_city_code].airport_name rescue ""
      # @arr_airport_name = airports[@arr_city_code].airport_name rescue ""
      # @dep_airport_name_ar = airports[@dep_city_code].airport_name_ar rescue ""
      # @arr_airport_name_ar = airports[@arr_city_code].airport_name_ar rescue ""
      route_details = { carrier_name: @carrier_name,
                      carrier_code: @carrier_code,
                      dep_city_code: @dep_city_code,
                      arr_city_code: @arr_city_code,
                      dep_city_name: @dep_city_name,
                      arr_city_name: @arr_city_name,
                      dep_country_code: @dep_country_code,
                      arr_country_code: @arr_country_code,
                      country_code: @country_code,
                      section: @section,
                      language: @language,
                      dep_city_name_ar: @dep_city_name_ar,
                      arr_city_name_ar: @arr_city_name_ar,
                    carrier_name_ar: @carrier_name_ar}
      flight_booking_service = FlightBookingService.new route_details
      case @country_code
        when  "IN"
          @airline_route_schedules = airline.in_airline_route_schedules
        when  "AE"
          @airline_route_schedules = airline.ae_airline_route_schedules
        when  "SA"
          @airline_route_schedules = airline.sa_airline_route_schedules
        when  "BH"
          @airline_route_schedules = airline.bh_airline_route_schedules
        when  "QA"
          @airline_route_schedules = airline.qa_airline_route_schedules
        when  "KW"
          @airline_route_schedules = airline.kw_airline_route_schedules
        when  "OM"
          @airline_route_schedules = airline.om_airline_route_schedules
        else
          @airline_route_schedules = airline.om_airline_route_schedules
      end
      schedule_layout_values["schedule_routes"] += flight_booking_service.airline_route_schedule_values(@airline_route_schedules)
    }
    schedule_layout_values["schedule_routes"] = schedule_layout_values["schedule_routes"].sort_by { |k| k[:cc_min_price] }
    first_dep_airline = schedule_layout_values["schedule_routes"].sort_by { |k| k[:dep_time] }.first
    last_dep_airline = schedule_layout_values["schedule_routes"].sort_by { |k| k[:dep_time] }.last
    max_duration = schedule_layout_values["schedule_routes"].max{ |a,b| (a = a[:duration].include?(":")? Time.parse(a[:duration]).hour * 60 + Time.parse(a[:duration]).min : a[:duration].to_i)<=>(b = b[:duration].include?(":")? Time.parse(b[:duration]).hour * 60 + Time.parse(b[:duration]).min : b[:duration].to_i) }
    min_duration = schedule_layout_values["schedule_routes"].min{ |a,b| (a = a[:duration].include?(":")? Time.parse(a[:duration]).hour * 60 + Time.parse(a[:duration]).min : a[:duration].to_i)<=>(b = b[:duration].include?(":")? Time.parse(b[:duration]).hour * 60 + Time.parse(b[:duration]).min : b[:duration].to_i) }
    [schedule_layout_values["schedule_routes"],max_duration[:duration],first_dep_airline,last_dep_airline,min_duration[:duration]]
  end
  def self.get_cheap_fare_table_data(dep_city_code,arr_city_code,country_code)
    result={}
    min30={}
    min90={}
    cheap_fare_data = {}
    if ["IN","AE","SA"].include?(country_code)
      cheap_fare_data[:min_today] ||= {}
      cheap_fare_data[:min_15_with_dd] ||= {}
      cheap_fare_data[:min_30_with_dd] ||= {}
      cheap_fare_data[:min_90_with_dd] ||= {}
      calendar_data_30 = Calendar.where({source_city_code: dep_city_code, destination_city_code: arr_city_code,:section=>country_code}).first rescue {}
      calendar_data_90 = FareCalendar.where({source_city_code: dep_city_code, destination_city_code: arr_city_code,:section=>country_code}).first rescue {}
      if calendar_data_90.present? && calendar_data_90.calendar_json.present? &&  calendar_data_30.present? && calendar_data_30.calendar_json.present? && !calendar_data_90.calendar_json.include?("<HTML><HEAD>") 
        calendar_json_90 = JSON.parse(calendar_data_90.calendar_json)['calendar_json']
        if !calendar_data_30.calendar_json.include?("<HTML><HEAD>")
          calendar_json_30 = JSON.parse(calendar_data_30.calendar_json)['calendar_json']  
        else
          calendar_json_30 = JSON.parse(calendar_data_90.calendar_json)['calendar_json'] 
        end
        today_date = Date.today
        today = today_date.to_s.split('-').join('')
        min_today = calendar_json_90[today].sort_by { |k| k["pr"].to_i}.take(3)
        min_15 = calendar_json_90.select{|k,v| ((Date.today)..Date.today + 15).map{|d| d.to_s.gsub('-','')}.include?(k)}
        min_15_dd = min_15.each{|k,v|
          v.map{|rec| rec["dd"] = k}
        }
        min_15_with_dd = min_15_dd.values.flatten.sort_by { |k| k["pr"].to_i}.uniq!{|e| e["aln"]}.take(3) rescue {}
        min_30_dd = calendar_json_30.each{|k,v|
          v.map{|rec| rec["dd"] = k}
        }
        min_30_with_dd = min_30_dd.values.flatten.sort_by { |k| k["pr"].to_i}.uniq!{|e| e["aln"]}.take(3) rescue {}
        min_90_dd = calendar_json_90.each{|k,v|
          v.map{|rec| rec["dd"] = k}
        }
        min_price = min_90_dd.values.flatten.sort_by { |k| k["pr"].to_i}.first["pr"] rescue 0
        max_price = min_90_dd.values.flatten.sort_by { |k| k["pr"].to_i}.reverse.first["pr"] rescue 0
        min_90_with_dd = min_90_dd.values.flatten.sort_by { |k| k["pr"].to_i}.uniq!{|e| e["aln"]}.take(3) rescue {}
        cheap_fare_data[:min_today] = min_today
        cheap_fare_data[:min_15_with_dd] = min_15_with_dd
        cheap_fare_data[:min_30_with_dd] = min_30_with_dd
        cheap_fare_data[:min_90_with_dd] = min_90_with_dd
        calendar_data_90 = calendar_json_90.values.flatten.group_by{|g| g["al"]}
        calendar_data_30 = calendar_json_30.values.flatten.group_by{|g| g["al"]}
        calendar_data_90.take(6).each do |al,rows|
          early_morning=0
          morning=0
          noon=0
          evening=0
          night= 0
          if rows.present?
            rows.each do |val|
              if val["dt"].present? 
                time = val["dt"].to_time
                if time.hour >= 0 && time.hour < 8
                  early_morning += 1
                end
                if time.hour >= 8 && time.hour < 12
                  morning += 1
                end
                if time.hour >= 12 && time.hour < 16
                  noon += 1
                end
                if time.hour >= 16 && time.hour < 20
                  evening += 1
                end
                if time.hour >= 20 && time.hour < 24
                  night += 1
                end
              end
            end
          end
          min90[al] = rows.min{ |a,b| (a["pr"].to_f)<=>(b["pr"].to_f) }  if rows.present?
          min90[al]["emorn"] = early_morning
          min90[al]["morn"] = morning
          min90[al]["noon"] = noon
          min90[al]["even"] = evening
          min90[al]["night"] = night
        end
        calendar_data_30.each do |al,rows|
          min30[al] = rows.min{ |a,b| (a["pr"].to_f)<=>(b["pr"].to_f) }  if rows.present?
        end
      end
    end
    [cheap_fare_data,min_price,max_price,min30,min90]
  end
  def self.get_faqs_and_reviews_data(dep_city_name,arr_city_name,schedule_layout_values)
    faq_and_review_data = CMS::UniqueFsRoute.where(source: dep_city_name,destination: arr_city_name,is_approved: true).first
    faq_object = faq_and_review_data.faq_object.each{|faq| 
      faq[:question] = faq[:question]%{airline_name:schedule_layout_values["min90"]["aln"],dep_city_name:dep_city_name,arr_city_name:arr_city_name,currency_code:ApplicationProcessor.new.currency_name(@country_code),min_price:schedule_layout_values["min_price"],max_price: schedule_layout_values["max_price"],other_airlines: schedule_layout_values["operational_airlines"]}
      faq[:answer] = faq[:answer]%{airline_name:schedule_layout_values["min90"]["aln"],dep_city_name:dep_city_name,arr_city_name:arr_city_name,currency_code:ApplicationProcessor.new.currency_name(@country_code),min_price:schedule_layout_values["min_price"],max_price: schedule_layout_values["max_price"],other_airlines: schedule_layout_values["operational_airlines"]}
    } rescue []
    review_object = faq_and_review_data.reviews_object rescue {}
    [faq_object,review_object.first]
  end
  def self.get_more_flights_for_from_dep_city_and_to_arr_city(dep_city_code,arr_city_code)
    flights_for_from_dep_city = UniqueRoute.where(dep_city_code: dep_city_code,arr_country_code: @country_code).order(weekly_flights_count: :desc).first(30).map{|route| {"url"=>route.schedule_route_url+'-flights.html',"dep_city_name_en"=>route.dep_city_name,"arr_city_name_en"=>route.arr_city_name}}
    flights_for_to_arr_city = UniqueRoute.where(arr_city_code: arr_city_code,dep_country_code: @country_code).order(weekly_flights_count: :desc).first(30).map{|route| {"url"=>route.schedule_route_url+'-flights.html',"arr_city_name_en"=>route.arr_city_name,"dep_city_name_en"=>route.dep_city_name}}
    [flights_for_from_dep_city,flights_for_to_arr_city]
  end
  def self.get_arrival_and_departure_airport_details(dep_city_code,arr_city_code,airports)
    airport_details = {}
    airport_details["dep_airport_code"] = airports[dep_city_code].airport_code rescue dep_city_code
    airport_details["arr_airport_code"] = airports[arr_city_code].airport_code rescue arr_city_code
    airport_details["dep_airport_name"] = airports[dep_city_code].airport_name rescue ""
    airport_details["arr_airport_name"] = airports[arr_city_code].airport_name rescue ""
    airport_details["dep_airport_address"] = airports[dep_city_code].address rescue ""
    airport_details["arr_airport_address"] = airports[arr_city_code].address rescue ""
    airport_details["dep_airport_country"] = airports[dep_city_code].country_name rescue ""
    airport_details["arr_airport_country"] = airports[arr_city_code].country_name rescue ""
    airport_details["dep_airport_latitude"] = airports[dep_city_code].latitude rescue ""
    airport_details["arr_airport_latitude"] = airports[arr_city_code].latitude rescue ""
    airport_details["dep_airport_longitude"] = airports[dep_city_code].longitude rescue ""
    airport_details["arr_airport_longitude"] = airports[arr_city_code].longitude rescue ""
    airport_details
  end
end
