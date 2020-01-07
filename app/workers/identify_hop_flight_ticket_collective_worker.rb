require 'sidekiq'
require 'sidekiq_status'
require "active_record/relation"

class IdentifyHopFlightTicketCollectiveWorker
	# include SidekiqStatus::Worker
  # sidekiq_options queue: "identify_flight_hop_ticket_collective_worker", backtrace: true
	def perform()
	  unique_hop_routes = UniqueHopRoute.all
    puts "Started inseting data for unique routes"
    unique_hop_routes.find_each do |route|
	  	dep_city_code = route.dep_city_code
	  	arr_city_code = route.arr_city_code
    	result = PackageFlightHopSchedule.where("dep_city_code='#{dep_city_code}' and arr_city_code='#{arr_city_code}'").group(:l1_carrier_code,:l2_carrier_code,:l1_arr_city_code,:l1_arr_airport_code).order(dep_time: :asc) 
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
	        :mid_airport_code => r.l1_arr_airport_code,
	        :mid_city_code => r.l1_arr_city_code,
	        :mid_country_code => r.l1_arr_country_code,
	        :duration=>r.elapsed_journey_time,
	        :first_flight_no=>r.l1_flight_no.to_i,
	        :second_flight_no => r.l2_flight_no.to_i,
	        :first_carrier_code => r.l1_carrier_code,
	        :second_carrier_code => r.l2_carrier_code,
	        :op_days => op_days,
	        :weekly_flights_count => r.flight_count,
	        :unique_hop_route_id => route.id
	      }
	    end
    	routes = routes.group_by{|c| c[:first_flight_no]}.map{|k,v| v.max{|d| d[:weekly_flights_count]}}
    	# create_ticket_collective(routes,dep_city_code,arr_city_code)
  	end
    puts "end of inserting data"
  end
  def create_ticket_collective(routes,dep_city_code,arr_city_code)
  	count = 0
    routes.each do |route|
  		route_value = AeFlightHopTicketCollective.find_or_create_by(dep_city_code:dep_city_code,arr_city_code: arr_city_code,first_flight_no: route[:flight_no])
  		route_value.carrier_code = route[:carrier_code]
  		route_value.dep_time = route[:dep_time]
  		route_value.arr_time = route[:arr_time]
  		route_value.duration = route[:duration]
  		route_value.days_of_operation = route[:op_days]
  		route_value.dep_city_code = dep_city_code
  		route_value.arr_city_code = arr_city_code
  		route_value.dep_airport_code = route[:dep_airport_code]
  		route_value.arr_airport_code = route[:arr_airport_code]
  		route_value.dep_country_code = route[:dep_country_code]
  		route_value.arr_country_code = route[:arr_country_code]
  		route_value.first_flight_no = route[:first_flight_no]
  		route_value.second_flight_no = route[:second_flight_no]
  		route_value.mid_airport_code = route[:mid_airport_code]
  		route_value.mid_city_code = route[:mid_city_code]
  		route_value.mid_country_code = route[:mid_country_code]
  		route_value.first_carrier_code = route[:first_carrier_code]
  		route_value.second_carrier_code = route[:second_carrier_code]
  		route_value.unique_hop_route_id = route[:unique_hop_route_id]
  	  route_value.save!
      puts "#{count +=1} inserted #{route[:carrier_code]}-#{route[:first_flight_no]}"
  	end
  end
end