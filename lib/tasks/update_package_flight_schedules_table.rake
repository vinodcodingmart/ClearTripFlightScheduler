# =========== run rake in background =============
#nohup bundle exec rake package_flight_schedules:update_city_name QUEUE="*" --trace > rake.out 2>&1 &

namespace :package_flight_schedules do
	desc "update dep and arr cities in package_flight_schedules"
	task update_city_name: :environment do
	 puts '--------Start adding Cities --------'
   csv_file = "#{Rails.root}/public/missing_city_names_arabic_english_found.csv"

   csv_text = File.read(csv_file)
   csv = CSV.parse(csv_text, headers: :first_row, col_sep: ",")
   count = 0
   csv.each do |row|
	    begin
	      city_code = row[0]
	      city_name_en = row[1]
	      dep_cities = PackageFlightSchedule.where(dep_city_code: city_code).update_all(dep_city_name: city_name_en,route_status: 'not_valid')
	      # dep_cities.each do |dep_city|
	      # 	dep_city.dep_city_name =  city_name_en
	      # 	dep_city.save
	      # end
	      arr_cities = PackageFlightSchedule.where(arr_city_code: city_code).update_all(arr_city_name: city_name_en,route_status: 'not_valid')
	      # arr_cities.each do |arr_city|
	      # 	arr_city.arr_city_name = city_name_en
	      # 	arr_city.save
	      # end
	    puts "updated - #{city_code} with dep_cities = #{dep_cities} and arr_cities = #{arr_cities}"
	    rescue StandardError => e
	    	
	    end
    end
	end
end
