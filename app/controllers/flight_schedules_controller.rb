class FlightSchedulesController < ApplicationController
  def schedule_values
    @country_code,@country_name = ['IN',"India"]
    route = params[:route].split('-flights')
    @language = params[:lang].nil? ? 'en' : params[:lang]
    @application_processor = ApplicationProcessor.new
    @host_name = @application_processor.host_name(@country_code)
    schedule_layout_values = {}
    schedule_header = {}
    # dep_city,arr_city = route.join.split('-').map{|val| val.capitalize}
    route = UniqueRoute.where(schedule_route_url: params[:route].split('-flights').join).first
    # route.in_flight_schedule_collectives.each{|airline|
    # schedule_layout_values["schedule_routes"] ||= []
    # schedule_layout_values["schedule_routes"] <<{carrier_code: airline.carrier_code,dep_time: airline.dep_time,arr_time: airline.arr_time,format_duration: airline.duration}
    # }
    dep_city_name = route.dep_city_name
    arr_city_name = route.arr_city_name
    dep_city_code = route.dep_city_code
    arr_city_code = route.arr_city_code
    @airlines = AirlineUniqueRoute.where(dep_city_code: dep_city_code,arr_city_code: arr_city_code)
    schedule_layout_values["schedule_routes"],schedule_layout_values["max_duration"] = FlightBookingService.get_schedule_routes(@airlines,@language,@country_code)
    cheap_fare_data,schedule_layout_values["min_price"],schedule_layout_values["max_price"] = FlightBookingService.get_cheap_fare_table_data(dep_city_code,arr_city_code,@country_code)
    schedule_layout_values["top_min_flights_today"] = cheap_fare_data[:min_today]
    schedule_layout_values["top_min_flights_15"] = cheap_fare_data[:min_15_with_dd]
    schedule_layout_values["top_min_flights_30"] = cheap_fare_data[:min_30_with_dd]
    schedule_layout_values["top_min_flights_90"] = cheap_fare_data[:min_90_with_dd]
    schedule_layout_values["country_name"] = @country_name
    airports = Hash[Airport.where(:city_code=>[dep_city_code,arr_city_code]).map{|c| [c.city_code,c]}]
    schedule_layout_values["dep_airport_code"] = airports[dep_city_code].airport_code rescue dep_city_code
    schedule_layout_values["arr_airport_code"] = airports[arr_city_code].airport_code rescue arr_city_code
    schedule_layout_values["dep_airport_name"] = airports[dep_city_code].airport_name rescue ""
    schedule_layout_values["arr_airport_name"] = airports[arr_city_code].airport_name rescue ""
    schedule_layout_values["operational_airlines_count"] = @airlines.size
    schedule_layout_values["weekly_flights_count"] = schedule_layout_values["schedule_routes"].size
    @section = (route.dep_country_code == @country && route.arr_country_code == @country) ? "#{@country_code}-dom" : "#{@country_code}-int"
    @meta_page_type  = "flight-schedule"
    lang = @language == "en" ? "" : "/#{@language}"
    cc =  AirlineUniqueRoute.where(dep_city_code: dep_city_code,arr_city_code: arr_city_code).pluck(:carrier_code).uniq
    top_airline_cc_desc = AirlineBrand.where(carrier_code: cc,publish_status: "active").order(brand_routes_count: :desc).distinct.pluck(:carrier_code,:country_code)
    routes_rhs_top_airlines = {}
    top_airline_cc_desc.each{|cc,country|
     routes_rhs_top_airlines["dom_cc"] ||= []
     routes_rhs_top_airlines["int_cc"] ||= []
     if country == @country_code
      routes_rhs_top_airlines["dom_cc"] << cc
     else
      routes_rhs_top_airlines["int_cc"] << cc
     end
    }
    schedule_layout_values["dep_city_name_formated"] = dep_city_name.gsub(' ','-').downcase
    schedule_layout_values["dep_city_name_formated"] = arr_city_name.gsub(' ','-').downcase
    schedule_layout_values["country_code"] = @country_code
    schedule_layout_values["dep_city_code"] = dep_city_code
    schedule_layout_values["arr_city_code"] = arr_city_code
    flight_file_name = params[:route] + ".html"
    header_details_obj = Header.where(dep_city_code: "BLR",arr_city_code: "MAA").first
    header_details = eval(header_details_obj.hotel_details)
    schedule_header["near_by_airport_hotels"]  = header_details["near_by_hotels"]
    schedule_header["hotels_list"]  = header_details["city_top_hotels"]
    partial = "version_2_designs/schedules/en/directs/in_dom_schedule_routes_v2"
    render partial,locals: { dep_city_name: dep_city_name,arr_city_name: arr_city_name,routes_rhs_top_airlines: routes_rhs_top_airlines,schedule_layout_values: schedule_layout_values,flight_file_name: flight_file_name,page_type: 'flight-schedule',lang: lang,schedule_header: schedule_header}

    # @airline_details = {country_code: @country_code}
    # flight_booking_service = FlightBookingService.new @airline_details
    # rhs_airlines = flight_booking_service.rhs_top_airlines
  end
end
