namespace :get do
	task :all_cities => :environment do
		dep_cities = PackageFlightSchedule.all.pluck(:dep_city_code).uniq
		arr_cities = PackageFlightSchedule.all.pluck(:arr_city_code).uniq
		all_cities = (dep_cities + arr_cities).uniq
		CSV.open("#{Rails.root}/all_cities.csv","w") do |csv|
      attributes = %w( city_code  city_name_en city_name_ar city_name_hi )
      csv << attributes
			all_cities.each do |city_code|
    		city = CityName.find_by(city_code: city_code)
    		city_name_en = city.city_name_en rescue ''
    		city_name_ar = city.city_name_ar rescue ''
    		city_name_hi = city.city_name_hi rescue ''
        csv << [city_code,city_name_en,city_name_ar,city_name_hi]
			end
		end
	end
end
