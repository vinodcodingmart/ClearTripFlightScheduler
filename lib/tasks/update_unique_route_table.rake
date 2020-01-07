require "csv"
# =========== run rake in background =============
# nohup bundle exec rake unique_routes_table:dep_and_arr_cities_name QUEUE="*" --trace > rake.out 2>&1 &

namespace :unique_routes_table do
	desc "update dep_city_names and arr_city_names in unique_routes table"
	task :dep_and_arr_cities_name => :environment do
		CSV.foreach("public/missing_city_names_arabic_english_found.csv", :headers=>true).each_with_index do |row,index|
  		begin
        city_code = row[0]
				city_name_en = row[1]
        city_name_ar = row[2]
        dep_cities = UniqueHopRoute.where(dep_city_code: row[0])
        dep_cities.each do |dep_city|
					dep_city.dep_city_name = city_name_en
        	dep_city.dep_city_name_ar = city_name_ar
        	dep_city.save!
        end
        arr_cities = UniqueHopRoute.where(arr_city_code: row[0])
        arr_cities.each do |arr_city|
					arr_city.arr_city_name = city_name_en
        	arr_city.arr_city_name_ar = city_name_ar
        	arr_city.save!
        end
        puts "#{index}-city_code=#{city_code} with dep_city_count=#{dep_cities.count} and arr_city_count=#{arr_cities.count}"
      rescue StandardError => e
        	
      end
		end
	end
  desc "update route url in unique routes table"
  task :update_schedule_url => :environment do
    # routes = UniqueRoute.all
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
		CSV.foreach("public/missing_city_names_arabic_english_found.csv", :headers=>true).each_with_index do |row,index|
			city_code = row[0]
    	routes = UniqueHopRoute.where("dep_city_code=? OR arr_city_code=?",city_code,city_code)
			begin
	      routes.each do |route|
	        route_url_format = url_escape("#{route.dep_city_name}-#{route.arr_city_name}")
	        route.schedule_route_url = route_url_format
	        route.save!
	      end
				puts "#{index+=1}-#{city_code} has been updated!"
	    rescue StandardError => e
	      
	    end
		end
  end

  task get_city_codes: :environment do
    CSV.open("#{Rails.root}/update_calendar_routes.csv","w") do |csv|
      attributes = %w( dep_city_code arr_city_code url)
          csv << attributes
      CSV.foreach("#{Rails.root}/public/to_update_calendar_routes.csv", :headers=>true).each_with_index do |row,index|
        begin
          url = row[0].split("/")[2].gsub("-flights.html",'')
          route = UniqueRoute.find_by(schedule_route_url: url)
          dep_city_code = route.dep_city_code
          arr_city_code = route.arr_city_code
          url = row[0]
          csv << [dep_city_code,arr_city_code,url]
        rescue
          
        end
      end
    end
  end
  task :compare_hop_routes => :environment do
    routes = UniqueHopRoute.all
    routes.each_with_index do |r,index|
      route=UniqueRoute.find_by(schedule_route_url: r.url)
      if route.nil? || !route.present?
        puts "#{index}-#{r.url},dep_city_code='#{r.dep_city_code}' and arr_city_code='#{r.arr_city_code}'"
      end
    end
  end

task :insert_routes => :environment do 
  count = 0
  sa_fcs = SaFlightScheduleCollective.where(carrier_code: 'NE')
  sa_fcs.each do |r|
    pfs_route = PackageFlightSchedule.find_by(carrier_code: 'NE',flight_no: r.flight_no,dep_city_code: r.dep_city_code,arr_city_code: r.arr_city_code)
    unless pfs_route.nil?
    unique_route = UniqueRoute.find_by(dep_city_code: r.dep_city_code,arr_city_code: r.arr_city_code)
    SaAirlineBrandCollective.create(carrier_code: 'NE',carrier_name: 'Nesma Airlines',flight_no: r.flight_no,dep_time: r.dep_time,arr_time: r.arr_time,duration: r.duration,days_of_operation: r.days_of_operation,dep_city_code: r.dep_city_code,arr_city_code: r.arr_city_code,dep_country_code: r.dep_country_code,arr_country_code: r.arr_country_code,unique_route_id: unique_route.id)
    puts "inserted"
    end
  end
  # pfs_routes = PackageFlightSchedule.where(carrier_code: 'NE',carrier_brand: 'Nesma Airlines').where("flight_no!= '' and dep_city_code!=arr_city_code and dep_country_code!='' and arr_country_code!=''").group(:carrier_code,:carrier_brand,:dep_city_code,:arr_city_code,:dep_country_code,:arr_country_code)
  # pfs_routes.each do |r|
  #   unique_route = UniqueRoute.find_by(dep_city_code: r.dep_city_code,arr_city_code: r.arr_city_code)
    # SaAirlineBrandCollective.create(carrier_code: 'NE',carrier_name: 'Nesma Airlines',flight_no: r.flight_no,dep_time: r.dep_time,arr_time: r.arr_time,duration: r.elapsed_journey_time,days_of_operation: r.day_of_operation,dep_city_code: r.dep_city_code,arr_city_code: r.arr_city_code,dep_country_code: r.dep_country_code,arr_country_code: r.arr_country_code,unique_route_id: unique_route.id)

  #   puts "#{count+=1} - inserted for #{r.dep_city_code} - #{r.arr_city_code}"
  # end
end

end
