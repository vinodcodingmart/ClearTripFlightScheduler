# require "net/http"
# require "sitemap_generator"
# # Set the host name for URL creation
# namespace :sitemap1 do
#   task :generate_booking => :environment do
#     def url_escape(url_string)
#       unless url_string.blank?
#         result = url_string.encode("UTF-8", :invalid => :replace, :undef => :replace).to_s
#         result = result.gsub(/[\/]/,'-')
#         result = result.gsub(/[^\x00-\x7F]+/, '') # Remove anything non-ASCII entirely (e.g. diacritics).
#         result = result.gsub(/[^\w_ \-]+/i,   '') # Remove unwanted chars.
#         result = result.gsub(/[ \-]+/i,      '-') # No more than one of the separator in a row.
#         result = result.gsub(/^\-|\-$/i,      '') # Remove leading/trailing separator.
#         result = result.downcase
#       end
#     end

#     def format_carrier_name(carrier_name)
#       unless carrier_name.blank?
#         if(carrier_name.downcase.include?('airlines') || carrier_name.downcase.include?('airline')|| carrier_name.downcase.include?('air lines'))
#           result = carrier_name.downcase
#           result = result.gsub("airlines","")
#           result = result.gsub("airline","")
#           result = result.gsub("air lines","")
#           result = result.strip.downcase.gsub(" ", "-")
#           result = result+"-airlines"
#         else
#           result = carrier_name.downcase.gsub(" ","-")+ "-airlines"
#         end
#       end
#     end
#     languages = ["en","ar"]
#     I18n.locale = "en"
#     # domains = ["www.cleartrip.com"]
#     domains = ["www.cleartrip.com","www.cleartrip.ae","www.cleartrip.sa","kw.cleartrip.com","om.cleartrip.com","bh.cleartrip.com","qa.cleartrip.com"]
#     languages.each do |lang|
#       language = lang == "en" ? "" : "/#{lang}"
#       domains.each do |domain|
#         if domain == "www.cleartrip.com"
#           country  = "in"
#         elsif domain.include?("www.cleartrip.sa" ) || domain.include?("www.cleartrip.ae")
#           country = domain.gsub("www.cleartrip.",'')
#         else
#           country = domain.gsub(".cleartrip.com",'')
#         end

#         if domain ==  "www.cleartrip.com"
#           country_code = "IN"
#         elsif domain == "www.cleartrip.ae"
#           country_code = "AE"
#         elsif domain == "www.cleartrip.sa"
#           country_code = "SA"
#         elsif domain == "kw.cleartrip.com"
#           country_code = "KW"
#         elsif domain == "om.cleartrip.com"
#           country_code = "OM"
#         elsif domain == "bh.cleartrip.com"
#           country_code = "BH"
#         elsif domain == "qa.cleartrip.com"
#           country_code = "QA" 
#         else
#           country_code = "Not There"
#         end
#         if country_code=="IN" && lang=="ar"
#           next
#         end

#         SitemapGenerator::Sitemap.default_host = "https://#{domain}"
#         SitemapGenerator::Sitemap.public_path = "#{Rails.root}/public"
#         SitemapGenerator::Sitemap.sitemaps_path = 'flight-booking'
#         # SitemapGenerator::Sitemap.namer = SitemapGenerator::SimpleNamer.new("#{country.upcase}-flight-booking-new-#{lang.gsub("/",'')}")
#         SitemapGenerator::Sitemap.namer = SitemapGenerator::SimpleNamer.new("#{country.upcase}-INT-routes-#{lang.gsub("/",'')}")

#         # sections.each do |section|
#           SitemapGenerator::Sitemap.create do
#             # airlines = AirlineBrand.where.not(country_code:country_code)
#             # airlines.each do |al|
#             #   carrier_code = al.carrier_code
#             #   if al.carrier_name.present?
#             #     carrier_name = al.carrier_name
#             #   else
#             #     carrier_name = I18n.t("airlines.#{carrier_code}")
#             #   end
#             #   carrier_name_formatted = url_escape(format_carrier_name(carrier_name))
#             #   overview_url = "#{carrier_name_formatted}.html"
#             #   # pnr_link_url = "#{carrier_name_formatted}-flight-pnr-status.html"
#             #   # webcheck_in_url = "#{carrier_name_formatted}-web-check-in.html"
#             #   add "#{language}/flight-booking/#{overview_url}",priority: 0.5, changefreq: 'weekly'
#             #   # add "#{language}/flight-booking/#{pnr_link_url}",priority: 0.5, changefreq: 'weekly'
#             #   # add "#{language}/flight-booking/#{webcheck_in_url}",priority: 0.5, changefreq: 'weekly'
#             #   puts "#{carrier_name_formatted} genererated"
#             # end
#             # airline_unique_routes = AirlineUniqueRoute.where(dep_country_code: country_code, arr_country_code: country_code)
#             airline_unique_routes = AirlineUniqueRoute.where("dep_country_code!=? OR arr_country_code!=?",country_code,country_code)
#             airline_unique_routes.each do |r|
#               url = r.url_format
#               add "#{language}/flight-booking/#{url}",priority: 0.5, changefreq: 'weekly'
#             end
#           end
#         end
#       end
#     end

#   task :generate_schedule => :environment do
#     languages = ["en","ar"]
#     I18n.locale = "en"
#     # domains = ["kw.cleartrip.com","om.cleartrip.com","bh.cleartrip.com","qa.cleartrip.com"]
#     # domains = ["www.cleartrip.ae","www.cleartrip.sa","kw.cleartrip.com","om.cleartrip.com","bh.cleartrip.com","qa.cleartrip.com"]
#     domains = ["www.cleartrip.com","www.cleartrip.ae","www.cleartrip.sa","kw.cleartrip.com","om.cleartrip.com","bh.cleartrip.com","qa.cleartrip.com"]

