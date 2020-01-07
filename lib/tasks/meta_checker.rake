# require 'rubygems'
# require 'nokogiri'
# # require 'open-uri'
# # require 'rest-client'
# #
namespace :check do

#   task :find => :environment do
#   	PopularRoute.all.each do |d|
#   		country_code = UniqueRoute.where(arr_city_code:d.arr_city_code,dep_city_name:d.dep_city_name).pluck(:arr_country_code,:dep_country_code)
#   		if country_code[0][0] == country_code[0][1]
#   			section = "dom"
#   		else
#   			section = "int"
#   		end
#   		p d.update(section:section)
#   	end
    
#       # page = Nokogiri::HTML(RestClient.get("https://www.cleartrip.sa/flight-schedule/bangalore-chennai-flights.html"))
      
#   end
# end
####### uniq content picker ######
	task get: :environment do
		Axlsx::Package.new do |p|
		  p.workbook.add_worksheet(:name => "Pie Chart") do |sheet|
		    sheet.add_row ["Title","OG Title","OG Description","Description","Keyword","Content","Source","Destination","Url","Domain","Section","Language","Faq"]
		    CMS::UniqueFsRoute.all.each do|d|
		    	sheet.add_row [d.title,d.og_title,d.og_description,d.description,d.keyword,d.content.present?,d.source,d.destination,d.url,d.domain,d.section,d.language,d.faq_object.present?]
		    end
		    
		  end
		  p.serialize('Unique_content.xlsx')
		end

		# CSV.open("Unique_content.csv","w+") do |csv|
		# 	csv << ["Title","OG Title","OG Description","Description","Keyword","Content","Source","Destination","Url","Domain","Section","Language","Faq"]
		# 	CMS::UniqueFsRoute.all.each do|d|
		# 		title = d.title.encode("UTF-8") rescue "" 
		# 		og_title = d.og_title.encode("UTF-8") rescue ""
		# 		og_description = d.og_description.encode("UTF-8") rescue ""
		# 		description = d.description.encode("UTF-8") rescue ""
		# 		keyword = d.keyword.encode("UTF-8") rescue ""
		# 		csv << [title,og_title,og_description,description,keyword,d.content.present?,d.source,d.destination,d.url,d.domain,d.section,d.language,d.faq_object.present?]
		# 	end
		# end

	end
end