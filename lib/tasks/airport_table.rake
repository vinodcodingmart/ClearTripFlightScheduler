namespace :airport_table do 

	task :get_extra_airports => :environment do 
		present_count = 0 
		absent_count = 0
		CSV.open("#{Rails.root}/existing_airports_checked_with_ct_team_list.csv","w") do |csv|
	        attributes = %w( airport_code airport_name country_code country_name status)
	        csv << attributes
	     count = 0

			CSV.foreach("public/airport_list_ct_team.csv", :headers=>true).each_with_index do |row,index| 
			# airport_table:get_extra_airports
			airport_code = row[0]
			airport_name = row[4]
			country_code = row[5]
			country_name = row[7]
			status = row[13]
			airport =	 Airport.find_by(airport_code: airport_code)
			if airport.present? && !airport.nil?
				csv << [airport_code,airport_name,country_code,country_name,status]
				absent_count +=1
			end
			# # else
				# CSV.open("#{Rails.root}/airports_without_names.csv","w") do |csv|
	   #      attributes = %w( airport_code airport_name country_code country_name status)
	   #      csv << attributes
				# 	csv << [airport_code,airport_name,country_code,country_name,status]
				# 	absent_count+=1 
				# end
			puts "#{count+=1}-searched airports"
			end
		end
		puts "total present count = #{present_count} && absent_count = #{absent_count}"
	end	
  
  desc "get null airport names"
  task :get_null_airports => :environment do 
    dep_airports = PackageFlightSchedule.all.pluck(:dep_airport_code).uniq
    arr_airports = PackageFlightSchedule.all.pluck(:arr_airport_code).uniq
    total_airports = (dep_airports + arr_airports).uniq
    count = 0
    CSV.open("#{Rails.root}/missing_airport_details.csv","w") do |csv|
      attributes = %w( airport_code city_code airport_name_en )
        csv << attributes
      total_airports.each do |airport_code|
        airport = Airport.find_by(airport_code: airport_code)
      	airport_name =  airport.airport_name rescue ""
        if  !airport_name.present?  
          city_code = airport.city_code rescue ""
          airport_name_en = airport.airport_name rescue ""
          # airport_name_ar = ''
          # airport_name_hi = ''
          # address = airport.address
          # phone = airport.phone
          # email = airport.email
          csv << [airport_code,city_code,airport_name_en]
        # else
        #   csv << [airport_code,'','','','','','','']
        #   CSV.open("#{Rails.root}/no_name_airports.csv","w") do |csv1|
        #     attributes = %w( airport_code city_code airport_name_en airport_name_ar airport_name_hi address phone email website)
        #     csv1 << attributes
        #     csv1 << [airport_code,'','','','','','','']
        #   end
        puts "#{count+=1} written for airport-#{airport_code}"
        end
      end
    end
    
  end
  task airports_wo_city_code_r_airport_name: :environment do 
  	all_airports = Airport.where("airport_name IS NULL OR city_code IS NULL")
    CSV.open("#{Rails.root}/airports_wo_city_code_r_airport_name.csv","w") do |csv|
    	attributes = %w( airport_code city_code airport_name_en )
	    all_airports.each do |airport|
	    	if !airport_name_en.present? || !city_code.present?
	    		airport_name_en = airport.airport_name rescue ""
	    	  city_code = airport.city_code rescue ""
	    		csv << [airport_code,city_code,airport_name_en]
	    	end
	    end
	  end
  end
end