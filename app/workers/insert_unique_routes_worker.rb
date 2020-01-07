require 'sidekiq'
require 'sidekiq_status'
require "active_record/relation"
# require "#{APP_ROOT}/lib/support/constants.rb"

class InsertUniqueRoutesWorker
  # include SidekiqStatus::Worker
  #include Utilities
  # sidekiq_options queue: "insert_unique_routes_worker", backtrace: true
  def perform()
    country_code = 'IN'
    all_routes = PackageFlightSchedule.where("arr_city_code!=dep_city_code and ((dep_country_code='IN' and arr_country_code='IN') or (((dep_country_code='IN' and arr_country_code!='IN')or (dep_country_code!='IN' and arr_country_code='IN'))or(dep_country_code!='IN' and arr_country_code!='IN'))) and (stop=0)").group(:dep_city_code,:arr_city_code,:dep_airport_code,:arr_airport_code,:dep_country_code,:arr_country_code).order("sum(flight_count) desc").pluck(:dep_city_code,:arr_city_code,:dep_airport_code,:arr_airport_code,:dep_country_code,:arr_country_code,"sum(flight_count) as total",:stop)
      # top_routes_international =  PackageFlightSchedule.where("arr_city_code != dep_city_code and ((dep_country_code = '#{country_code}') AND NOT (arr_country_code = '#{country_code}')) OR (NOT (dep_country_code = '#{country_code}') AND ((arr_country_code = '#{country_code}'))) or (dep_country_code != '#{country_code}' and arr_country_code != '#{country_code}') and stop=0").group(:dep_city_code, :arr_city_code, :dep_airport_code,:arr_airport_code, :dep_city_name, :arr_city_name, :dep_country_code, :arr_country_code).order("sum(flight_count) desc").pluck(:dep_city_code, :arr_city_code, :dep_airport_code,:arr_airport_code, :dep_city_name, :arr_city_name, :dep_country_code, :arr_country_code, "sum(flight_count) as total")
      create_flight_routes(all_routes)
  end

  def create_flight_routes(all_routes)
    count = 0
    all_routes.each do |schedule_route|
      records  = PackageFlightSchedule.where("dep_city_code='#{schedule_route[0]}' and arr_city_code='#{schedule_route[1]}' and distance IS NOT NULL").limit(5)
       distance = records.map{|r| r.distance}.compact.first rescue nil
        begin
            if !schedule_route[3].blank? && !schedule_route[4].blank? && schedule_route[0] != schedule_route[1]
                flight_route = UniqueRoute.create!(
                  dep_city_code:       schedule_route[0],
                  arr_city_code:       schedule_route[1],
                  dep_airport_code:    schedule_route[2],
                  arr_airport_code:    schedule_route[3],
                  dep_country_code:    schedule_route[4],
                  arr_country_code:    schedule_route[5],
                  weekly_flights_count: schedule_route[6],
                  hop:                 schedule_route[7],
                  distance:         distance
                )
                puts "#{count += 1}-inserted for #{schedule_route[0]}-#{schedule_route[1]}"
            end
        rescue ActiveRecord::RecordInvalid => exception
        end
    end
  end
end
