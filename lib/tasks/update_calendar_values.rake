require 'net/http'
require 'json'
namespace :data_ae_fare do
	desc "update fare calendar"
	task :gen_ae_json_fare_calendar => :environment do
		ActiveRecord::Base.establish_connection(:calendar_mysql)
		calendars = FareCalendar.all
		startDate = Date.today.strftime('%Y%m%d').to_i
		endDate = (Date.today.at_beginning_of_week + 13.weeks - 1.day).strftime('%Y%m%d').to_i
		count = 0
		calendars.each do |cal|
			if cal.section == "IN"
				domain = "com"
				url  ="https://www.cleartrip.#{domain}/flights/calendar/calendarstub.json?from=#{cal.source_city_code}&to=#{cal.destination_city_code}&start_date=#{startDate}&end_date=#{endDate}"	
			elsif cal.section == "AE"
				domain = "ae"
				url  ="https://www.cleartrip.#{domain}/ar/flights/calendar/calendarstub.json?from=#{cal.source_city_code}&to=#{cal.destination_city_code}&start_date=#{startDate}&end_date=#{endDate}"	
			else
				domain = "sa"
				url  ="https://www.cleartrip.#{domain}/ar/flights/calendar/calendarstub.json?from=#{cal.source_city_code}&to=#{cal.destination_city_code}&start_date=#{startDate}&end_date=#{endDate}"
			end
			res = HTTParty.get(url,:headers =>{"user-agent": "seo-codingmart"})
			puts url
			count += 1
			cal.update_attributes(:calendar_json=>res.body)
			sleep(0.33)
		end
	end

	task :store_sa_data => :environment do
		calendars = FareCalendar.where(section:"AE")
		calendars.each do |cal|
			FareCalendar.create(section:"SA",source_city_code:cal.source_city_code,destination_city_code:cal.destination_city_code,calendar_json:"")
		end
	end
end

