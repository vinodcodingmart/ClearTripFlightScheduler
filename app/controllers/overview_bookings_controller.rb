require_relative "#{Rails.root}/lib/application_processor.rb"
require_relative "#{Rails.root}/lib/flight_booking_service.rb"

class OverviewBookingsController < ApplicationController
	include ApplicationHelper

	def redirect_airlines_to_bookings
		path = "#{request.path}"
		lang = params[:lang] == "ar" ? params[:lang] : ""
		if path.include?("/airlines/") || path.include?("/airlines/ar/")
			format_url = path.gsub("/airlines/", "/fight-booking/")
			if params[:lang].nil?
				redirect_to flight_booking_path(:airline => params[:airline]),status: 301
			else
				redirect_to lang_flight_booking_path(:airline => params[:airline],:lang => params[:lang]),status: 301
			end
		end
	end

	def check_url
		lang = params[:lang] == "ar" ? params[:lang] : ""
		if lang == "ar"
			redirect_to lang_flight_booking_path(:lang => params[:lang],:airline => params[:airline]).to_s+".html",:status=>301 and return
		else
			redirect_to flight_booking_path(:airline => params[:airline]).to_s+".html",:status=>301 and return
		end
	end

	def booking_values
		domain = "https://" + request.host
		path = "#{request.path}"

		unless ["ar",nil].include?(params[:lang])
			redirect_to flight_booking_path(:route => params[:airline]).to_s+".html",:status=>301 and return
		end
		unless path.to_s.end_with? ".html"
			main_url = path.to_s+".html"
			redirect_to main_url,:status=>301 and return
		end
	  if params[:airline] == "eurofly-spa-airlines" || params[:airline] == "eurofly-airlines"
	     redirect_to "https://eurofly.flightxp.com/",status: 301 and return
	  end
		@application_processor = ApplicationProcessor.new
		@country_code = @application_processor.host_country_code(domain)[0]
		@country_name = @application_processor.host_country_code(domain)[1]
		@formatted_country_name = @country_name.downcase.strip.gsub(" ",'-')
		@language = params[:lang].nil? ? 'en' : params[:lang]
		file_paths = YAML.load(File.read('config/application.yml'))[Rails.env]
		@assets_path = file_paths["assets_path"]
		lang = @language == "en" ? "" : "/#{@language}"
		@host_name = @application_processor.host_name(@country_code)
		@page_type = "flight-booking"
	    if path.include?("/amp/")
	      redirect_to "#{path.gsub("/amp/","/")}",status: 301 and return
	    end
		if path.include?("/domestic-airlines") || path.include?("/international-airlines")
			booking_index
			return
		end
		check_domain = check_domain(@language,@country_code)
		if check_domain
			lang = @language == "en" ? "" : "#{@language}"
			if @country_code == "IN"
					redirect_to "#{@host_name}/flight-booking/domestic-airlines.html",status: 301 and return
			else
					redirect_to "#{@host_name}/flight-booking/domestic-airlines.html",status: 301 and return
			end
		end
		I18n.locale = @language
		if params[:airline].end_with?("flight-pnr-status") || params[:airline].end_with?("web-check-in") || params[:airline].end_with?("baggages") || params[:airline].end_with?("customer-support") || params[:airline].end_with?("special-assistance") || params[:airline].end_with?("refund-cancellation") || params[:airline].end_with?("travel-documents")
			pnr_web_check_in
			return
		end
		if params[:airline].include?("-flights")
			if ["IN","AE","SA","KW","QA"].include?(@country_code)
					airline_routes
					return
			else
				m = is_mobile? ? "/m" : ''
				redirect_to "#{@host_name}#{m}/flights?utm_source=google&utm_medium=organic&utm_campaign=flight_booking_redirection",status: 301 
			end
			return
		end
		
		@meta_page_type  = "booking-overview"

		unless !params[:airline].end_with?("-airlines-airlines") 
		  check_airlines_in_url
		  return
		end
		unless params[:airline].end_with?("-airlines") 
		  check_airlines_in_url
		  return
		end
		airline_name = params[:airline]
		carrier_name = params[:airline].gsub("-",' ').gsub(/\d/,'').gsub("airlines",'').titleize.strip
		carrier_name_with_airline = carrier_name + " Airlines"
		page_no = airline_name.gsub(/[^0-9]/,'').to_i || 0
		page_name = airline_name.gsub(/-\d/,'')
		@file_name = airline_name+".html"  
		if page_no  > 0
			lang = params[:lang] == "ar" ? "/ar" : "" 
			redirect_to "#{lang}/flight-booking/" + page_name + ".html",status: 301 and return
		end
		airline = carrier_name = params[:airline].split("-airlines")[0].gsub("-", ' ').titleize.strip
		carrier_name_with_airline = carrier_name + " Airlines"
		airline = AirlineBrand.find_by("carrier_name='#{carrier_name}' OR carrier_name ='#{carrier_name_with_airline}'")	
		if airline.nil? || !airline.present?
			redirect_to "#{@host_name}/flight-booking/domestic-airlines.html",status: 301 and return
		end
		if airline.carrier_name.present? && !airline.carrier_name.nil?
			@carrier_name = airline.carrier_name
		else
			redirect_to "#{@host_name}/flight-booking/domestic-airlines.html",status: 301 and return
		end

		# @carrier_name = nil rescue redirect_to "#{@host_name}/flight-booking/domestic-airlines.html" and return
		@carrier_code = airline.carrier_code
		@carrier_name_ar = I18n.with_locale(:ar) {I18n.t("airlines.#{@carrier_code}")}

		@section = airline.country_code == @country_code ? "#{@country_code}-dom" : "#{@country_code}-int"
		@airline_details = {  carrier_code: @carrier_code,
							  carrier_name: @carrier_name,
							  section: @section,
							  country_code: @country_code,
							  language: @language,
							  carrier_name_ar: @carrier_name_ar
						    }
		airline_types = check_airline_types
		flight_booking_service = FlightBookingService.new @airline_details
		airline_more_routes =  flight_booking_service.airline_more_routes
		# pagination = custom_pagination(page_no,airline_more_routes,@file_name)
		popular_routes = flight_booking_service.airline_popular_routes
	  top_sectors = flight_booking_service.brand_top_sectors
	    # @cms_content = flight_booking_service.fetch_cms_route_content(nil,"flight-booking","overview",top_sectors,@host_name,nil)
	    # if @language =="ar" && @country_code =="SA"
	    # 	@content = flight_booking_service.fetch_arabic_content rescue ""
	    # 	h1_temp = flight_booking_service.h1_title_temp rescue ""
	    # 	@title = @content["meta_title_en_ar"] rescue ""
	    # 	@description = @content["meta_description_ar"] rescue ""
	    # 	@keywords = @content["overview_keywords_ar"] rescue ""
	    # 	@h1_title = h1_temp[@carrier_code] rescue ""
	    # elsif @language =="ar"
	    # 	@content = flight_booking_service.fetch_arabic_content rescue ""
	    # else

	    	if @language == "ar"
	    	  @content = flight_booking_service.fetch_arabic_content rescue ""
	    	end
		    @cms_data = flight_booking_service.fetch_cms_airline_content(nil,"flight-booking","overview",top_sectors,@host_name,nil)
		    @title = @cms_data["title"]
		    @description = @cms_data["description"]
		    @keywords = @cms_data["keywords"]
		    @cms_content = @cms_data["content"]
		    @h1_title = @cms_data["h1_title"]
		    @review = @cms_data["reviews"]
		    @faq = @cms_data["faq"]
	  	# end
	  header_pnr_web_check_in =  flight_booking_service.check_airline_special_pages_existence
	  @review_content = flight_booking_service.fetch_review_content
		header_routes = flight_booking_service.header_airline_routes
		search_widget_popular_routes = flight_booking_service.overview_search_widget_popular_routes
		header_airports = flight_booking_service.top_dom_int_airports
		rhs_top_hotels =  @country_code == "IN" ? flight_booking_service.rhs_top_hotels : {}
		rhs_airlines = flight_booking_service.rhs_top_airlines
		rhs_schedule_routes = @language=="ar" ? flight_booking_service.rhs_top_schedule_routes_ar : flight_booking_service.rhs_top_schedule_routes
		booking_footer = flight_booking_service.booking_footer
	    section =  @section.include?("dom") ? "dom" : "int"
		unless !path.include?("/amp/")
			image_present = false
		    image_url = "https://d2w5af8s1781.cloudfront.net/waytogo-staging/images/airline-logo/#{@carrier_code}.png"
		    resp = Net::HTTP.get_response(URI.parse(image_url))
		    if resp.code.to_i >= 200 && resp.code.to_i < 400
		       image_present =  true
		    end
			partial =  "new_designs/bookings/amp_overview/#{@language}_#{section}_amp_airline_overview"
			render partial,locals: {popular_routes: popular_routes,header_routes: header_routes,flight_file_name: @file_name,application_processor: @application_processor,page_type: 'flight-booking',header_airports: header_airports,customer_support: airline_types[:customer_support],baggages: airline_types[:baggages],rhs_airlines: rhs_airlines,rhs_schedule_routes: rhs_schedule_routes,content: @content,booking_footer: booking_footer,top_sectors: top_sectors,country_code: @country_code,tag_line: "",section: section,image_present: image_present},layout: false
			return
		end
		# if @country_code == "AE" 
		# # if (@country_code == "BH" && @language == "en" && @carrier_code == "9W") 
		# 	partial = "version_2_designs/bookings/airline_overviews/#{@language.downcase}_#{section}_airline_overview_v2"
		# else
		# 	partial = "new_designs/bookings/airline_overviews/#{@language.downcase}_#{section}_airline_overview"
		# end
		partial = "version_2_designs/bookings/airline_overviews/#{@language.downcase}_#{section}_airline_overview_v2"
		# partial = "new_designs/bookings/airline_overviews/#{@language.downcase}_#{section}_airline_overview"
		render partial,locals: {search_widget_popular_routes: search_widget_popular_routes,popular_routes: popular_routes,header_routes: header_routes,flight_file_name: @file_name,application_processor: @application_processor,page_type: 'flight-booking',header_airports: header_airports,customer_support: airline_types[:customer_support],baggages: airline_types[:baggages],rhs_airlines: rhs_airlines,rhs_schedule_routes: rhs_schedule_routes,content: @content,booking_footer: booking_footer,top_sectors: top_sectors,country_code: @country_code,tag_line: "",section: section,rhs_top_hotels: rhs_top_hotels,header_pnr_web_check_in: header_pnr_web_check_in}
	end
	def check_airlines_in_url
	  lang =  @language == "ar" ? "/ar" : ""
	  airline = params[:airline].split("-airlines")[0] 
	  redirect_to "#{@host_name}#{lang}/flight-booking/#{airline}" + "-airlines.html",status: 301 and return
	end
	def pnr_web_check_in
	application_processor = ApplicationProcessor.new
		@file_name = params[:airline] + ".html"
		if params[:airline].include?("pnr-status")
			@meta_page_type = "pnr_status"
		elsif params[:airline].include?("web-check-in")
			@meta_page_type = "web_checkin"
		elsif params[:airline].include?("customer-support")
			@meta_page_type = "customer_support"
		elsif params[:airline].include?("baggages")
			@meta_page_type = "baggage"
		elsif params[:airline].include?("special-assistance")
      		@meta_page_type = "special_assistance"
    	elsif params[:airline].include?("refund-cancellation")
      		@meta_page_type="refund_cancellation"
    	elsif params[:airline].include?("travel-documents")
      		@meta_page_type="travel_documents"
		end
		@language = params[:lang] == "ar"  ? "ar" : "en"
		carrier_name = params[:airline].split("-airlines")[0].gsub("-", ' ').titleize.strip
		if carrier_name.include?("Baggages")
	      carrier_name= carrier_name.gsub(" Baggages","")
	    end
	    if carrier_name.include?("Customer Support")
	      carrier_name=carrier_name.gsub(" Customer Support","")
	    end
	    if carrier_name.include?("Special Assistance")
	      carrier_name=carrier_name.gsub(" Special Assistance","")
	    end
	    if carrier_name.include?("Refund Cancellation")
	      carrier_name=carrier_name.gsub(" Refund Cancellation","")
	    end
	    if carrier_name.include?("Travel Documents")
	      carrier_name=carrier_name.gsub(" Travel Documents","")
	    end
		carrier_name_with_airline = carrier_name + " Airlines"
		airline = AirlineBrand.find_by("carrier_name='#{carrier_name}' OR carrier_name ='#{carrier_name_with_airline}'")
		if airline.nil? || !airline.present?
			redirect_to "#{@host_name}/flight-booking/domestic-airlines.html",status: 301 and return
		end
		if airline.carrier_name.present? && !airline.carrier_name.nil?
			@carrier_name = airline.carrier_name
		else
			redirect_to "#{@host_name}/flight-booking/domestic-airlines.html",status: 301 and return
		end
		@carrier_code = airline.carrier_code
		@carrier_name_ar = I18n.with_locale(:ar) {I18n.t("airlines.#{@carrier_code}")}
		pnr_link = airline.pnr_link
		web_checkin_link = airline.web_checkin_link
		file_paths = YAML.load(File.read('config/application.yml'))[Rails.env]
		@assets_path = file_paths["assets_path"]
		@section = airline.country_code == @country_code ? "#{@country_code}-dom" : "#{@country_code}-int"
		@airline_details = {  carrier_code: @carrier_code,
													carrier_name: @carrier_name,
													section: @section,
													country_code: @country_code,
													language: @language,
													carrier_name_ar: @carrier_name_ar,
												}
		airline_types = check_airline_types
		flight_booking_service = FlightBookingService.new @airline_details
		# airline_more_routes =  flight_booking_service.airline_more_routes
		header_routes = flight_booking_service.header_airline_routes
	 	header_airports = flight_booking_service.top_dom_int_airports
	 	rhs_airlines = flight_booking_service.rhs_top_airlines
		booking_footer = flight_booking_service.booking_footer
		# @cms_content = flight_booking_service.fetch_cms_route_content(nil,"flight-booking",@meta_page_type,nil,@host_name,nil)
		header_pnr_web_check_in =  flight_booking_service.check_airline_special_pages_existence
		# header_pnr_web_check_in=flight_booking_service.checking_pnr_web

		if @meta_page_type == "pnr_status" || @meta_page_type == "web_checkin"
			@cms_content = flight_booking_service.fetch_cms_airline_content(nil,"flight-booking",@meta_page_type,nil,@host_name,nil)
	    @title = @cms_content["title"]
	    @description = @cms_content["description"]
	    @keywords = @cms_content["keywords"]
	    @content = @cms_content["content"]
	    @h1_title = @cms_content["h1_title"]
	    @review = @cms_content["reviews"]
	  else
	   	@special_pages_content = flight_booking_service.fetch_review_content
	  end
   	if @meta_page_type=="pnr_status" || @meta_page_type=="web_checkin"
    	partial = "bookings/pnr_webcheck_in/airline_pnr_webcheckin_#{@language}"
    	render partial,locals: {header_routes: header_routes,flight_file_name: @file_name,application_processor: application_processor,page_type: 'flight-booking',header_airports: header_airports,customer_support: airline_types[:customer_support],baggages: airline_types[:baggages],rhs_airlines: rhs_airlines,content: @special_pages_content,booking_footer: booking_footer,pnr_link: pnr_link,web_checkin_link: web_checkin_link,carrier_name: @carrier_name,carrier_name_ar: @carrier_name_ar,country_code:@country_code,header_pnr_web_check_in: header_pnr_web_check_in,brand_type: @meta_page_type}
    elsif @meta_page_type=="baggage" && header_pnr_web_check_in["baggage_content"]
      partial ="bookings/pnr_webcheck_in/airline_baggages_#{@language}"
      render partial,locals: {header_routes: header_routes,flight_file_name: @file_name,application_processor: application_processor,page_type: 'flight-booking',header_airports: header_airports,customer_support: airline_types[:customer_support],baggages: airline_types[:baggages],rhs_airlines: rhs_airlines,content: @special_pages_content,booking_footer: booking_footer,pnr_link: pnr_link,web_checkin_link: web_checkin_link,carrier_name: @carrier_name,carrier_name_ar: @carrier_name_ar,country_code:@country_code,header_pnr_web_check_in: header_pnr_web_check_in}
    
    elsif  @meta_page_type=="customer_support" && header_pnr_web_check_in["customer_support_content"] 
      partial ="bookings/pnr_webcheck_in/airline_customer_support_#{@language}"
         render partial,locals: {header_routes: header_routes,flight_file_name: @file_name,application_processor: application_processor,page_type: 'flight-booking',header_airports: header_airports,customer_support: airline_types[:customer_support],baggages: airline_types[:baggages],rhs_airlines: rhs_airlines,content: @special_pages_content,booking_footer: booking_footer,pnr_link: pnr_link,web_checkin_link: web_checkin_link,carrier_name: @carrier_name,carrier_name_ar: @carrier_name_ar,country_code:@country_code,header_pnr_web_check_in: header_pnr_web_check_in}
   
    elsif   @meta_page_type=="refund_cancellation" && header_pnr_web_check_in["cancellation_content"] 
      partial ="bookings/pnr_webcheck_in/airline_cancellation_content_#{@language}"
         render partial,locals: {header_routes: header_routes,flight_file_name: @file_name,application_processor: application_processor,page_type: 'flight-booking',header_airports: header_airports,customer_support: airline_types[:customer_support],baggages: airline_types[:baggages],rhs_airlines: rhs_airlines,content: @special_pages_content,booking_footer: booking_footer,pnr_link: pnr_link,web_checkin_link: web_checkin_link,carrier_name: @carrier_name,carrier_name_ar: @carrier_name_ar,country_code:@country_code,header_pnr_web_check_in: header_pnr_web_check_in}
    elsif header_pnr_web_check_in["special_assistance"] && @meta_page_type=="special_assistance"
       partial ="bookings/pnr_webcheck_in/airline_special_assistance_#{@language}"
      render partial,locals: {header_routes: header_routes,flight_file_name: @file_name,application_processor: application_processor,page_type: 'flight-booking',header_airports: header_airports,customer_support: airline_types[:customer_support],baggages: airline_types[:baggages],rhs_airlines: rhs_airlines,content: @special_pages_content["special_assistance_en"],booking_footer: booking_footer,pnr_link: pnr_link,web_checkin_link: web_checkin_link,carrier_name: @carrier_name,carrier_name_ar: @carrier_name_ar,country_code:@country_code,header_pnr_web_check_in: header_pnr_web_check_in}
    elsif header_pnr_web_check_in["travel_document"] && @meta_page_type=="travel_documents"
       partial ="bookings/pnr_webcheck_in/airline_travel_document_#{@language}"
      render partial,locals: {header_routes: header_routes,flight_file_name: @file_name,application_processor: application_processor,page_type: 'flight-booking',header_airports: header_airports,customer_support: airline_types[:customer_support],baggages: airline_types[:baggages],rhs_airlines: rhs_airlines,content: @special_pages_content["travel_document_en"],booking_footer: booking_footer,pnr_link: pnr_link,web_checkin_link: web_checkin_link,carrier_name: @carrier_name,carrier_name_ar: @carrier_name_ar,country_code:@country_code,header_pnr_web_check_in: header_pnr_web_check_in}
     else
        redirect_to "#{@host_name}/flight-booking/domestic-airlines.html",status: 301 and return
    end

		# partial = "bookings/pnr_webcheck_in/airline_pnr_webcheckin_#{@language}"
		# render partial,locals: {header_routes: header_routes,flight_file_name: @file_name,application_processor: application_processor,page_type: 'flight-booking',header_airports: header_airports,customer_support: airline_types[:customer_support],baggages: airline_types[:baggages],rhs_airlines: rhs_airlines,content: @content,booking_footer: booking_footer,pnr_link: pnr_link,web_checkin_link: web_checkin_link,carrier_name: @carrier_name,carrier_name_ar: @carrier_name_ar}
	end

  def redirect_booking_routes(airline_route)

    url = airline_route.url_format
    carrier_name = airline_route.carrier_name.downcase.gsub(" ","-")
    schedule_url =  url.gsub("#{carrier_name}-", "")
    redirection_url = @language == "ar" ? "#{@host_name}/ar/flight-schedule/#{schedule_url}.html" : "#{@host_name}/flight-schedule/#{schedule_url}.html"
    redirect_to redirection_url,status: 301 and return
  end

	def airline_routes
	  url_format = params[:airline].gsub(/-[0-9]/,"").gsub(/[0-9]/,"")
	  @meta_page_type = "airline_routes"
	  @airline = AirlineUniqueRoute.where(url_format: url_format).first
		unless @airline.present?
			redirect_to "#{@host_name}/flight-booking/domestic-airlines.html",status:301 and return
		end

		unless !["SA","QA"].include?(@country_code) 
			redirect_booking_routes(@airline)
			return
		end

		if params["airline"]  =~ /\d/ 
			lang = @language == "en" ? "" : "/#{@language}"
			redirect_to "#{@host_name}#{lang}/flight-booking/#{url_format}.html",status:301 and return
		end

	  @carrier_name = @airline.carrier_name
	  @carrier_name_ar = @airline.carrier_name_ar
	  @carrier_code = @airline.carrier_code
	  @dep_city_code = @airline.dep_city_code
	  @arr_city_code = @airline.arr_city_code
	  @dep_city_name = @airline.dep_city_name
	  @arr_city_name = @airline.arr_city_name
	  @dep_country_code = @airline.dep_country_code
	  @arr_country_code = @airline.arr_country_code
	  @dep_city_name_ar = CityName.find_by(city_code: @airline.dep_city_code).city_name_ar rescue ""
	  @arr_city_name_ar = CityName.find_by(city_code: @airline.arr_city_code).city_name_ar rescue ""
	  @section = ( @dep_country_code == @country_code && @arr_country_code ==  @country_code ) ? "#{@country_code}-dom" : "#{@country_code}-int"
	  airports = Hash[Airport.where(:city_code=>[@dep_city_code,@arr_city_code]).map{|c| [c.city_code,c]}]
	  @dep_airport_code = airports[@dep_city_code].airport_code rescue @dep_city_code
	  @arr_airport_code = airports[@arr_city_code].airport_code rescue @arr_city_code
	  @dep_airport_name = airports[@dep_city_code].airport_name rescue ""
	  @arr_airport_name = airports[@arr_city_code].airport_name rescue ""
	  @dep_airport_name_ar = airports[@dep_city_code].airport_name_ar rescue ""
	  @arr_airport_name_ar = airports[@arr_city_code].airport_name_ar rescue ""
	  route_details = { carrier_name: @carrier_name,
	                    carrier_code: @carrier_code,
	                    dep_city_code: @dep_city_code,
	                    arr_city_code: @arr_city_code,
	                    dep_city_name: @dep_city_name,
	                    arr_city_name: @arr_city_name,
	                    dep_country_code: @dep_country_code,
	                    arr_country_code: @arr_country_code,
	                    country_code: @country_code,
	                    section: @section,
	                    language: @language,
	                    dep_city_name_ar: @dep_city_name_ar,
	                    arr_city_name_ar: @arr_city_name_ar,
	                	carrier_name_ar: @carrier_name_ar}

	  flight_booking_service = FlightBookingService.new route_details
	  case @country_code
	  when  "IN"
	    @airline_route_schedules = @airline.in_airline_route_schedules
	  when  "AE"
	    @airline_route_schedules = @airline.ae_airline_route_schedules
	  when  "SA"
	    @airline_route_schedules = @airline.sa_airline_route_schedules
	  when  "BH"
	    @airline_route_schedules = @airline.bh_airline_route_schedules
	  when  "QA"
	    @airline_route_schedules = @airline.qa_airline_route_schedules
	  when  "KW"
	    @airline_route_schedules = @airline.kw_airline_route_schedules
	  when  "OM"
	    @airline_route_schedules = @airline.om_airline_route_schedules
	  else
	    @airline_route_schedules = @airline.om_airline_route_schedules
	  end
	  if @airline_route_schedules.empty?
	    redirect_to "#{@host_name}/flight-booking/domestic-airlines.html",status: 301 and return
	  end
	  header_routes = flight_booking_service.airline_top_header_routes
	  header_airports = flight_booking_service.top_dom_int_airports
	  rhs_airlines = flight_booking_service.rhs_top_airlines
	  booking_footer = flight_booking_service.booking_footer
	  page_no = params[:airline].gsub(/[^0-9]/,'').to_i || 0
	  page_name = params[:airline].gsub(/-\d/,'')
	  @file_name = url_format + ".html"
	  
	  airline_route_schedules = flight_booking_service.airline_route_schedule_values(@airline_route_schedules)
	  # airline_more_routes =  flight_booking_service.airline_more_routes
	  airline_more_routes =  flight_booking_service.airline_more_routes_new
	  rhs_schedule_routes = @language=="ar" ? flight_booking_service.rhs_top_schedule_routes_ar : flight_booking_service.rhs_top_schedule_routes
	  pagination = custom_pagination(page_no,airline_more_routes,@file_name)
	  airport_details = {
       dep_airport_code:@dep_airport_code, 
       arr_airport_code:@arr_airport_code, 
       dep_airport_name:@dep_airport_name, 
       arr_airport_name:@arr_airport_name, 
       dep_airport_name_ar:@dep_airport_name_ar, 
       arr_airport_name_ar:@arr_airport_name_ar, 
       airline_route_schedules:airline_route_schedules
    }
	  @title_min_price = airline_route_schedules.first[:cc_route_min_price]
	  airline_types = check_airline_types
	  header_pnr_web_check_in =  flight_booking_service.check_airline_special_pages_existence

	  # @cms_content = flight_booking_service.fetch_cms_route_content(@title_min_price,"flight-booking","routes",nil,@host_name,airport_details)
	  @cms_content = flight_booking_service.fetch_cms_airline_route_content(@title_min_price,"flight-booking","routes",nil,@host_name,airport_details)
	  @title = @cms_content["title"]
	  @description = @cms_content["description"]
	  @keywords = @cms_content["keywords"]
	  @content = @cms_content["content"]
	  @h1_title = @cms_content["h1_title"]
	  @faq = @cms_content["faq"]
	  partial = "new_designs/bookings/airline_routes/#{@language.downcase}_#{@section[3..5]}_airline_route_schedule_template_v2"

	  render partial,locals: {airline_route_schedules: airline_route_schedules,header_routes: header_routes,flight_file_name: @file_name,application_processor: @application_processor,page_type: 'flight-booking',header_airports: header_airports,rhs_airlines: rhs_airlines,rhs_schedule_routes: rhs_schedule_routes,booking_footer: booking_footer,pagination: pagination,baggages: airline_types[:baggages],customer_support: airline_types[:customer_support],section: @section,dep_city_name: @dep_city_name,arr_city_name: @arr_city_name,dep_city_name_ar: @dep_city_name_ar,arr_city_name_ar: @arr_city_name_ar,country_code: @country_code,header_pnr_web_check_in: header_pnr_web_check_in}
	end

	def check_airline_types
		customer_support_airlines = ['AI','CX','TG','SQ','G8','AK','UK','SG','G9','9W','LH','EY','BA','6E','QR','EK']
		baggages_airlines = ['AI','TR','EY','SG','QR','AK','9W','G9','6E','FZ','BA','LH','UK','CX','SQ','UA','UL','G8','TG','MH','EK','WY']
		customer_support = @country_code=='IN' ? customer_support_airlines.include?(@carrier_code) : false
		baggages = @country_code=='IN' ? baggages_airlines.include?(@carrier_code) : false
		return {customer_support: customer_support,baggages: baggages}
	end
	def booking_index
		domain = "https://" + request.host
		# domain = 'https://bh.cleartrip.com'
		path = "#{request.path}"
		@application_processor = ApplicationProcessor.new
		@country_code = @application_processor.host_country_code(domain)[0]
		@country_name = @application_processor.host_country_code(domain)[1]
		@language = params[:lang].nil? ? 'en' : params[:lang]
		@file_name = params[:airline] + ".html"
		@section = params[:airline].include?("domestic") ? "dom" : "int"
		if params[:airline]  =~ /\d/ 
			lang = @language == "en" ? "" : "/#{@language}"
			redirect_to "#{@host_name}#{lang}/flight-booking/#{params[:airline].gsub(/-[0-9]/,"").gsub(/[0-9]/,"")}.html",status:301 and return
		end
		@page_type = "flight-booking"
		@meta_page_type = "booking_index"
		query_string = @section == "dom"  ? "=" : "!="
		airline_codes = AirlineBrand.where("country_code #{query_string} '#{@country_code}' and publish_status='active' and carrier_code!='9W'").order(brand_routes_count: :desc).pluck(:carrier_code)
		page_no = params[:airline].gsub(/[^0-9]/,'').to_i || 0
		pagination = custom_pagination(page_no,airline_codes,params[:airline])
		type = @section == "dom" ? "domestic" : "international"
		flight_booking_service = FlightBookingService.new(section: @section,country_code: @country_code,language: @language)
		# @cms_content = flight_booking_service.fetch_cms_route_content(min_price="",page_type="flight-booking",page_subtype="index",top_sectors={},@host_name,airport_details={})
		@cms_content = flight_booking_service.fetch_cms_booking_index_content(min_price="",page_type="flight-booking",page_subtype="index",top_sectors={},@host_name,airport_details={})
	    @title = @cms_content["title"]
	    @description = @cms_content["description"]
	    @keywords = @cms_content["keywords"]
	    @content = @cms_content["content"]
	    @h1_title = @cms_content["h1_title"]
		top_routes = flight_booking_service.rhs_top_schedule_routes["#{@section}_routes".to_sym]
		top_airlines = flight_booking_service.rhs_top_airlines["#{@section}_airlines".to_sym]
		@airlines_count = top_airlines.count
		@airlines = top_airlines.map{|al| I18n.t("airlines.#{al}")}.to_sentence
		top_airports = flight_booking_service.top_dom_int_airports["#{@section}_airports"]
		# partial = "new_designs/bookings/index/#{@language.downcase}_airlines_index"
		partial = "new_pages/bookings/index/#{@language.downcase}_airlines_index"
    render partial,locals: {page_type: @page_type, airline_codes: airline_codes,section: @section,flight_file_name: @file_name,country_code: @country_code,host: @host_name,application_processor: @application_processor,pagination: pagination,top_routes: top_routes,top_airlines: top_airlines,top_airports: top_airports}
	end

	def check_url_format
		
	end

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
end
