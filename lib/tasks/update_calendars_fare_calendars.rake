require 'net/http'
require 'json'
namespace :data_ae_fare do
	task :store_sa_data => :environment do
		calendars = FareCalendar.where(section:"AE")
		calendars.each do |cal|
			FareCalendar.create(section:"SA",source_city_code:cal.source_city_code,destination_city_code:cal.destination_city_code,calendar_json:"")
		end
	end

	task :gen_ae_json => :environment do
		require 'net/http'
		ActiveRecord::Base.establish_connection(:calendar_mysql)
		calendars = Calendar.all
		startDate = Date.today.strftime('%Y%m%d').to_i
		endDate = (Date.today.at_beginning_of_week + 5.weeks - 1.day).strftime('%Y%m%d').to_i
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
			sleep(0.8)
		end
		puts "#{count} records have been inserted"
	end

	task :gen_ae_json_fare_calendar => :environment do
		require 'net/http'
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
			sleep(0.8)
		end
		puts "#{count} records have been inserted"
	end



	task :update_calendar_routes => :environment do
		require 'net/http'
		ActiveRecord::Base.establish_connection(:development)
		start_date = Date.today.strftime('%Y%m%d').to_i
		end_date = (Date.today.at_beginning_of_week + 5.weeks - 1.day).strftime('%Y%m%d').to_i
		count = 0
		CSV.foreach("#{Rails.root}/public/update_calendar_routes.csv", :headers=>true).each_with_index do |row,index|
			source_city_code = row[0]
			destination_city_code = row[1]
			section = row[2]
			if section == "IN"
				domain = "com"
				url  ="https://www.cleartrip.#{domain}/flights/calendar/calendarstub.json?from=#{source_city_code}&to=#{destination_city_code}&start_date=#{start_date}&end_date=#{end_date}"
			else
				domain = "sa"
				url  ="https://www.cleartrip.#{domain}/ar/flights/calendar/calendarstub.json?from=#{source_city_code}&to=#{destination_city_code}&start_date=#{start_date}&end_date=#{end_date}"
			end
			res = HTTParty.get(url,:headers =>{"user-agent": "seo-codingmart"})
			puts url
			calendar= Calendar.find_by(source_city_code: source_city_code,destination_city_code: destination_city_code,section:section)
			unless calendar.present?
				Calendar.create(source_city_code: source_city_code,destination_city_code: destination_city_code,section:section)
				calendar= Calendar.find_by(source_city_code: source_city_code,destination_city_code: destination_city_code,section:section)
			end
			if calendar.present? && res.present? && res.body.present?
				calendar.update_attributes(:calendar_json=>res.body)
			end
			count += 1
			sleep(0.8)
			puts "#{count} records have been inserted"
		end
	end


	task :update_fare_calendar_routes => :environment do
		require 'net/http'
		ActiveRecord::Base.establish_connection(:development)
		start_date = Date.today.strftime('%Y%m%d').to_i
		end_date = (Date.today.at_beginning_of_week + 10.weeks - 4.day).strftime('%Y%m%d').to_i
		count = 0
		CSV.foreach("#{Rails.root}/public/update_calendar_routes.csv", :headers=>true).each_with_index do |row,index|
			source_city_code = row[0]
			destination_city_code = row[1]
			section = row[2]
			if section == "IN"
				domain = "com"
				url  ="https://www.cleartrip.#{domain}/flights/calendar/calendarstub.json?from=#{source_city_code}&to=#{destination_city_code}&start_date=#{start_date}&end_date=#{end_date}"
			else
				domain = "sa"
				url  ="https://www.cleartrip.#{domain}/ar/flights/calendar/calendarstub.json?from=#{source_city_code}&to=#{destination_city_code}&start_date=#{start_date}&end_date=#{end_date}"
			end
			res = HTTParty.get(url,:headers =>{"user-agent": "seo-codingmart"})
			puts url
			fare_cal = FareCalendar.find_by(source_city_code: source_city_code,destination_city_code: destination_city_code,section:section)
			unless fare_cal.present?
				FareCalendar.create(source_city_code:source_city_code,destination_city_code:destination_city_code,section:section)
				fare_cal = FareCalendar.find_by(source_city_code: source_city_code,destination_city_code: destination_city_code,section:section)
			end
			if fare_cal.present? && res.present? &&  res.body.present?
				fare_cal.update_attributes(:calendar_json=>res.body)
			end
			count += 1
			sleep(0.8)
			puts "#{count} fare calendar  records have been inserted"
		end
	end


	task :gen_ae_json_calendar => :environment do
		calendars = Calendar.all
		startDate = Date.today.strftime('%Y%m%d').to_i
		endDate = (Date.today.at_beginning_of_week + 5.weeks - 1.day).strftime('%Y%m%d').to_i
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
			sleep(0.8)
		end
	end

	task :update_single_calender_route => :environment do
		require 'net/http'
		ActiveRecord::Base.establish_connection(:development)
		start_date = Date.today.strftime('%Y%m%d').to_i
		end_date = (Date.today.at_beginning_of_week + 10.weeks - 4.day).strftime('%Y%m%d').to_i
		domain ='com'
		url  ="https://www.cleartrip.#{domain}/flights/calendar/calendarstub.json?from=CJB&to=VTZ&start_date=#{start_date}&end_date=#{end_date}"
		res = HTTParty.get(url,:headers =>{"user-agent": "seo-codingmart"})
		fare_cal = Calendar.find_by(source_city_code: 'CJB',destination_city_code: 'VTZ',section:'IN')
		fare_cal.update_attributes(:calendar_json=>res.body)
	end
end
