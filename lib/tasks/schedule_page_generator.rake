require_relative "#{Rails.root}/lib/application_processor.rb"
# require_relative "#{Rails.root}/lib/flight_schedule_service.rb"
# require_relative "#{Rails.root}/lib/flight_ticket_service.rb"
require_relative "#{Rails.root}/lib/flight_booking_service.rb"
require 'roo'
namespace :schedule do
	task page_generator: :environment do
		route_detail = []
		# CMS::UniqueFsRoute.where(language:"en",domain:"IN").each do |uniq_route|
		# PopularRoute.where(route_type:"1-hop").first(1).each do |uniq_route|
		PopularRoute.all.each do |uniq_route|
			begin
				if !RouteDetail.where("popular_route_id = (#{uniq_route.id}) and created_at > '#{Date.today}'")
					next
				end
				# if RouteDetail.where(popular_route_id:uniq_route.id,created_at: Date.today).count > 0
				# 	next
				# end
				# next if !uniq_route.schedule_route_url.present?
				# full_path = "www.cleartrip.com/flight-schedule/#{uniq_route.schedule_route_url}-flights.html"
				# full_path = uniq_route.url #www.cleartrip.com/flight-schedule/ahmedabad-goa-flights.html########

				 # domain = "www.cleartrip.com"
				 # path =  full_path.gsub("www.cleartrip.com","")
				 # path = full_path.gsub("www.cleartrip.com","")#"/flight-schedule/ahmedabad-goa-flights.html"######
				path = "/flight-schedule/#{uniq_route.url_format}-flights.html"
				
				@country_code = "IN"
				@country_name = "India"
				@has_calendar = ["IN","AE","SA"].include?(@country_code)
				@host_name = "https://www.cleartrip.com"
				@language = 'en'
				@file_name = path.gsub("/flight-schedule/","") #"ahmedabad-goa-flights.html" #######
				I18n.locale = @language
				url = @file_name.gsub("-flights.html","") # "ahmedabad-goa"######
				# check_domain = check_domain(@language,@country_code)
				# if check_domain
				# 	lang = @language == "en" ? "" : "/#{@language}"
				# 	if @country_code == "IN"
				# 		redirect_to "#{@host_name}/flight-schedule/flight-schedules-domestic.html",:status=>301 and return
				# 	else
				# 		redirect_to "#{@host_name}#{lang}/flight-schedule/flight-schedules-domestic.html",:status=>301 and return
				# 	end
				# end
				flight_file_name = path# ahmedabad-goa-flights.html
				# if params[:route].include?("flight-schedules")
				# 	get_index_schedule_values(path)
				# 	return
				# end
				# if path.include?("flights-from") || path.include?("flights-to")
				# 	if ["SA","QA"].include?(@country_code)
				# 		redirect_to "#{@host_name}/flights" ,:status=> 301 and return
				# 	else
				# 		get_from_to(path)
				# 		return
				# 	end
				# end
				@page_type="flight-schedule"
				@meta_page_type = "flight-schedule"
				# if params[:route].include?("-flights")
					# url = "ahmedabad-goa" #params[:route].gsub("-flights","")
				# else
				# 	redirect_to "#{@host_name}/flight-schedule/#{params[:route]}" + "-flights.html",status: 301 and return
				# end
				@route = UniqueRoute.where(schedule_route_url: url).last
				@host = "https://www.cleartrip.com"
				if @route.nil? || !@route.present?
					@route = UniqueHopRoute.find_by(url: url)
					if @route.nil? || !@route.present?
						# if params[:route] =~ /\d/ 
						# 	lang = @language == "en" ? "" : "/#{@language}"
						# 	redirect_to "#{@host_name}#{lang}/flight-schedule/#{url.gsub(/-[0-9]/,"").gsub(/[0-9]/,"")}-flights.html",:status=>301 and return
						# end
						# redirect_to "#{@host_name}/flight-schedule/flight-schedules-domestic.html",:status=>301 and return
						next
					end
					hop_schedule_values = get_hop_schedule(path,url,uniq_route)
					# return
					route_detail << hop_schedule_values
					next
				end
				if @route.present?
					if @route.dep_country_code == @country_code &&  @route.arr_country_code == @country_code
						@section = @country_code + "-dom"
					else
						@section = @country_code + "-int"
					end

					model_name = "#{@country_code.titleize}VolumeRoute".constantize
					@volume_count = model_name.where(dep_city_code: @route.dep_city_code,arr_city_code: @route.arr_city_code).first.volume_count rescue 0

					dep_city = CityName.find_by(city_code: @route.dep_city_code)
					arr_city = CityName.find_by(city_code: @route.arr_city_code)
					begin
						@dep_city_name  = dep_city.city_name_en.titleize
						@arr_city_name = arr_city.city_name_en.titleize
						if @language == "ar"
							if dep_city.city_name_ar.present? && arr_city.city_name_ar.present?
								@dep_city_name_ar  = dep_city.city_name_ar
								@arr_city_name_ar = arr_city.city_name_ar
							else
								next
								# redirect_to "#{@host_name}#{lang}/flight-schedule/flight-schedules-domestic.html",:status=>301 and return
							end
						end
					rescue StandardError => e
						next
						# e.message
						# redirect_to "#{@host_name}#{lang}/flight-schedule/flight-schedules-domestic.html",:status=>301 and return
					end
					# @route_type = @route.hop == 0 ? "non-stop" : "hop"
					# 	.pry
					@dep_city_code = @route.dep_city_code
					@arr_city_code = @route.arr_city_code
					@is_route = ((url == "new-delhi-mumbai" || url == "new-delhi-bangkok" )&& @country_code == "IN") ? true : false
					@route_type = "non-stop"
					if @route.dep_country_code == @country_code &&  @route.arr_country_code == @country_code
						@section = @country_code + "-dom"
					else
						@section = @country_code + "-int"
					end
					if path.include?("/amp/")
						next
						# redirect_to "#{@host_name}#{path.gsub("/amp","")}",:status=> 301 and return
					#elsif @country_code == "AE" 
						# partial = "version_2_designs/schedules/#{@language.downcase}/directs/#{@country_code.downcase}_#{@section[3..5]}_schedule_routes_v2"
					# 	# partial = "new_designs/schedules/#{@country_code.downcase}/directs/#{@country_code.downcase}_#{@language.downcase}_#{@section[3..5]}_schedule_routes_template"
						# layout = true
						# partial = "version_2_designs/schedules/#{@language.downcase}/directs/#{@country_code.downcase}_#{@section[3..5]}_schedule_routes_v2"
						# partial = "new_designs/schedules/#{@country_code.downcase}/directs/#{@country_code.downcase}_#{@language.downcase}_#{@section[3..5]}_schedule_routes_template"
						# layout = true
					end
					@route_details =  { :dep_city_code => @route.dep_city_code,
						:arr_city_code => @route.arr_city_code,
						:dep_airport_code => @route.dep_airport_code,
						:arr_airport_code => @route.arr_airport_code,
						:dep_country_code => @route.dep_country_code,
						:arr_country_code => @route.arr_country_code,
						:dep_city_name => @dep_city_name,
						:arr_city_name => @arr_city_name,
						:country_code => @country_code,
						:section => @section,
						:language => @language,
						:route => @route,
						:route_type => @route_type,
						:country_name => @country_name,
						:page_type => @page_type,
						:page_subtype => @meta_page_type,
						:dep_city_name_ar => @arr_city_name_ar,
						:arr_city_name_ar => @arr_city_name_ar }

						
						flight_schedule_service = FlightScheduleService.new @route_details
						schedule_footer = flight_schedule_service.schedule_footer
						@domestic_carrier_codes = AirlineBrand.where(country_code: @country_code,publish_status: 'active').where.not(carrier_code: '9W').pluck("distinct(carrier_code)")
						@all_carrier_codes = AirlineBrand.where.not(carrier_code: '9W').pluck(:carrier_code)
						if @section.include?("dom") && ["IN","SA"].include?(@country_code)
							inc_cc = "carrier_code in ('#{@domestic_carrier_codes.join("\',\'")}')"
						else
							inc_cc =  "carrier_code in ('#{@all_carrier_codes.join("\',\'")}')"
						end
						case @country_code
						when  "IN"
							@schedule_routes = @route.in_flight_schedule_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
						when  "AE"
							@schedule_routes = @route.ae_flight_schedule_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
						when  "SA"
							@schedule_routes = @route.sa_flight_schedule_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
						when  "BH"
							@schedule_routes = @route.bh_flight_schedule_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
						when  "QA"
							@schedule_routes = @route.qa_flight_schedule_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
						when  "KW"
							@schedule_routes = @route.kw_flight_schedule_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
						when  "OM"
							@schedule_routes = @route.om_flight_schedule_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
						else
							@schedule_routes = @route.in_flight_schedule_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
						end
						if @schedule_routes.empty?
							next
							# redirect_to "#{@host_name}/flight-schedule/flight-schedules-domestic.html",:status=>301 and return
						end

						header_values = flight_schedule_service.schedule_header_details
						schedule_layout_values = flight_schedule_service.schedule_values(@schedule_routes)
						routes_rhs_top_airlines =  flight_schedule_service.routes_rhs_top_airlines rescue []
						filter_schedule_values = schedule_layout_values['schedule_routes'].map{|a| a if a[:cc_min_price].to_i >0}
						@dep_city_name_formated = schedule_layout_values["dep_city_name_formated"]
						@arr_city_name_formated = schedule_layout_values["arr_city_name_formated"]
						@title_min_price =  schedule_layout_values["route_min_price_90"]
					# ["IN-dom","SA-dom"].include?(@section) ? schedule_layout_values["route_min_price_30"] : schedule_layout_values["route_min_price_90"]
					arr_city_activities = {}
					@review_content = flight_schedule_service.fetch_route_review_content
					@cms_content = flight_schedule_service.fetch_cms_route_content(@title_min_price,@page_type,"routes",schedule_layout_values)
					@title = @cms_content["title"].html_safe
					@description = @cms_content["description"].html_safe
					@keywords = @cms_content["keywords"]
					@content = @cms_content["content"]
					# if @content.present? && @content.split().length > 50
					# 	@content = @content.split[0..50].join(" ").concat("<div class='content_show_more hide'>").concat(@content.split[51..@content.index(@content.split().last)].join(" ").concat("</div><span id='content_btn'> Read more...</span>"))
					# end_with
					@dep_content = @cms_content["dep_city_content"]
					@arr_content = @cms_content["arr_city_content"]
					@h1_title = @cms_content["h1_title"]
					@faq = @cms_content["faq"]
					@review = @cms_content["reviews"]
					@route_review_content =  schedule_layout_values["route_review_content"] rescue ""
					unless @country_code != "IN"
						arr_city_activities  = ["BLR","BOM"].include?(@route.arr_city_code) ?  flight_schedule_service.rhs_local_activities : {}
					end
				end

				json_route = JSON((@route.to_json))
				data_hash = {
					"route": json_route,
					"title_min_price": @title_min_price,
					"country_name": @country_name,
					"host_name": @host_name,
					"language": @language,
					"file_name": @file_name,
					"page_type": @page_type,
					"meta_page_type": @meta_page_type,
					"route_details": @route_details,
					"volume_count": @volume_count,
					"is_route": @is_route,
					"route_type": @route_type,
					"review_content": @review_content,
					"cms_content": @cms_content,
					"title": @title,
					"description": @description,
					"keywords": @keywords,
					"content": @content,
					"dep_content": @dep_content,
					"arr_content": @arr_content,
					"h1_title": @h1_title,
					"faq": @faq,
					"review": @review,
					"route_review_content": @route_review_content,
					"schedule_layout_values": schedule_layout_values,
					"dep_city_name": @dep_city_name,
					"arr_city_name": @arr_city_name,
					"dep_city_name_ar": @dep_city_name_ar,
					"arr_city_name_ar": @arr_city_name_ar,
					"dep_city_code": @route.dep_city_code,
					"arr_city_code": @route.arr_city_code,
					"schedule_header": header_values,
					"schedule_footer": schedule_footer,
					"country_code": @country_code,
					"flight_file_name": flight_file_name,
					"filter_schedule_values": filter_schedule_values,
					"host": @host,
					"header_values": header_values,
					"section": @section,
					"has_calendar": @has_calendar,
					"arr_city_activities": arr_city_activities,
					"routes_rhs_top_airlines": routes_rhs_top_airlines,					
					"dep_city_name_formated": @dep_city_name_formated,
					"arr_city_name_formated": @arr_city_name_formated,
				}
				
				# RouteDetail.create(route: full_path,template: data_hash.to_json,domain:"IN",dep_city: @dep_city_name,arr_city: @arr_city_name,lang: "en")
				# route_detail << {"route": full_path,"template": data_hash.to_json,"domain": "IN","dep_city": @dep_city_name,"arr_city": @arr_city_name,"lang": "en"}
				route_detail << {"template": data_hash.to_json,popular_route_id: uniq_route.id}

				p path
				rescue =>  e
					p path+"error"
					p e
				end
			end
			# File.open("test.txt","w+"){ |f|
			# 	f.write(data_hash.to_json)
			# }
			ActiveRecord::Base.connection.execute("TRUNCATE route_details")
			RouteDetail.create(route_detail)
		end

		task page_upload: :environment do
			hash_data = []
			xlsx = Roo::Excelx.new("List_SRP_Change.xlsx")
			xlsx.each_row_streaming do |row|
				count = 0
				begin
					url = row.map { |cell| cell.value }[0]
					if url.include?("flight-schedule")
						url_format = url.gsub("https://www.cleartrip.com/flight-schedule/","").gsub("-flights.html","")
						uniq_route = UniqueRoute.find_by(schedule_route_url: url_format)
						if uniq_route.present?
							section = (uniq_route.dep_country_code == uniq_route.arr_country_code) ? "dom" : "int"
							hash_data << {dep_city_code: uniq_route.dep_city_code,arr_city_code: uniq_route.arr_city_code,dep_city_name: uniq_route.dep_city_name,arr_city_name: uniq_route.arr_city_name,domain: "IN",url_format: uniq_route.schedule_route_url,section: section,route_type:"direct"}
						else
							uniq_route = UniqueHopRoute.find_by(schedule_route_url: url_format)
							section = (uniq_route.dep_country_code == uniq_route.arr_country_code) ? "dom" : "int"
							hash_data << {dep_city_code: uniq_route.dep_city_code,arr_city_code: uniq_route.arr_city_code,dep_city_name: uniq_route.dep_city_name,arr_city_name: uniq_route.arr_city_name,domain: "IN",url_format: uniq_route.schedule_route_url,section: section,route_type:"1-hop"}
						end
					end
				rescue	=> e
					 count += 1
					 p url
				end
			end
		end
		def get_hop_schedule(path,url,uniq_route)
					# @route = UniqueHopRoute.find_by(url: "coimbatore-hubli")
					dep_city = CityName.find_by(city_code: @route.dep_city_code)
					arr_city = CityName.find_by(city_code: @route.arr_city_code)
					lang= @language=="ar" ? "/ar" : ""
					begin
						@dep_city_name  = dep_city.city_name_en.titleize
						@arr_city_name = arr_city.city_name_en.titleize
						if @language == "ar"
							if  dep_city.city_name_ar.present? && arr_city.city_name_ar.present?
								@dep_city_name_ar  = dep_city.city_name_ar
								@arr_city_name_ar = arr_city.city_name_ar
							else
								redirect_to "#{@host_name}#{lang}/flight-schedule/flight-schedules-domestic.html",:status=>301 and return
							end
						end
					rescue
						redirect_to "#{@host_name}#{lang}/flight-schedule/flight-schedules-domestic.html",:status=>301 and return
					end
					model_name = "#{@country_code.titleize}VolumeRoute".constantize
					@volume_count = model_name.where(dep_city_code: @route.dep_city_code,arr_city_code: @route.arr_city_code).first.volume_count rescue 0
					if @route.dep_country_code == @country_code &&  @route.arr_country_code == @country_code
						@section = @country_code + "-dom"
					else
						@section = @country_code + "-int"
					end
					if path.include?("/amp/")
						redirect_to "#{@host_name}#{path.gsub("/amp","")}",:status=> 301 and return
					 #elsif (@country_code == "AE") 

						#partial = "version_2_designs/schedules/#{@language.downcase}/hops/#{@country_code.downcase}_#{@section[3..5]}_schedule_hop_routes_v2"
					# 	# partial = "new_designs/schedules/#{@country_code.downcase}/directs/#{@country_code.downcase}_#{@language.downcase}_#{@section[3..5]}_schedule_routes_template"
						#layout = true
					else
						partial = "version_2_designs/schedules/#{@language.downcase}/hops/#{@country_code.downcase}_#{@section[3..5]}_schedule_hop_routes_v2"
						# partial = "new_designs/schedules/#{@country_code.downcase}/hops/#{@country_code.downcase}_#{@language.downcase}_#{@section[3..5]}_schedule_hop_routes_template"
						layout = true
					end
					# if path.include?("/amp/")
					# 		redirect_to "#{@host_name}#{path.gsub("/amp","")}",:status=>301 and return
					# else
					# 	partial = "new_designs/schedules/#{@country_code.downcase}/hops/#{@country_code.downcase}_#{@language.downcase}_#{@section[3..5]}_schedule_hop_routes_template"
					# 	layout = true
					# end
					@route_type = "1-Hop"
					@route_details = {  :dep_city_code => @route.dep_city_code,
						:arr_city_code => @route.arr_city_code,
						:dep_airport_code => @route.dep_airport_code,
						:arr_airport_code => @route.arr_airport_code,
						:dep_country_code => @route.dep_country_code,
						:arr_country_code => @route.arr_country_code,
						:dep_city_name => @dep_city_name,
						:arr_city_name => @arr_city_name,
						:country_code => @country_code,
						:section => @section,
						:language => @language,
						:route => @route,
						:route_type => @route_type,
						:country_name => @country_name,
						:page_type => @page_type,
						:page_subtype => @meta_page_type,
						:dep_city_name_ar => @arr_city_name_ar,
						:arr_city_name_ar => @arr_city_name_ar  }
						flight_file_name = path
						flight_schedule_service = FlightScheduleService.new @route_details

						schedule_footer = flight_schedule_service.schedule_footer
						@domestic_carrier_codes = AirlineBrand.where(country_code: @country_code).pluck("distinct(carrier_code)")
						@all_carrier_codes = AirlineBrand.all.pluck(:carrier_code)

						unless (@section.include? "int")
							inc_cc = "carrier_code in ('#{@domestic_carrier_codes.join("\',\'")}')"
						else
							inc_cc =  "carrier_code in ('#{@all_carrier_codes.join("\',\'")}')"
						end
			    	# comented because only in_flight_hop_schedule_collectives table has data
			    	# uncomment after feeding data to respective tables
				    case @country_code
				    when  "IN"
				    	@schedule_routes = @route.in_flight_hop_schedule_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
				    when  "AE"
				    	@schedule_routes = @route.ae_flight_hop_schedule_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
				    when  "SA"
				    	@schedule_routes = @route.sa_flight_hop_schedule_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
				    when  "BH"
				    	@schedule_routes = @route.bh_flight_hop_schedule_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
				    when  "QA"
				    	@schedule_routes = @route.qa_flight_hop_schedule_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
				    when  "KW"
				    	@schedule_routes = @route.kw_flight_hop_schedule_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
				    when  "OM"
				    	@schedule_routes = @route.om_flight_hop_schedule_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
				    else
				    	@schedule_routes = @route.ae_flight_hop_schedule_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
				    end
				    if @schedule_routes.empty?
				    	redirect_to "#{@host_name}/flight-schedule/flight-schedules-domestic.html",:status=>301 and return
				    end
				    schedule_layout_values = flight_schedule_service.schedule_hop_values(@schedule_routes)
				    routes_rhs_top_airlines =  flight_schedule_service.routes_rhs_top_airlines rescue []
				    filter_schedule_values = schedule_layout_values['schedule_routes'].map{|a| a if a[:cc_min_price].to_i >0}
					@title_min_price = 0 #schedule_layout_values["route_min_price"]
					@cms_content = flight_schedule_service.fetch_cms_route_content(@title_min_price,@page_type,"routes",schedule_layout_values)
					@title = @cms_content["title"]
					@description = @cms_content["description"]
					@keywords = @cms_content["keywords"]
					@content = @cms_content["content"]
					@dep_content = @cms_content["dep_city_content"]
					@arr_content = @cms_content["arr_city_content"]
					@h1_title = @cms_content["h1_title"]
					@faq = @cms_content["faq"]
					@review = @cms_content["reviews"]
					@route_review_content =  schedule_layout_values["route_review_content"] rescue ""
					@dep_city_name_formated = schedule_layout_values["dep_city_name_formated"]
					@arr_city_name_formated = schedule_layout_values["arr_city_name_formated"]
					header_values = flight_schedule_service.schedule_header_details
					@is_route = ((url == "new-delhi-mumbai" || url == "new-delhi-bangkok" )&& @country_code == "IN") ? true : false
					@review_content = flight_schedule_service.fetch_route_review_content
					json_route = JSON((@route.to_json))
					data_hash = {
						"route": json_route,
						"title_min_price": @title_min_price,
						"country_name": @country_name,
						"host_name": @host_name,
						"language": @language,
						"file_name": @file_name,
						"page_type": @page_type,
						"meta_page_type": @meta_page_type,
						"route_details": @route_details,
						"volume_count": @volume_count,
						"is_route": @is_route,
						"route_type": @route_type,
						"review_content": @review_content,
						"cms_content": @cms_content,
						"title": @title,
						"description": @description,
						"keywords": @keywords,
						"content": @content,
						"dep_content": @dep_content,
						"arr_content": @arr_content,
						"h1_title": @h1_title,
						"faq": @faq,
						"review": @review,
						"route_review_content": @route_review_content,
						"schedule_layout_values": schedule_layout_values,
						"dep_city_name": @dep_city_name,
						"arr_city_name": @arr_city_name,
						"dep_city_name_ar": @dep_city_name_ar,
						"arr_city_name_ar": @arr_city_name_ar,
						"dep_city_code": @route.dep_city_code,
						"arr_city_code": @route.arr_city_code,
						"schedule_header": header_values,
						"schedule_footer": schedule_footer,
						"country_code": @country_code,
						"flight_file_name": flight_file_name,
						"filter_schedule_values": filter_schedule_values,
						"host": @host,
						"header_values": header_values,
						"section": @section,
						"has_calendar": @has_calendar,
						# "arr_city_activities": arr_city_activities,
						"routes_rhs_top_airlines": routes_rhs_top_airlines,					
						"dep_city_name_formated": @dep_city_name_formated,
						"arr_city_name_formated": @arr_city_name_formated,
					}
					db_data = {"template": data_hash.to_json,popular_route_id: uniq_route.id}

		end
	end








