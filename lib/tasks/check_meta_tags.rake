require 'rubygems'
require 'nokogiri'
require 'open-uri'
# require 'restclient'
# require "pdfkit"
require 'net/http'
namespace :urls do
  task health_check: :environment do

    def check_page_type(url)
      if url.include?("/flight-schedule/")
        if url.include?("-flights.html")
          page_type = "schedule_route"
        elsif url.include?("flights-from") || url.include?("flights-to")
          page_type = "from_to"
        elsif url.include?("flight-schedules-domestic") || url.include?("flight-schedules-international")
          page_type = "schedule_index"
        end
      elsif url.include?("/flight-booking/")
        if url.include?("-flights")
          page_type = "booking_route"
        elsif url.include?("pnr-status.html")
          page_type = "pnr_status"
        elsif url.include?("web-check-in.html")
          page_type = "web_checkin"
        elsif url.include?("domestic-airlines") || url.include?("international-airlines")
          page_type = "booking_index"
        else
          page_type = "overview"
        end
      elsif url.include?("/flight-tickets/")
        page_tye = "flight_tickets"
      elsif url.include?("/tourism/airports/")
        page_type = "airports"
      end
      return page_type
    end

    def fetch(uri_str, limit = 10)
      raise ArgumentError, 'too many HTTP redirects' if limit == 0
      uri = URI.parse(uri_str)
      http = Net::HTTP.new(uri.host,uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)
      case response.code
      when "200"
        return response.body
      when "301","302"
        location = response['location']
        warn "redirected to #{location}"
        fetch(location, limit - 1)
      else
        return response.body
      end
    end

    def get_page_load_score(ct_url)
      page_speed_api_key = "AIzaSyDzCsbth4jAnIxYOuBNcCpDb8Y9My7Q4dI"
      stratgies = ["desktop","mobile"]
      scores = { "desktop"=>"",
       "mobile" => "",
       "response" => ""}
       stratgies.each do |s|
        url = "https://www.googleapis.com/pagespeedonline/v1/runPagespeed?url=#{ct_url}" +
        "&key=#{page_speed_api_key}&strategy=#{s}"
        uri = URI.parse(url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        request = Net::HTTP::Get.new(uri.request_uri)
        response = http.request(request)
        parsed_response = JSON.parse(response.body)
        scores["#{s}"] = parsed_response["score"]
        scores["response"] = parsed_response["responseCode"]
      end
      return scores
    end
#    hotel_urls =[]
 #   current_date =[]
  #  local_urls =[]
   # tourism_train_urls =[]
    #flights_urls =["https://www.cleartrip.com/flight-schedule/mumbai-new-delhi-flights.html"]
    flights_urls = ["https://www.cleartrip.com/flight-schedule/mumbai-new-delhi-flights.html","https://www.cleartrip.com/flight-booking/indigo-airlines.html","https://www.cleartrip.com/flight-tickets/chennai-muscat-cheap-airtickets.html","https://www.cleartrip.com/flight-booking/indigo-airlines-flight-pnr-status.html","https://www.cleartrip.com/flight-booking/indigo-airlines-web-check-in.html"]
    hotel_urls = ["https://www.cleartrip.com/hotels/india/goa/","https://www.cleartrip.com/hotels/info/novotel-goa-resort-spa-718637","https://www.cleartrip.com/hotels/india/goa/weekend-getaways/","https://www.cleartrip.com/hotels/india/goa/stars/5/","https://www.cleartrip.com/hotels/india/goa/east-goa/","https://www.cleartrip.com/hotels/india/goa/resorts/","https://www.cleartrip.com/hotels/india/goa/chain/accor-group-of-hotels/","https://www.cleartrip.com/hotels/india/goa/hotels-with-24-hour-checkin-in-goa/","https://www.cleartrip.com/hotels/india/new-delhi/hospital/hotels-near-artemis-hospital-gurgaon/","https://www.cleartrip.com/hotels/india/goa/landmark/agnel-ashram-bus-stand/","https://www.cleartrip.com/hotels/india/goa/locality/arpora/"]
    local_urls = ["https://www.cleartrip.com/activities/goa/things-to-do","https://www.cleartrip.com/activities/goa/1-hour-mandovi-river-cruise"]
    tourism_train_urls = ["https://www.cleartrip.com/tourism/train/routes/mumbai-to-new-delhi-trains.html","https://www.cleartrip.com/tourism/routes/dd/gurgaon-to-lucknow-route.html","https://www.cleartrip.com/india/kolkata/","https://www.cleartrip.com/trains/list","https://www.cleartrip.com/tourism/routes/ii/aalborg-to-christchurch-route.html","https://www.cleartrip.com/trains/12724","https://www.cleartrip.com/trains/stations/TPTY","https://www.cleartrip.com/trains/stations/list"]
    current_date = Date.today.to_formatted_s(:rfc822).to_s.gsub(" ","_")
    current_time = Time.now.strftime("%I:%M %p").to_s.gsub(":",'_').gsub(" ","_")
    yesterday_date = Date.yesterday.to_formatted_s(:rfc822).to_s.gsub(" ","_")
    FileUtils.rm_rf Dir.glob("#{Rails.root}/health_check_reports/meta_checker_in_*.csv")
    file_name_in = "/health_check_reports/meta_checker_in_#{current_date}_#{current_time}.csv"
    CSV.open("#{Rails.root}/#{file_name_in}","w+") do |csv|
      attributes = %w( URL Title Title_Content Description Description_content  Keywords Href_langs X_default Canonical H1_tag Calender Content Schema GA_code Status Desktop_page_load_score Mobile_page_load_score)
      csv << attributes
      failed_count =  0
      count = 0
      flights_urls.each do |furl|
        begin
          response = fetch(furl)
          page = Nokogiri::HTML(response)
          page_type = check_page_type(furl)
          meta_checker = UrlHealthChecker.new(furl,page_type,page)
          scores = get_page_load_score(furl)
          result = meta_checker.flights_result
          csv << [furl,result[:title][:title], result[:title][:title_content],result[:description][:description] ,result[:description][:description_content],result[:keywords],result[:href_langs],result[:x_default],result[:canonical],result[:h1_tag],result[:calendar],result[:content],result[:schema],result[:ga_code],scores["response"],scores["desktop"],scores["mobile"]]
          puts "#{count+=1} - Healt Check for #{furl}"
        rescue StandardError => e
          puts   e.backtrace
          error_msg = e.message
          csv << [furl,"Error","Error","Error","Error","Error","Error","Error","Error","Error","Error","Error","Error",error_msg,"Error","Error"]
          puts "#{failed_count+=1} - Healt Check for #{furl} Failed !!!!!"
        end
      end
      puts "\n\n"
      count = 0
      failed_count = 0
      hotel_urls.each do |hurl|
        begin
          response = fetch(hurl)
          page = Nokogiri::HTML(response)
          page_type = ''
          meta_checker = UrlHealthChecker.new(hurl,page_type,page)
          scores = get_page_load_score(hurl)
          result = meta_checker.hotels_result
          csv << [hurl,result[:title][:title], result[:title][:title_content],result[:description][:description] ,result[:description][:description_content],result[:keywords],result[:href_langs],result[:x_default],result[:canonical],result[:h1_tag],result[:calendar],result[:content],result[:schema],result[:ga_code],scores["response"],scores["desktop"],scores["mobile"]]
          puts "#{count+=1} - Healt Check for #{hurl}"
        rescue StandardError => e
          puts   e.backtrace
          error_msg = e.message
          csv << [hurl,"Error","Error","Error","Error","Error","Error","Error","Error","Error","Error","Error","Error",error_msg,"Error","Error"]
          puts "#{failed_count+=1} - Healt Check for #{hurl} Failed !!!!!"
        end
      end
      puts "\n\n"
      count = 0
      failed_count = 0
      local_urls.each do |l_url|
        begin
          response = fetch(l_url)
          page = Nokogiri::HTML(response)
          page_type = ''
          meta_checker = UrlHealthChecker.new(l_url,page_type,page)
          scores = get_page_load_score(l_url)
          result = meta_checker.locals_result
          csv << [l_url,result[:title][:title], result[:title][:title_content],result[:description][:description] ,result[:description][:description_content],result[:keywords],result[:href_langs],result[:x_default],result[:canonical],result[:h1_tag],result[:calendar],result[:content],result[:schema],result[:ga_code],scores["response"],scores["desktop"],scores["mobile"]]
          puts "#{count+=1} - Health Check for #{l_url}"
        rescue StandardError => e
          puts e.backtrace
          error_msg = e.message
          csv << [l_url,"Error","Error","Error","Error","Error","Error","Error","Error","Error","Error","Error","Error",error_msg,"Error","Error"]
          puts "#{failed_count+=1} - Health Check for #{l_url} Failed !!!!!"
        end
      end
      puts "\n\n"
      count = 0
      failed_count = 0
      tourism_train_urls.each do |t_url|
        begin
          response = fetch(t_url)
          page = Nokogiri::HTML(response)
          page_type = ''
          meta_checker = UrlHealthChecker.new(t_url,page_type,page)
          scores = get_page_load_score(t_url)
          result = meta_checker.trains_result
          csv << [t_url,result[:title][:title], result[:title][:title_content],result[:description][:description] ,result[:description][:description_content],result[:keywords],result[:href_langs],result[:x_default],result[:canonical],result[:h1_tag],result[:calendar],result[:content],result[:schema],result[:ga_code],scores["response"],scores["desktop"],scores["mobile"]]
          puts "#{count+=1} - Health Check for #{t_url}"
        rescue StandardError => e
          e.backtrace
          error_msg = e.message
          csv << [t_url,"Error","Error","Error","Error","Error","Error","Error","Error","Error","Error","Error","Error",error_msg,"Error","Error"]
          puts "#{failed_count+=1} - Health Check for #{t_url} Failed !!!!!"
        end
      end
    end
    csv_file_in = File.read("#{Rails.root}/#{file_name_in}")

    #sa and ae file create csv 
   # flights_urls_sa =["https://www.cleartrip.sa/flight-schedule/riyadh-abha-flights.html"]
  flights_urls_sa  =  ["https://www.cleartrip.sa/flight-schedule/riyadh-abha-flights.html","https://www.cleartrip.sa/flight-booking/saudi-arabian-air-airlines.html","https://www.cleartrip.sa/flight-tickets/chennai-muscat-cheap-airtickets.html","https://www.cleartrip.sa/tourism/airports/dubai-airport.html","https://www.cleartrip.sa/flight-booking/saudi-arabian-air-airlines-flight-pnr-status.html","https://www.cleartrip.sa/flight-booking/saudi-arabian-air-airlines-web-check-in.html","https://www.cleartrip.sa/flight-booking/saudi-arabian-air-baggages.html","https://www.cleartrip.sa/flight-booking/saudi-arabian-air-airlines-customer-support.html","https://www.cleartrip.sa/ar/flight-schedule/riyadh-abha-flights.html","https://www.cleartrip.sa/ar/flight-booking/saudi-arabian-air-airlines.html","https://www.cleartrip.sa/ar/flight-tickets/chennai-muscat-cheap-airtickets.html","https://www.cleartrip.sa/tourism/airports/ar/dubai-airport.html","https://www.cleartrip.sa/ar/flight-booking/saudi-arabian-air-airlines-flight-pnr-status.html","https://www.cleartrip.sa/ar/flight-booking/saudi-arabian-air-airlines-web-check-in.html","https://www.cleartrip.sa/ar/flight-booking/saudi-arabian-air-baggages.html","https://www.cleartrip.sa/ar/flight-booking/saudi-arabian-air-airlines-customer-support.html","https://www.cleartrip.ae/flight-schedule/mumbai-dubai-flights.html","https://www.cleartrip.ae/flight-booking/emirates-airlines.html","https://www.cleartrip.ae/flight-tickets/bangkok-new-delhi-cheap-airtickets.html","https://www.cleartrip.ae/tourism/airports/dubai-airport.html","https://www.cleartrip.ae/flight-booking/emirates-airlines-flight-pnr-status.html","https://www.cleartrip.ae/flight-booking/emirates-airlines-web-check-in.html","https://www.cleartrip.ae/ar/flight-schedule/mumbai-dubai-flights.html","https://www.cleartrip.ae/ar/flight-tickets/bangkok-new-delhi-cheap-airtickets.html","https://www.cleartrip.ae/ar/flight-booking/emirates-airlines.html","https://www.cleartrip.ae/ar/flight-booking/emirates-airlines-flight-pnr-status.html","https://www.cleartrip.ae/ar/flight-booking/emirates-airlines-web-check-in.html","https://www.cleartrip.ae/tourism/airports/ar/dubai-airport.html"]
    current_date = Date.today.to_formatted_s(:rfc822).to_s.gsub(" ","_")
    current_time = Time.now.strftime("%I:%M %p").to_s.gsub(":",'_').gsub(" ","_")
    FileUtils.rm_rf Dir.glob("#{Rails.root}/health_check_reports/meta_checker_sa_and_ae*.csv")
    file_name_sa = "/health_check_reports/meta_checker_sa_and_ae_#{current_date}_#{current_time}.csv"
    CSV.open("#{Rails.root}/#{file_name_sa}","w+") do |csv|
      attributes = %w( URL Title Title_Content Description Description_content  Keywords Href_langs X_default Canonical H1_tag Calender Content Schema GA_code Status Desktop_page_load_score Mobile_page_load_score)
      csv << attributes
      failed_count =  0
      count = 0
      flights_urls_sa.each do |furl|
        begin
          response = fetch(furl)
          page = Nokogiri::HTML(response)
          page_type = check_page_type(furl)
          meta_checker = UrlHealthChecker.new(furl,page_type,page)
          scores = get_page_load_score(furl)
          result = meta_checker.flights_result
          csv << [furl,result[:title][:title], result[:title][:title_content],result[:description][:description] ,result[:description][:description_content],result[:keywords],result[:href_langs],result[:x_default],result[:canonical],result[:h1_tag],result[:calendar],result[:content],result[:schema],result[:ga_code],scores["response"],scores["desktop"],scores["mobile"]]
          puts "#{count+=1} - Healt Check for #{furl}"
        rescue StandardError => e
          puts   e.backtrace
          error_msg = e.message
          csv << [furl,"Error","Error","Error","Error","Error","Error","Error","Error","Error","Error","Error","Error",error_msg,"Error","Error"]
          puts "#{failed_count+=1} - Healt Check for #{furl} Failed !!!!!"
        end
      end
    end
    csv_file_sa = File.read("#{Rails.root}/#{file_name_sa}")
    report_mail = ReportMailer.send_report([csv_file_in,csv_file_sa],[file_name_in,file_name_sa]).deliver
  end
end