namespace :footer_table do
task store_footer_data: :environment do 
		section = ["IN-dom","IN-int"]
		airports =  Airport.all
		# FlightRoute.where("page_type='flight_schedule' and route_type = 'direct' and section IN (?)",section).pluck(:dep_city_code).uniq
		airports.each do |airport|
		count = 0 
			if airport.city_code.present? 
				count+=1
				routes  =  UniqueRoute.where("dep_city_code='#{airport.city_code}' and arr_city_code!='' ").order("flight_count desc")
				routes_data_json = []
				arr_city_code = routes.pluck(:arr_city_code).uniq
				arr_city_code.each do |arr|
					arr_name = UniqueRoute.where(arr_city_code: arr).pluck(:arr_city_name).uniq
					if arr_name.present?
						routes_data_json.push({ "dep_city_name": airport.city_name, "arr_city_name": arr_name.first})
					end
				end
				total_routes_count = routes_data_json.count
				 Footer.create(id: count,city_code: airport.city_code,city_name: airport.city_name,country_code: airport.country_code,country_name: airport.country_name,section: '',total_routes_count: total_routes_count,current_routes_count: 0,routes_data: routes_data_json.to_s)
         p "#{count}"

			end
		end
	end
end