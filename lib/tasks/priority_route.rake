namespace :popular do 
	task route: :environment do 
		popular_route = []
			CMS::UniqueFsRoute.where(domain:"IN").each_with_index do |uniq_route,index|
				begin
				data = UniqueRoute.find_by(dep_city_name: uniq_route.source,arr_city_name: uniq_route.destination)
				popular_route << {"dep_city_code": data.dep_city_code,"arr_city_code": data.arr_city_code,"url_format": data.schedule_route_url,"dep_city_name": data.dep_city_name,"arr_city_name": data.arr_city_name,"domain": uniq_route.domain}
				# PopularRoute.create(dep_city_code: data.dep_city_code,arr_city_code: data.arr_city_code,url_format: data.schedule_route_url,dep_city_name: data.dep_city_name,arr_city_name: data.arr_city_name,domain: uniq_route.domain)
				p [uniq_route.url,index]
				rescue => e
					p e
				end
			end
		
		end
end