namespace :find do
	task :unique_routes => :environment do 
		CSV.open("#{Rails.root}/to_update_calendar_routes.csv","w") do |csv|
			attributes = %w(source_city_code destination_city_code)
			csv << attributes
			count = 0
			routes = UniqueRoute.where("dep_city_code!=arr_city_code and arr_city_code!='' and dep_airport_code!='' and arr_airport_code!='' and dep_country_code!='' and arr_country_code!=''").group(:dep_city_code,:arr_city_code,:dep_country_code,:arr_country_code,:dep_airport_code,:arr_airport_code)
			routes.find_each do |r|
				source_city_code = r.dep_city_code
				destination_city_code = r.arr_city_code
				csv << [source_city_code,destination_city_code]
				puts "#{count+=1} routes written"
			end
		end
	end
end