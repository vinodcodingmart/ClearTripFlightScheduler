require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'net/http'
require "#{Rails.root}/app/helpers/application_helper"
include ApplicationHelper

namespace :page_status do 
	task get_en_ar_missing_city_names: :environment do 
		@uniq_schedule_routes  = UniqueRoute.where(dep_city_name: [nil, ""]).or(UniqueRoute.where(arr_city_name: [nil, ""]))
		headers =  %w{city_code}
		missing_routes = []
		CSV.open("city_names_missing_for_english_and_arabic.csv","w+") do |csv| 
			csv << headers
			@uniq_schedule_routes.each do |route|
				unless route.dep_city_name.present?
					unless missing_routes.include?(route['dep_city_code'])
						missing_routes << route['dep_city_code']
					end
				end
				unless route.arr_city_name.present?
					unless missing_routes.include?(route['arr_city_code'])
						missing_routes << route['arr_city_code']
					end
				end
			end
			r = missing_routes.uniq
			r.each do |c|
				csv << [c]
				city_info = CityName.find_by(city_code:c)
				if city_info.present?
					
					dep_routes = UniqueRoute.where(dep_city_code: city_info['city_code'],dep_city_name:[nil,""]).update_all(dep_city_name: city_info['city_name_en'],dep_city_name_ar: city_info['city_name_ar'] )
					arr_routes = UniqueRoute.where(arr_city_code: city_info['city_code'],arr_city_name:[nil,""]).update_all(arr_city_name: city_info['city_name_en'],arr_city_name_ar: city_info['city_name_ar'])
					p "#{city_info['city_name_en']} => #{city_info['city_name_ar']}"
				end
			end
		end
	end

	
	task update_of_schedule_urls: :environment do 
		@uniq_schedule_routes  = UniqueRoute.where.not(dep_city_name: [nil, ""],arr_city_name: [nil, ""])
		@uniq_schedule_routes.each do |route|
			schedule_route_url = url_escape("#{route.dep_city_name}-#{route.arr_city_name}")
			route.update(schedule_route_url: schedule_route_url)
			p schedule_route_url
		end
	end
end