namespace :update do 
	task footer_airline: :environment do 
			file = File.open("#{Rails.root}/public/updated_airlines_list.csv")
			csv = CSV.parse(file,headers:true)
			english_data =[]
			arabic_data =[]
			csv.each do |row|
				airline = AirlineBrand.where(carrier_code:row[0]).first
				if airline.present?
					english_data.push({carrier_code:row[0],carrier_name_en:row[1],country_code: airline.country_code,icoa_code: airline.icoa_code})
					arabic_data.push({carrier_code:row[0],carrier_name_ar:row[3],country_code: airline.country_code,icoa_code: airline.icoa_code})
				end
			end
		InAirlineFooter.create(airline_footer_en: english_data.to_s,airline_footer_ar: arabic_data.to_s,airline_footer_en_dup:english_data.to_s,airline_footer_ar_dup:arabic_data.to_s,current_count: 0)
	end
end