# require "net/http"
# require "sitemap_generator"
# # Set the host name for URL creation
# namespace :sitemap do
#   task :generate => :environment do
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
#
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
#     domains = ["kw.cleartrip.com","om.cleartrip.com","bh.cleartrip.com","qa.cleartrip.com"]
#     languages.each do |lang|
#       language = lang == "en" ? "" : "/#{lang}"
#       domains.each do |domain|
#         country  = domain.gsub(".cleartrip.com",'')
#         SitemapGenerator::Sitemap.default_host = "https://#{domain}"
#         SitemapGenerator::Sitemap.public_path = "#{Rails.root}/public/sitemap_generated/#{country}"
#         SitemapGenerator::Sitemap.sitemaps_path = 'flight-booking'
#         SitemapGenerator::Sitemap.namer = SitemapGenerator::SimpleNamer.new("#{country.upcase}-flight-booking-new-#{lang.gsub("/",'')}")
#         # sections.each do |section|
#           SitemapGenerator::Sitemap.create do
#             airlines = AirlineBrand.all
#             airlines.each do |al|
#               carrier_code = al.carrier_code
#               if al.carrier_name.present?
#                 carrier_name = al.carrier_name
#               else
#                 carrier_name = I18n.t("airlines.#{carrier_code}")
#               end
#               carrier_name_formatted = url_escape(format_carrier_name(carrier_name))
#               overview_url = "#{carrier_name_formatted}.html"
#               pnr_link_url = "#{carrier_name_formatted}-flight-pnr-status.html"
#               webcheck_in_url = "#{carrier_name_formatted}-web-check-in.html"
#               add "#{language}/flight-booking/#{overview_url}",priority: 0.5, changefreq: 'weekly'
#               add "#{language}/flight-booking/#{pnr_link_url}",priority: 0.5, changefreq: 'weekly'
#               add "#{language}/flight-booking/#{webcheck  _in_url}",priority: 0.5, changefreq: 'weekly'
#               puts "#{overview_url} genererated"
#             end
#
#
#
#             # Put links creation logic here.
#             #
#             # The root path '/' and sitemap index file are added automatically for you.
#             # Links are added to the Sitemap in the order they are specified.
#             #
#             # Usage: add(path, options={})
#             #        (default options are used if you don't specify)
#             #
#             # Defaults: :priority => 0.5, :changefreq => 'weekly',
#             #           :lastmod => Time.now, :host => default_host
#             #
#             # Examples:
#             #
#             # Add '/articles'
#             #
#             #   add articles_path, :priority => 0.7, :changefreq => 'daily'
#             #
#             # Add all articles:
#             #
#             #   Article.find_each do |article|
#             #     add article_path(article), :lastmod => article.updated_at
#             #   end
#           end
#
#         # end
#       end
#     end
#   end
# end
