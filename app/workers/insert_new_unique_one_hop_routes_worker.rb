require 'sidekiq'
require 'sidekiq_status'
require "active_record/relation"
# require "#{APP_ROOT}/lib/support/constants.rb"

class InsertUniqueOneHopRoutesWorker
  # include SidekiqStatus::Worker
  #include Utilities
  # sidekiq_options queue: "insert_new_unique_routes_worker", backtrace: true
  def perform()
    country_code = 'IN'
    all_routes = NewPackageFlightHopSchedule.where("arr_city_code!=dep_city_code and l1_arr_city_code!=dep_city_code and ((dep_country_code='IN' and arr_country_code='IN') or (((dep_country_code='IN' and arr_country_code!='IN')or (dep_country_code!='IN' and arr_country_code='IN'))or(dep_country_code!='IN' and arr_country_code!='IN')))").group(:dep_city_code,:arr_city_code,:dep_airport_code,:arr_airport_code,:dep_country_code,:arr_country_code).order("sum(flight_count) desc ").pluck(:dep_city_code,:arr_city_code,:dep_airport_code,:arr_airport_code,:dep_country_code,:arr_country_code,:distance,"sum(flight_count) as total",:dep_city_name,:arr_city_name)

      create_flight_routes(all_routes)
  end

  def create_flight_routes(all_routes)
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
    count = 0
    all_routes.each do |schedule_route|
      weekly_flights_count  = NewPackageFlightHopSchedule.where("dep_city_code='#{schedule_route[0]}' and arr_city_code='#{schedule_route[1]}'").count

      route_url_format = url_escape("#{schedule_route[8]}-#{schedule_route[9]}")

        old_hop_route = UniqueHopRoute.find_by(dep_city_code: schedule_route[0],arr_city_code: schedule_route[1],dep_airpot_code: schedule_route[2],arr_airport_code: schedule_route[3])
        if old_hop_route.present? && !old_hop_route.nil?
          old_hop_route.dep_city_code = schedule_route[0]
          old_hop_route.arr_city_code = schedule_route[1]
          old_hop_route.dep_airport_code = schedule_route[2]
          old_hop_route.arr_airport_code = schedule_route[3]
          old_hop_route.dep_country_code =       schedule_route[4]
          old_hop_route.arr_country_code =       schedule_route[5]
          old_hop_route.distance =               schedule_route[6]
          old_hop_route.total_flights_count =    schedule_route[7]
          old_hop_route.dep_city_name =          schedule_route[8]
          old_hop_route.arr_city_name =          schedule_route[9]
          old_hop_route.weekly_flights_count = weekly_flights_count
          old_hop_route.save!

        else

          begin
              if !schedule_route[3].blank? && !schedule_route[4].blank? && schedule_route[0] != schedule_route[1]
                flight_route = UniqueHopRoute.create(
                  dep_city_code:       schedule_route[0],
                  arr_city_code:       schedule_route[1],
                  dep_airport_code:    schedule_route[2],
                  arr_airport_code:    schedule_route[3],
                  dep_country_code:       schedule_route[4],
                  arr_country_code:       schedule_route[5],
                  distance:               schedule_route[6],
                  total_flights_count:    schedule_route[7],
                  dep_city_name:          schedule_route[8],
                  arr_city_name:          schedule_route[9],
                  weekly_flights_count: weekly_flights_count,
                  hop:             1,
                  url: route_url_format
                )
                puts "#{count += 1}-inserted for #{schedule_route[0]}-#{schedule_route[1]}"
              end
          rescue StandardError => e
            e.backtrace
            e.message
          end
        end
    end
  end
end
