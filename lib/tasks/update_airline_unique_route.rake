namespace :update do 
	task :airline_unique_route => :environment do 
	def url_escape(url_string)
    unless url_string.blank?
      result = url_string.encode("UTF-8", :invalid => :replace, :undef => :replace).to_s
      result = result.gsub(/[\/]/,'-')
      result = result.gsub(/[^\x00-\x7F]+/, '') # Remove anything non-ASCII entirely (e.g. diacritics).
      result = result.gsub(/[^\w_ \-]+/i,   '') # Remove unwanted chars.
      result = result.gsub(/[ \-]+/i,      '-') # No more than one of the separator in a row.
      result = result.gsub(/^\-|\-$/i,      '') # Remove leading/trailing separator.
      result = result.downcase
    end
  end
		ai_routes = AirlineUniqueRoute.where(carrier_code: 'AI')

		ai_routes.each_with_index do |r,i|
			dep_city_name = r.dep_city_name 
			arr_city_name = r.arr_city_name
			carrier_name = r.carrier_name 
			url_format = url_escape("#{carrier_name.gsub(' ','-').downcase}-#{dep_city_name.gsub(' ','-').downcase}-#{arr_city_name.gsub(' ','-').downcase}-flights")
			r.url_format = url_format
			r.save
			puts "#{i} updated"
		end
	end
end