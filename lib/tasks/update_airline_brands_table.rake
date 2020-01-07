namespace :airline_brand do

	desc "update airline url" 
	task :update_url => :environment do 
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
	  airlines = AirlineBrand.where("publish_status='active'")
	  airlines.each do |airline|

	  	airline_name = airline.carrier_name 
  		url  = url_escape(format_overview_link(airline_name))
  		airline.url = url
  		airline.save
  	end
	end

	desc "update airlinebrands table "
	task :update_airlines => :environment do
		count = 0
		CSV.foreach("public/all_carriers.csv", :headers=>true).each_with_index do |row,index|
			begin
				carrier_code = row[0]
				carrier_name = row[1]
				country_code = row[2]
				icoa_code = row[5]
				# airline = AirlineBrand.where(carrier_code: carrier_code,icoa_code: icoa_code).update_all(publish_status: 'active') rescue nil
				#if !airline.nil? && airline.present? 
					airline = AirlineBrand.where(carrier_code: carrier_code,publish_status: 'active').where.not(carrier_name: carrier_name)
				#end
				ex_carrier_names = []
				ex_carrier_name = airline.map{|a| ["#{a.carrier_code}","#{a.carrier_name}"]}
				if ex_carrier_name.any?
					puts  "#{count+=1} update for airline-#{ex_carrier_name}"
				end
				# if airline.nil? && !airline.present?
				# 	airline = AirlineBrand.find_or_create_by(carrier_code: carrier_code,icoa_code: icoa_code)
				# 	brand_routes_count = PackageFlightSchedule.where(carrier_code: carrier_code).count
				# 	airline.carrier_name = carrier_name.titleize
				# 	airline.country_code = country_code
				# 	airline.brand_routes_count = brand_routes_count
				# 	airline.save!
				# 	puts "#{count+=1} inserted for airline-#{carrier_name}-#{carrier_code}"
				# end
			rescue StandardError => e
			end

		end

	end

		desc "update airlinebrands table "
	task :update_ceased_airlines => :environment do
		c1 = 0
		c2 = 0
		CSV.foreach("public/final_airline.csv", :headers=>true).each_with_index do |row,index|
			begin
				carrier_code = row[0]
				icoa_code = row[1]
				carrier_name = row[2]
				status = row[7]
				airlines = []
				# airline = AirlineBrand.where(carrier_code: carrier_code,icoa_code: icoa_code).update_all(publish_status: 'active') rescue nil
				#if !airline.nil? && airline.present? 
				ccs = AirlineBrand.all.pluck(:carrier_code).uniq
				ccs.each do |cc|
					airlines = AirlineBrand.where(carrier_code: cc)
					if airlines.count > 1
						airline_names = airlines.map{|a| a.carrier_names}
						puts "#{c1+=1} checked for carrier_code: #{cc} ---- #{airline_names}"
					end

				end
				# if status == "ceased"
				# 	airline = AirlineBrand.where(carrier_code: carrier_code,carrier_name: carrier_name).update_all(publish_status: status)
				# 	airlines = airline.map{|a| a.carrier_name}
				# 	puts  "#{c1+=1} update for #{airlines}"
				# else
				# 	# airline = AirlineBrand.where(carrier_code: carrier_code,carrier_name: carrier_name)
				# 	# airlines = airline.map{|a| a.carrier_name}
				# 	# puts  "#{c2+=1} update for #{airlines}"
				# end

				
				#end
				# ex_carrier_names = []
				# ex_carrier_name = airline.map{|a| ["#{a.carrier_code}","#{a.carrier_name}"]}
				# if ex_carrier_name.any?
				# 	puts  "#{count+=1} update for airline-#{ex_carrier_name}"
				# end
				# if airline.nil? && !airline.present?
				# 	airline = AirlineBrand.find_or_create_by(carrier_code: carrier_code,icoa_code: icoa_code)
				# 	brand_routes_count = PackageFlightSchedule.where(carrier_code: carrier_code).count
				# 	airline.carrier_name = carrier_name.titleize
				# 	airline.country_code = country_code
				# 	airline.brand_routes_count = brand_routes_count
				# 	airline.save!
				# 	puts "#{count+=1} inserted for airline-#{carrier_name}-#{carrier_code}"
				# end
			rescue StandardError => e
			end

		end

	end

	desc "update airlinebrands pnr and webcheck-in links "
	task :update_airline_links => :environment do

		count = 0
		CSV.foreach("public/pnr_webcheckin_url.csv", :headers=>true).each_with_index do |row,index|
			begin
				carrier_code = row[0]
				carrier_name = row[1]
				icoa_code = row[2]
				pnr_link = row[3]
				webcheckin_link = row[4]
				airline = AirlineBrand.find_by(carrier_code: carrier_code,icoa_code: icoa_code)
				if !airline.nil? && airline.present?
					airline.pnr_link =  pnr_link
					airline.web_checkin_link = webcheckin_link
					airline.save
					puts "#{count+=1} updated for airline-#{carrier_name}-#{carrier_code}"
				end
			rescue StandardError => e
				
			end

		end

	end
end
