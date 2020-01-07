namespace :store_hotel_api do
	desc "store hoatels data"
	task store_data: :environment do
		airports = Airport.all
		airports.each do |airport|
			if airport.country_name.present? && airport.city_name.present?
				if airport.city_name == "Cochin"
					url = "http://54.169.90.61/hotels/api/"+airport.country_name.gsub(' ','-').downcase+"/"+"Kochi".gsub(' ','-').downcase+".json"
				else
					url = "http://54.169.90.61/hotels/api/"+airport.country_name.gsub(' ','-').downcase+"/"+airport.city_name.gsub(' ','-').downcase+".json"
				end
				p url
				begin
					res = HTTParty.get(url)
					if res.code == 200
						resp_body = JSON.parse(res.body)
						current_iteration_count = 0
						total_iteration_count = resp_body["localities"].count/5
						local_act = res["collections_data"]
						local_act_count= res["collections_data"].count
						@hotel = OmHotelApi.where(city_name: airport.city_name,country_code: airport.country_code,country_name: airport.country_name)
						if @hotel.present?
							@hotel.update_all(star_data:resp_body["stars"].to_s,hotel_data:resp_body["hotels"].to_s,local_cities_data:resp_body["localities"].to_s,properties:resp_body["properties"].to_s,current_iteration_count:current_iteration_count,total_iteration_count:total_iteration_count,featured_hotels:resp_body["promotion_hotels"].to_s,chain_hotels:resp_body["chain"].to_s,local_activities_total:local_act_count,local_activities_current:0,local_activities:local_act.to_s)
							puts " updated for city #{airport.city_name}"
						else
							OmHotelApi.create(city_name: airport.city_name,country_code: airport.country_code,country_name: airport.country_name,star_data:resp_body["stars"].to_s,hotel_data:resp_body["hotels"].to_s,local_cities_data:resp_body["localities"].to_s,properties:resp_body["properties"].to_s,local_activities:local_act.to_s,current_iteration_count:current_iteration_count,total_iteration_count:total_iteration_count,local_activities_total:local_act_count,local_activities_current:0,featured_hotels:resp_body["promotion_hotels"].to_s,chain_hotels:resp_body["chain"].to_s)
							puts " created for city #{airport.city_name}"
							sleep(0.5)
						end
					end
				rescue StandardError => e
					e.message
					e.backtrace
				end
			end
		end
	end





	task stote_local_activities: :environment do
		airports = OmHotelApi.all
		airports.each do |airport|
			if airport.country_name.present? && airport.city_name.present?
				if airport.city_name == "Cochin"
					url = "http://54.169.90.61/hotels/api/"+airport.country_name.gsub(' ','-').downcase+"/"+"Kochi".gsub(' ','-').downcase+".json"
				else
					url = "http://54.169.90.61/hotels/api/"+airport.country_name.gsub(' ','-').downcase+"/"+airport.city_name.gsub(' ','-').downcase+".json"
				end
				# p url
				res = HTTParty.get(url)
				if res.code == 200
					res=  JSON.parse(res.body)
					local_act = res["collections_data"]
					local_act_count= res["collections_data"].count
					airport.update(local_activities_total:local_act_count,local_activities_current:0,local_activities:local_act.to_s)
					sleep(0.5)
					p "#{airport.city_name}"
				end
			end
		end
	end


end
