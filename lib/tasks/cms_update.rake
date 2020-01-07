namespace :cms_content do

  desc "update AE content cms"
  task ae_update: :environment do
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
  	contents = AeAirlineContent.where.not(overview_keywords_en:"")
  	contents.each_with_index do |content,index|
  		carrier_code = content.carrier_code
  		airline = AirlineBrand.where(carrier_code:carrier_code,publish_status:"active")
  		if airline.present?
        carrier_name = airline.first.carrier_name
  			overview_content = content.overview_content_ar
  			# description = content.meta_description_en
  			# keywords = content.overview_keywords_en
  			domain = "BH"
  			page_type = "flight-booking"
  			page_subtype = "overview"
  			language = "ar"
  			if airline.first.country_code == "BH"
  				section = "dom"
  			else
  				section = "int"
  			end
    			url = "bh.cleartrip.com/ar/flight-booking/#{url_escape(carrier_name.gsub("airlines","").gsub("Airlines",""))}-airlines.html"
  			cms = CMS::UniqueFbOverview.find_or_create_by(domain:domain,page_type:page_type,page_subtype:page_subtype,language:language,airline_name:carrier_name,section:section)
  			cms.update(url:url,is_approved:true,content:overview_content)
  		end
  		puts "#{index} is completed"
  	end
  end


  task sa_update: :environment do
    routes = CMS::UniqueFsRoute.where(domain:"SA",language:"ar")
    routes.each_with_index do |route,index|
      url = route.url.gsub("flights.com","flights.html")
      faq = []
      route.update(url:url,faq_object:faq)
      puts "#{index} is completed"
  end
  end


  task ar_update: :environment do
    routes =  CMS::UniqueFbRoute.where(language:"ar")
    routes.each_with_index do |route|

      unless route.url.include? "/ar/"
      end
    end
  end

  task ar_content: :environment do
    load_content  = SCHEDULE_ROUTE_CONTENT
      unique_route_content = load_content["ae_routes_content"]["ar"]["unique_content"]
      unique_route_content.each do |key,value|
        cities =  key.gsub("_content","").split("_")
        content = value
        dep_city_code = cities.first
        arr_city_code = cities.last
        dep_city_name = CityName.where(city_code:dep_city_code).first.city_name_en
        arr_city_name = CityName.where(city_code:arr_city_code).first.city_name_en
        if dep_city_name.present? && arr_city_name.present? && content.present?
          domain = "AE"
          page_type = "flight-booking"
          page_subtype = "overview"
          language = "ar"
          url = "www.cleartrip.ae/ar/flight-schedule/#{url_escape(dep_city_name)}-#{url_escape(arr_city_name)}-flights.html"
          schedule = UniqueRoute.where(dep_city_code:dep_city_code,arr_city_code:arr_city_code)
          if schedule.present?
            dep_country_code = schedule.first.dep_country_code rescue nil
            arr_country_code = schedule.first.arr_country_code rescue nil
            if dep_country_code == arr_country_code
              section = "dom"
            else
              section = "int" 
            end
          else
            section = "dom"
          end
          record = CMS::UniqueFsRoute.find_or_create_by(domain:domain,language:language,source:dep_city_name,destination:arr_city_name,section:section)
          record.update(content:content,is_approved:true,url:url,page_type:"flight-schedule",page_subtype:"routes")
        end
        puts " is completed"
      end

  end


  task meta_ar_booking: :environment do
    load_content = SEO_META["airline_routes"]
    sections = ["dom","int"]
    domains = ["AE","SA","BH","QA","KW","OM"]
    domains.each do |domain|
      sections.each do |section|
        data = load_content[domain.downcase]["ar"][section.downcase]
        title = data["title_with_price"]
        description = data["description"]
        keywords = data["keywords"]
        heading = "%{airline_name} <br /> %{dep_city_name} إلى %{arr_city_name}"
        record = CMS::Common.where(page_type:"flight-booking",page_subtype:"routes",language:"ar",domain:domain,section:section)
        if record.present?
          record.first.update(title:title,description:description,keyword:keywords,heading:heading)
        end
        puts "#{domain} of #{section} is completed"
      end
    end
  end





end