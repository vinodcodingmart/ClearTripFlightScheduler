namespace :find do 
	task duplicate_airlines: :environment do 
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

	  def format_overview_link(carrier_name)
	    unless carrier_name.blank?
	      if(carrier_name.downcase.include?('airlines') || carrier_name.downcase.include?('airline')|| carrier_name.downcase.include?('air lines'))
	        result = carrier_name.downcase
	        result = result.gsub("airlines","")
	        result = result.gsub("airline","")
	        result = result.gsub("air lines","")
	        result = result.strip.downcase.gsub(" ", "-")
	        result = result+"-airlines"
	      else
	        result = carrier_name.downcase.gsub(" ","-")+ "-airlines"
	      end
	    end
	  end
		airlines = AirlineBrand.all
		CSV.open("#{Rails.root}/duplicate_airlines.csv","w") do |csv|
			attributes = %w(carrier_code publish_status table_airline_name table_url yml_airline_name yml_url)
			csv << attributes
			count = 0
			airlines.each do |airline|
				table_airline_name = airline.carrier_name rescue ""
				yml_airline_name = I18n.t("airlines.#{airline.carrier_code}") rescue ""
				table_url = airline.url rescue ""
				publish_status = airline.publish_status rescue ""
				yml_url = url_escape(format_overview_link(yml_airline_name))
				csv << [airline.carrier_code,publish_status,table_airline_name,table_url,yml_airline_name,yml_url]
				puts "#{count+=1} airlines written"
			end
		end
	end


	task popular_url: :environment do
	   CSV.open("IN_popular_flight_routes.csv","w") do |csv|
	   	attributes = %w{cities dep_city_name arr_city_name dep_city_code arr_city_code flight_count url}
		unique_in_route = UniqueRoute.all.order("weekly_flights_count desc").first(1000)
		unique_in_route.each_with_index do |route,index|
			dep_city_name = route.dep_city_name rescue nil
			arr_city_name = route.arr_city_name rescue nil
			dep_city_code = route.dep_city_code rescue nil
			arr_city_code = route.arr_city_code rescue nil
			weekly_flights_count = route.weekly_flights_count rescue nil
            url = "www.cleartrip.com/flight-schedule/#{route.schedule_route_url}-flights.html"
            csv << ["#{dep_city_name} to #{arr_city_name}",dep_city_name,arr_city_name,dep_city_code,arr_city_code,weekly_flights_count,url]
            puts "#{index} is completed"
		end
	end

	end
end