#     languages.each do |lang|
#       language = lang == "en" ? "" : "/#{lang}"
#       domains.each do |domain|
#         if domain == "www.cleartrip.com"
#           country  = "in"
#         elsif domain.include?("www.cleartrip.sa" ) || domain.include?("www.cleartrip.ae")
#           country = domain.gsub("www.cleartrip.",'')
#         else
#           country = domain.gsub(".cleartrip.com",'')
#         end
#         if domain ==  "www.cleartrip.com"
#           country_code = "IN"
#         elsif domain == "www.cleartrip.ae"
#           country_code = "AE"
#         elsif domain == "www.cleartrip.sa"
#           country_code = "SA"
#         elsif domain == "kw.cleartrip.com"
#           country_code = "KW"
#         elsif domain == "om.cleartrip.com"
#           country_code = "OM"
#         elsif domain == "bh.cleartrip.com"
#           country_code = "BH"
#         elsif domain == "qa.cleartrip.com"
#           country_code = "QA" 
#         else
#           country_code = "Not There"
#         end
#         if country_code=="IN" && lang=="ar"
#           next
#         end
#         SitemapGenerator::Sitemap.default_host = "https://#{domain}"
#         SitemapGenerator::Sitemap.public_path = "#{Rails.root}/public"
#         SitemapGenerator::Sitemap.sitemaps_path = 'flight-schedule'
#         SitemapGenerator::Sitemap.namer =  SitemapGenerator::SimpleNamer.new("#{country.upcase}-INT-to-#{lang.gsub("/",'')}")
#         # sections.each do |section|
#           SitemapGenerator::Sitemap.create do
#             # unique_routes = UniqueRoute.where.not(schedule_route_url: nil).where("dep_country_code!=? OR arr_country_code!=?",country_code,country_code)
#             # unique_hop_routes = UniqueHopRoute.where.not(url: nil).where("dep_country_code!=? OR arr_country_code!=?",country_code,country_code)
#             # routes = unique_routes + unique_hop_routes
#             # unique_routes.find_each do |r|
#             #   url = r.schedule_route_url + "-flights.html" rescue "flight-schedules-domestic.html"
#             #   url = url + "-cheap"
#             #   add "#{language}/flight-schedule/#{url}",priority: 0.5, changefreq: 'weekly'
#             # end
#             # unique_hop_routes.find_each do |r|
#             #   url = r.url + "-flights.html" rescue "flight-schedules-domestic.html"
#             #   add "#{language}/flight-schedule/#{url}",priority: 0.5, changefreq: 'weekly'
#             # end
#             cities = CityName.all
#             cities.each_with_index do |city,index|
#               city_name = city.city_name_en
#               city_code = city.city_code
#               if city_code.present?
#              city_country = UniqueRoute.find_by(dep_city_code:city_code).dep_country_code rescue nil
#              unless city_country.present?
#               city_country = UniqueHopRoute.find_by(dep_city_code:city_code).dep_country_code rescue nil
#             end
#             if city_country.present? && (city_country != country_code) && city.to_url.present?
#               url  = city.to_url + ".html"
#              add "#{language}/flight-schedule/#{url}",priority: 0.5, changefreq: 'weekly'
#             end
#           end
#                        puts "#{index} is completed"

#           end
#         end
#       end
#     end
#   end

#   task :generate_tickets => :environment do
#     languages = ["en","ar"]
#     I18n.locale = "en"
#     # domains = ["kw.cleartrip.com","om.cleartrip.com","bh.cleartrip.com","qa.cleartrip.com"]
#     domains = ["www.cleartrip.sa","www.cleartrip.ae","www.cleartrip.com","kw.cleartrip.com","om.cleartrip.com","bh.cleartrip.com","qa.cleartrip.com"]
#     languages.each do |lang|
#       language = lang == "en" ? "" : "/#{lang}"
#       domains.each do |domain|
#         if domain == "www.cleartrip.com"
#           country  = "in"
#         elsif domain.include?("www.cleartrip.sa" ) || domain.include?("www.cleartrip.ae")
#           country = domain.gsub("www.cleartrip.",'')
#         else
#           country = domain.gsub(".cleartrip.com",'')
#         end
#         SitemapGenerator::Sitemap.default_host = "https://#{domain}"
#         SitemapGenerator::Sitemap.public_path = "#{Rails.root}/public"
#         SitemapGenerator::Sitemap.sitemaps_path = 'flight-tickets'
#         SitemapGenerator::Sitemap.namer =  SitemapGenerator::SimpleNamer.new("#{country.upcase}-flight-tickets-#{lang.gsub("/",'')}")
#         # sections.each do |section|
#           SitemapGenerator::Sitemap.create do
#             unique_routes = UniqueRoute.where.not(schedule_route_url: nil)
#             unique_hop_routes = UniqueHopRoute.where.not(url: nil)
#             # routes = unique_routes + unique_hop_routes
#             unique_routes.find_each do |r|
#               url = r.schedule_route_url + "-cheap-airtickets.html" rescue "cheap-flight-air-tickets-domestic.html"
#               url = url + "-cheap"
#               add "#{language}/flight-tickets/#{url}",priority: 0.5, changefreq: 'weekly'
#             end
#             unique_hop_routes.find_each do |r|
#               url = r.url + "-cheap-airtickets.html" rescue "cheap-flight-air-tickets-domestic.html"
#               add "#{language}/flight-tickets/#{url}",priority: 0.5, changefreq: 'weekly'
#             end
#           end
#         end
#       end
#     end
#   end

