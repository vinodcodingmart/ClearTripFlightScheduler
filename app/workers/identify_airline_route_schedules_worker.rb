require 'sidekiq'
require 'sidekiq_status'
require "active_record/relation"
class IdentifyAirlineRouteSchedulesWorker
  include SidekiqStatus::Worker
  sidekiq_options queue: "identify_airline_route_schedules_worker", backtrace: true
  def perform
    airline_routes = AirlineUniqueRoute.last(5651)
    route_count = 0
    airline_routes.each do |route|
      route_records = PackageFlightSchedule.where(dep_city_code: route.dep_city_code,arr_city_code: route.arr_city_code,carrier_code: route.carrier_code,dep_country_code: route.dep_country_code,arr_country_code: route.arr_country_code).group(:flight_no,:carrier_code).order(data_source: :desc,dep_time: :asc)
      routes = []
    	days_of_operation = %W(S M T W T F S)
      route_records.each do |r|
	      op_days = r.day_of_operation.gsub(/\s/,'').split("").collect{|i| days_of_operation[(i.to_i-1)]}.join(" ")  rescue r.day_of_operation
	      routes << {
	        :carrier_code=>route.carrier_code,
          :dep_city_code => route.dep_city_code,
          :arr_city_code => route.arr_city_code,
	        :dep_time=>r.dep_time,
	        :arr_time=>r.arr_time,
	        :dep_country_code =>r.dep_country_code,
	        :arr_country_code =>r.arr_country_code,
	        :dep_airport_code =>r.dep_airport_code,
	        :arr_airport_code =>r.arr_airport_code,
	        :duration=>r.elapsed_journey_time,
	        :flight_no=>r.flight_no.to_i,
	        :flight_count=>r.flight_count,
	        :op_days => op_days,
	        :airline_unique_route_id => route.id,
          :route_url => route.url_format
	      }
	    end
      puts "#{route_count+=1}-route data inserted for #{route.url_format}"
      create_airline_route_schedules(routes)
    end
  end

  def create_airline_route_schedules(routes)
    url_format  = routes.first[:route_url]
    routes.each do |route|
      route_value = AeAirlineRouteSchedule.find_or_initialize_by(carrier_code: route[:carrier_code],dep_city_code: route[:dep_city_code],arr_city_code: route[:arr_city_code],flight_no: route[:flight_no],airline_unique_route_id: route[:airline_unique_route_id])
      route_value.dep_time = route[:dep_time]
  		route_value.arr_time = route[:arr_time]
  		route_value.duration = route[:duration]
  		route_value.days_of_operation = route[:op_days]
  		route_value.dep_city_code = route[:dep_city_code]
  		route_value.arr_city_code = route[:arr_city_code]
  		route_value.dep_country_code = route[:dep_country_code]
  		route_value.arr_country_code = route[:arr_country_code]
      route_value.save!
    end
    AirlineUniqueRoute.find_by(url_format: url_format).update(status: "inserted")
  end
end

# rails g model OmAirlineRouteSchedule carrier_code flight_no:integer dep_time arr_time duration days_of_operation dep_city_code arr_city_code dep_country_code arr_country_code airline_unique_route:references
#
#
# t.string "carrier_code"
# t.integer "flight_no"
# t.string "dep_time"
# t.string "arr_time"
# t.string "duration"
# t.string "days_of_operation"
# t.string "dep_city_code"
# t.string "arr_city_code"
# t.string "dep_country_code"
# t.string "arr_country_code"
# t.bigint "unique_route_id"
