require 'sidekiq'
require 'sidekiq_status'
require "active_record/relation"
require 'sidekiq'
require 'sidekiq_status'
require "active_record/relation"

class IdentifyAirlineRoutesWorker
  # This calss is used to identify how many pages to generate for flight schedule section
  # include SidekiqStatus::Worker
  # include Utilities
  # sidekiq_options queue: "identify_airline_brands_routes_worker", backtrace: true

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

  # def perform(country_code)
  def perform
    country_code = ENV['COUNTRY']
    page_type = 'flight_brand'


    # FlightRoute.delete_all("page_type = '#{page_type}' and ( section = '#{country_code}-dom' or section='#{country_code}-int')")

    # logger.info "[IdentifyFlightRoutesWorker] Collecting the top city combinations form the FLightSchedule table"


    top_routes_international =  PackageFlightSchedule.where("arr_city_code != dep_city_code and arr_city_name is not NULL and dep_city_name is not NULL and dep_city_name != '' and arr_city_name != '' and ((dep_country_code = '#{country_code}') AND NOT (arr_country_code = '#{country_code}')) OR (NOT (dep_country_code = '#{country_code}') AND ((arr_country_code = '#{country_code}'))) or (dep_country_code != '#{country_code}' and arr_country_code != '#{country_code}') and route_status='not_valid'").group(:dep_city_code, :arr_city_code, :dep_city_name, :arr_city_name, :dep_country_code, :arr_country_code, :carrier_brand, :carrier_code).order("sum(flight_count) desc").pluck(:dep_city_code, :arr_city_code,  :dep_city_name, :arr_city_name, :dep_country_code, :arr_country_code, :carrier_brand, :carrier_code, "sum(flight_count) as total")

    # create_brand_flight_routes(top_routes_international, 'international', country_code, page_type)
    top_routes_domestic =  PackageFlightSchedule.where("arr_city_code != dep_city_code and arr_city_name is not NULL and dep_city_name is not NULL and dep_city_name != '' and arr_city_name != '' and ( dep_country_code='#{country_code}' and arr_country_code='#{country_code}') and route_status='not_valid' ").group(:dep_city_code, :arr_city_code, :dep_city_name, :arr_city_name, :dep_country_code, :arr_country_code, :carrier_brand, :carrier_code).order("sum(flight_count) desc").pluck(:dep_city_code, :arr_city_code,  :dep_city_name, :arr_city_name, :dep_country_code, :arr_country_code, :carrier_brand, :carrier_code, "sum(flight_count) as total")
    
    # create_brand_flight_routes(top_routes_domestic, 'domestic', country_code, page_type)

    logger.info "[IdentifyFlightRoutesWorker] End with the task at #{Time.now}"
  end

  def create_brand_flight_routes(top_routes, route_type, country_code, page_type)
    logger.info "[IdentifyFlightScheduleRouteWorker] Iterating through the Flight schedule route city list"

    top_routes.each do |schedule_route|
      begin
        if schedule_route[5]== "#{country_code}" && schedule_route[4] == "#{country_code}"
          section_type = country_code+'-dom'
        else
          section_type = country_code+'-int'
        end

        # if section_type=='IN-dom' && carrier_code=='AI'
        #   schedule_route[6]="Air india"
        # end
        url = "#{url_escape("#{schedule_route[6]}-#{schedule_route[2]}-#{schedule_route[3]}-flights")}.html"
        brand_processor_args = {}
        brand_processor_args['carrier_name'] = schedule_route[6]
        brand_processor_args['carrier_code'] = schedule_route[7]
        brand_processor_args['section'] = section_type

        brand_processor = BrandProcessor.new brand_processor_args

        # routes = brand_processor.flight_schedule(schedule_route[0], schedule_route[1], schedule_route[4], schedule_route[5],section_type)

        unless schedule_route[4] == country_code && schedule_route[5] == country_code && section_type == country_code+'-int'
          if !schedule_route[2].blank? && !schedule_route[3].blank? && schedule_route[0] != schedule_route[1]
            # routes  =  PackageFlightSchedule.find_by_sql(["SELECT * FROM (SELECT flight_no, carrier_code, carrier_brand, carrier_logo, dep_airport_code, dep_city_code, dep_city_name, dep_country_code, arr_airport_code, arr_city_code, arr_city_name, arr_country_code, dep_time, arr_time, brand_type, length(trim(REPLACE(day_of_operation, ' ', ''))) as tot,day_of_operation,effective_from, effective_to FROM package_flight_schedules WHERE dep_city_code = ? and arr_city_code = ? and (package_flight_schedules.arr_city_name != ' ' and package_flight_schedules.dep_city_name != ' ' and package_flight_schedules.is_active='active' and dep_city_code != arr_city_code and carrier_code = ? ) ORDER BY tot DESC ) AS s ORDER BY dep_time", schedule_route[0], schedule_route[1], schedule_route[7]])
            # if !routes.blank?

              flight_route = FlightRoute.create!(
                dep_city_code:       schedule_route[0],
                arr_city_code:       schedule_route[1],
                dep_city_name:       schedule_route[2],
                arr_city_name:       schedule_route[3],
                dep_country_code:    schedule_route[4],
                arr_country_code:    schedule_route[5],
                url:                 url,
                carrier_brand:       schedule_route[6],
                carrier_code:        schedule_route[7],
                flight_count:        schedule_route[8],
                page_status:         'new',
                section:             section_type,
                page_type:           page_type

              )
              logger.info "------------------------------------------------------------------"

              logger.info "
                dep_city_code:       #{schedule_route[0]},
                arr_city_code:       #{schedule_route[1]},
                dep_city_name:       #{schedule_route[2]},
                arr_city_name:       #{schedule_route[3]},
                dep_country_code:    #{schedule_route[4]},
                arr_country_code:    #{schedule_route[5]},
                url:                 #{url},
                carrier_brand:       #{schedule_route[6]},
                carrier_code:        #{schedule_route[7]},
                flight_count:        #{schedule_route[8]},
                page_status:         'new',
                section:             #{section_type},
                page_type            #{page_type}"
              logger.info "[IdentifyFlightScheduleRoutesWorker] Inserted route url"
            # end
          end

        end
      rescue ActiveRecord::RecordInvalid => exception
        logger.info "[IdentifyFlightRoutesWorker] Exception Occured while identifying routes: dep_city_name: #{dep_city.place_name} | arr_city_name: #{arr_city.place_name} | exception"
      end
    end
  end
end
