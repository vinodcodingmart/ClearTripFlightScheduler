namespace :update do 
	desc "update airport_names"
	task airport_table: :environment do 
		CSV.foreach("#{Rails.root}/public/new_airport_details.csv", :headers=>true).each_with_index do |row,index| 
			begin
				airport_code  = row[0]
				city_code = row[1]
				address_en = row[3]
				website = row[4]
				phone = row[5]	
				airport = Airport.find_by(airport_code: airport_code,city_code: city_code)
				airport.address = address_en
				airport.website = website
				airport.phone = phone
				airport.save!
				puts "#{index+=1}  updated airport-#{airport_code}"
			rescue StandardError => e 
				e.message
				e.backtrace
			end
		end
	end
end