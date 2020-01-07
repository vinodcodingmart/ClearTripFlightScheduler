namespace :update_from_to_content do 
	desc "create and update from and to content for India"
	task :uae => :environment do 
		count = 0
		["Ae","Sa"].each do |cc| 
			model_name = "#{cc}FromToContent".constantize

			CSV.foreach("#{Rails.root}/public/updated_city_list.csv",:headers=> true).each_with_index do |row,index|
				begin
					city_code = row[0]
					city_name_en = row[1]
					city = model_name.find_or_create_by(city_code: city_code,city_name: city_name_en)
					from_city_content_ar = File.open("#{Rails.root}/public/uae/from-to/ar/from_cities_ar/flights-from-#{city_name_en}.txt","r:bom|utf-8").read.force_encoding("UTF-8") rescue ''
					to_city_content_ar = File.open("#{Rails.root}/public/uae/from-to/ar/to_cities_ar/Flights-to-#{city_name_en}.txt","r:bom|utf-8").read.force_encoding("UTF-8") rescue ''
					city.en_from_content = "" 
					city.en_to_content = ""
					city.ar_from_content = from_city_content_ar
					city.ar_to_content = to_city_content_ar
					city.save
					puts "#{count+=1} inserted for city-#{city_name_en}"
				rescue StandardError => e
					e.message
					e.backtrace
				end
			end
		end
		# city.en_from_content = 
		# city_en_to_content = 
	end
end