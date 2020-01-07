require "csv"

namespace :city_name_table do
	desc "update city names with en,ar,hi"
	task :update_with_names  => :environment do
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
      begin
        city_code = row[0]
        city_name_en = row[1]
        city_name_ar = row[2]
        city = CityName.find_by(:city_code => city_code)
         city.city_name_en = city_name_en
         city.city_name_ar = city_name_ar
				 # format_city_name = url_escape(city_name_en) rescue ""
	       # from_url = "flights-from-" + format_city_name rescue ""
	       # to_url = "flights-to-" + format_city_name rescue ""
	       # city.from_url = from_url  rescue ""
	       # city.to_url = to_url rescue ""
         city.save
        puts "#{index} - update for City - #{city_code}"
      rescue StandardError => e
        
        puts "Exception Occured while adding city data " + e.message
      end
    end
	end

  desc "update city names with en,ar,hi"
  task :update_with_content => :environment do
    begin
      city_content = File.open("#{Rails.root}/public/flight_schedule_content/#{@flight_route.dep_city_name.titleize}-#{@flight_route.dep_city_code}.txt","r:bom|utf-8").read.force_encoding("UTF-8") rescue nil
      city = CityName.find_or_create_by(:city_code => city_code)
       city.city_name_en = city_name_en
       city.city_name_ar = city_name_ar
       city.city_name_hi = city_name_hi
       city.save
      puts "#{index} - Inserted for City - #{city_code}"
    rescue StandardError => e
      
      puts "Exception Occured while adding city data " + e.message
    end
  end

	desc "get null city names from package_flight_scheduels"
	task :get_null_cities => :environment do
		null_name_dep_cities = PackageFlightSchedule.where("dep_city_name IS NULL").pluck(:dep_city_code).uniq
		null_name_arr_cities = PackageFlightSchedule.where("arr_city_name IS NULL").pluck(:arr_city_code).uniq
		total_null_city_codes = (null_name_dep_cities + null_name_arr_cities).uniq
    dep_cities_with_names = PackageFlightSchedule.where("dep_city_name IS NOT NULL").pluck(:dep_city_code).uniq
    arr_cities_with_names = PackageFlightSchedule.where("arr_city_name IS NOT NULL").pluck(:arr_city_code).uniq
    total_cities_with_names = (dep_cities_with_names + arr_cities_with_names).uniq
	  resutlt = (total_null_city_codes + total_cities_with_names).uniq
    count = 0
    CSV.open("#{Rails.root}/no_name_cities.csv","w") do |csv|
      attributes = %w( city_code city_name_en city_name_hi city_name_ar)
        csv << attributes
      resutlt.each do |city_code|
        city = CityName.find_by(city_code: city_code)
        if city.present? && !city.nil?
          city_name_en = city.city_name_en
          city_name_ar = city.city_name_ar
          city_name_hi = city.city_name_hi
          csv << [city_code,city_name_en,city_name_hi,city_name_ar]
        else
          csv << [city_code,'','','']
          CSV.open("#{Rails.root}/no_name_cities.csv","w") do |csv1|
            attributes = %w( city_code city_name_en city_name_hi  city_name_ar)
            csv1 << attributes
            csv1 << [city_code,'','','']
          end
        end
        puts "#{count+=1} written for city-#{city_code}"
      end
    end
  end



  desc "create csv for no name cities"
  task :get_no_name_cities => :environment do
    dep_cities = UniqueRoute.where("dep_city_name IS NULL").pluck(:dep_city_code).uniq
    arr_cities = UniqueRoute.where("arr_city_name IS NULL").pluck(:arr_city_code).uniq
    total_cities = (dep_cities + arr_cities).uniq
    CSV.open("#{Rails.root}/missing_city_names_new.csv","w") do |csv|
      attributes = %w(city_code city_name_en city_name_ar city_name_hi)
      csv << attributes
      total_cities.each do |city_code|
        csv << [city_code,'','','']
      end
    end
  end

  desc "create csv for no name cities"
  task :update_urls => :environment do
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
    cities = CityName.all
    count = 0
    cities.each do |city|
      format_city_name = url_escape(city.city_name_en) rescue ""
      from_url = "flights-from-" + format_city_name rescue ""
      to_url = "flights-to-" + format_city_name rescue ""
      city.from_url = from_url  rescue ""
      city.to_url = to_url rescue ""
      city.save!
      puts "#{count+=1} updated for city-#{city.city_name_en}"
    end
  end

end
