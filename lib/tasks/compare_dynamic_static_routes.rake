namespace :fetch do
  desc "compare dynamic routes with generation schedule routes"
  task :missing_routes_in_uniq_routes => :environment do
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
    generation_routes = FlightRoute.where(page_type: 'flight_schedule',section: ['IN-dom','IN-int'],route_type: 'direct')
    begin
      created_count = 0
      existing_count = 0
      generation_routes.each do |groute|
        begin
          unique_route = UniqueRoute.find_by(dep_city_code: groute.dep_city_code,arr_city_code: groute.arr_city_code)

          if unique_route.nil? || !unique_route.present?

            schedule_route_url = url_escape("#{groute.dep_city_name}-#{groute.arr_city_name}")
            new_unique_route = UniqueRoute.create!(dep_city_code: groute.dep_city_code,arr_city_code: groute.arr_city_code,dep_city_name: groute.dep_city_name,arr_city_name: groute.arr_city_name,dep_airport_code: groute.dep_airport_code,arr_airport_code: groute.arr_airport_code,dep_country_code: groute.dep_country_code,arr_country_code: groute.arr_country_code,schedule_route_url: schedule_route_url,weekly_flights_count: groute.flight_count,source: groute.data_source)
            puts "#{created_count+=1} created route #{groute.dep_city_name}-#{groute.arr_city_name} ==="
          else
            puts "#{existing_count+=1} route exist !!!"
          end
        rescue StandardError => e

          e.message
          e.backtrace
        end
      end
    rescue StandardError => e

      e.message
      e.backtrace
    end

  end
end
