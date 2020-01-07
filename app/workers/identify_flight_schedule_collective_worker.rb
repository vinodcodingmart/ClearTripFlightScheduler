require 'sidekiq'
require 'sidekiq_status'
require "active_record/relation"

class IdentifyFlightScheduleCollectiveWorker
  # include SidekiqStatus::Worker
  # sidekiq_options queue: "identify_flight_schedule_collective_worker", backtrace: true
	def perform()
	  # unique_routes = UniqueRoute.where(dep_city_code: 'DXB',arr_city_code: 'BLR')
    unique_routes = UniqueRoute.where(id: 58394)
    puts "Started inseting data for unique routes"
    unique_routes.find_each do |route|
	  	dep_city_code = route.dep_city_code
	  	arr_city_code = route.arr_city_code
    	result = PackageFlightSchedule.where("dep_city_code='#{dep_city_code}' and arr_city_code='#{arr_city_code}'").group(:carrier_code).order(data_source: :desc,dep_time: :asc)
      routes = []
    	days_of_operation = %W(S M T W T F S)
	    result.each do |r|
	      op_days = r.day_of_operation.gsub(/\s/,'').split("").collect{|i| days_of_operation[(i.to_i-1)]}.join(" ")  rescue r.day_of_operation
	      routes << {
	        :carrier_code=>r.carrier_code,
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
	        :unique_route_id => route.id
	      }
	    end
    	routes = routes.group_by{|c| c[:flight_no]}.map{|k,v| v.max{|d| d[:flight_count]}}
    	create_schedule_collective(routes,dep_city_code,arr_city_code)
  	end
    puts "end of inserting data"
  end
  def create_schedule_collective(routes,dep_city_code,arr_city_code)
  	count = 0
    routes.each do |route|
  		route_value = OmFlightScheduleCollective.find_or_create_by(dep_city_code:dep_city_code,arr_city_code: arr_city_code,flight_no: route[:flight_no])
  		route_value.carrier_code = route[:carrier_code]
  		route_value.flight_no = route[:flight_no]
  		route_value.dep_time = route[:dep_time]
  		route_value.arr_time = route[:arr_time]
  		route_value.duration = route[:duration]
  		route_value.days_of_operation = route[:op_days]
  		route_value.dep_city_code = dep_city_code
  		route_value.arr_city_code = arr_city_code
  		route_value.dep_country_code = route[:dep_country_code]
  		route_value.arr_country_code = route[:arr_country_code]
  		route_value.unique_route_id = route[:unique_route_id]
  	  route_value.save!
      puts "#{count +=1} inserted  #{route[:carrier_code]}-#{route[:flight_no]}"
  	end
  end
end

# :dep_time=>Time.strptime(r.dep_time,"%H:%M").to_time.strftime("%l:%M %p"),
          # :arr_time=>Time.strptime(r.arr_time,"%H:%M").to_time.strftime("%l:%M %p")
