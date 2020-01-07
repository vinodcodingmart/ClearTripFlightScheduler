# require 'sidekiq'
# require 'sidekiq_status'
# require 'active_support'
# require 'action_controller'
# require "#{APP_ROOT}/lib/support/constants.rb"
# require "#{APP_ROOT}/config/environment"

class FlightsHeaderGeneratorWorker
	# include SidekiqStatus::Worker
	# include Utilities
	# sidekiq_options queue: "flight_schedule_generator_worker", backtrace: true

	def perform(args)
		country_code = ENV['COUNTRY']

		# file_paths = YAML.load(File.read('config/application.yml'))[Rails.env]
		begin

			@flight_route = UniqueRoute.find(args)
			section = (@flight_route.dep_country_code == country_code && @flight_route.arr_country_code == country_code) ? "#{country_code}-dom" : "#{country_code}-int"
			route_type = @flight_route.hop == 0 ? "direct" : "hop"
			if(@flight_route.present?)
				flight_processor_args = {
					'dep_city_code' => @flight_route.dep_city_code,
					'arr_city_code' => @flight_route.arr_city_code,
					'dep_country_code' => @flight_route.dep_country_code,
					'arr_country_code' => @flight_route.arr_country_code,
					'dep_city_name' => @flight_route.dep_city_name,
					'dep_city_name_translated' => @flight_route.dep_city_name,
					'arr_city_name' => @flight_route.arr_city_name,
					'arr_city_name_translated' => @flight_route.arr_city_name,
					'route_id' => @flight_route.id,
					'section' =>  section ,
					'page_type' => 'flight_schedule',
					'route_type' => route_type
				}


				hotel_details = {"hotel_list"=>[],
					"hotel_types" => []
				}
				if @flight_route.arr_city_code.present? && @flight_route.arr_country_code.present?
					airport_data = Airport.where(city_code: @flight_route.arr_city_code).first
					unless airport_data.present?
						airport_data = Airport.where(city_code: @flight_route.dep_city_code).first
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
						dep_city_hotels_trains_url = "http://54.169.90.61/hotels/api/#{url_escape(country_name)}/#{url_escape(@flight_route.dep_city_name)}.json"
						hotels_near_by_airport_response = HTTParty.get(hotels_near_by_airport_url) if lat.present? && long.present?
						parsing_near_by_hotels = JSON.parse(hotels_near_by_airport_response.body) if hotels_near_by_airport_response.present? && hotels_near_by_airport_response.code == 200

						arr_city_hotels_trians_response = HTTParty.get(arr_city_hotels_trains_url)

						parsing_arr_city_hotels_trains = JSON.parse(arr_city_hotels_trians_response.body) if  arr_city_hotels_trians_response.present? && arr_city_hotels_trians_response.code == 200

						dep_city_hotels_trians_response = HTTParty.get(dep_city_hotels_trains_url)
						parsing_dep_city_hotels_trains = JSON.parse(dep_city_hotels_trians_response.body) if dep_city_hotels_trians_response.present? && dep_city_hotels_trians_response.code == 200
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
				# flight = FlightsHeader.create(dep_city_code: @flight_route.dep_city_code,arr_city_code: @flight_route.arr_city_code,page_type: 'flight_schedule',section: @flight_route.section,dom_airlines: route_dom_airlines,int_airlines: route_int_airlines,airport_details: route_airports,hotel_details: hotel_details,train_details: train_details,status: "created")
				header = Header.create(route_type: route_type,dep_city_code: @flight_route.dep_city_code,arr_city_code: @flight_route.arr_city_code,dep_city_name: @flight_route.dep_city_name.titleize,arr_city_name: @flight_route.arr_city_name.titleize,hop: @flight_route.hop,page_type: 'flight_schedule',hotel_details: hotel_details,train_details: train_details,status: "created",language: 'en')
				# flights_header  = FlightsHeader.create(route_type: route_type,dep_city_code: @flight_route.dep_city_code,arr_city_code: @flight_route.arr_city_code,dep_city_name: @flight_route.dep_city_name.titleize,arr_city_name: @flight_route.arr_city_name.titleize,hop: @flight_route.hop,page_type: 'flight_schedule',hotel_details: hotel_details,train_details: train_details,status: "created",language: 'en')
			end
		rescue => e
			
			puts e.message
			puts e.backtrace.join("\n")
			not_generated_path = "#{APP_ROOT}/failed_files.txt"
			File.open(not_generated_path,"a+") do |f|
				f.write("ERROR in File #{@flight_route.dep_city_name}-#{@flight_route.arr_city_name}-flights.html\n")
				f.write(e.message)
				f.write(e.backtrace.join("\n"))
				f.write("\n==========================\n")
			end
		end
	end

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
end
