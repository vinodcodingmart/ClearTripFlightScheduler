class FlightsHeaderMonitorWorker
	# include SidekiqStatus::Worker
 	# include Utilities
  # sidekiq_options queue: "flight_schedule_generator_worker", backtrace: true
  def perform()
    country_code = ENV['COUNTRY']

    sections = ["#{country_code}-dom","#{country_code}-int"]


      # routes = UniqueRoute.where("dep_city_code!=' ' and arr_city_code!=' ' and page_type = 'flight_schedule' and section = ? and route_type='direct'",section).order("flight_count desc")

      routes = UniqueRoute.where("dep_city_code='BLR' and arr_city_code='DEL'")

      # routes = FlightRoute.where(section: section, page_type: 'flight_schedule').order('flight_count DESC').limit(10)
    begin
      routes.each do |route|
        puts "===================="
        puts "Adding route :#{route.id} to the queue"
        # puts "===================="
      FlightsHeaderGeneratorWorker.new.perform(route.id)
    	end
  	rescue StandardError => e
    puts e.message
    e.backtrace
  	end
	end
end
