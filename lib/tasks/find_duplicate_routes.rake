namespace :find do 
	task :duplicate_hop_routes => :environment do 
		direct_routes = UniqueRoute.all
		direct_routes.each do |direct_route|
			hop_routes = UniqueHopRoute.where(url: direct_route.schedule_route_url)
			hop_routes_count =  hop_routes.count
			if hop_routes_count > 1
				CSV.open("#{Rails.root}/duplicate_hop_routes.csv","w") do |csv|
					attributes = %w(dep_city_code arr_city_code dep_city_name arr_city_name url repeat_count)
					csv << attributes
					dep_city_code = hop_route.first.dep_city_code
					arr_city_code = hop_route.first.arr_city_code
					dep_city_name = hop_route.first.dep_city_name
					arr_city_name = hop_route.first.arr_city_name
					url = hop_route.first.url
					csv << [dep_city_code,arr_city_code,dep_city_name,arr_city_name,url,hop_routes_count]
        end
			end
		end
	end
	task :duplicate_routes => :environment do 
		hop_routes = UniqueHopRoute.all
		count = 0
		hop_routes.find_each do |hop_route|
			unique_route = UniqueRoute.find_by(schedule_route_url: hop_route.url)
			if unique_route.nil? 
				CSV.open("#{Rails.root}/duplicate_routes.csv","a+") do |csv|
					attributes = %w(dep_city_code arr_city_code dep_city_name arr_city_name schedule_url ticket_url)
					csv << attributes
					dep_city_code = hop_route.dep_city_code
					arr_city_code = hop_route.arr_city_code
					dep_city_name = hop_route.dep_city_name
					arr_city_name = hop_route.arr_city_name
					schedule_url = hop_route.url+"-flights.html"
					ticket_url = hop_route.url+"-cheap-airtickets.html"
					csv << [dep_city_code,arr_city_code,dep_city_name,arr_city_name,schedule_url,ticket_url]
        end
        puts "#{count += 1} #{hop_route.url}"
			end
		end
		puts "#{count} hop-routes found"
	end
end

# nohup bundle exec rake find:duplicate_routes QUEUE="*" --trace > rake.out 2>&1 &
	