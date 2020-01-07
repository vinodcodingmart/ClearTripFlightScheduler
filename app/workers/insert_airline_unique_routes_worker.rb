require 'sidekiq'
require 'sidekiq_status'
require "active_record/relation"


class InsertAirlineUniqueRoutesWorker
  include SidekiqStatus::Worker
  sidekiq_options queue: "insert_airline_unique_routes_worker", backtrace: true
  def perform
    country_code = 'IN'
    # OmAirlineRouteSchedule.delete_all
    # AirlineUniqueRoute.delete_all
    # airline_unique_routes_domestic = PackageFlightSchedule.where("arr_city_code != dep_city_code and dep_city_name IS NOT NULL and arr_city_name IS NOT NULL and carrier_code != ' ' and carrier_brand != ' ' and  (dep_country_code='IN' and arr_country_code='IN')").group(:carrier_code,:carrier_brand,:dep_city_code,:arr_city_code,:dep_country_code,:arr_country_code).order("sum(flight_count) desc").pluck(:carrier_code,:carrier_brand,:dep_city_code, :arr_city_code,  :dep_city_name, :arr_city_name,:dep_country_code,:arr_country_code,"sum(flight_count) as total")

    # airline_unique_routes_international = PackageFlightSchedule.where("arr_city_code != dep_city_code and dep_city_name IS NOT NULL and arr_city_name IS NOT NULL and carrier_code != ' ' and carrier_brand != ' ' and  ((dep_country_code=? and arr_country_code!=?) OR(dep_country_code!=? and arr_country_code=?) OR (dep_country_code!=? and arr_country_code!=?)) and route_status='not_valid' ",country_code,country_code,country_code,country_code,country_code,country_code).group(:carrier_code,:carrier_brand,:dep_city_code,:arr_city_code,:dep_country_code,:arr_country_code).order("sum(flight_count) desc").pluck(:carrier_code,:carrier_brand,:dep_city_code, :arr_city_code,  :dep_city_name, :arr_city_name,:dep_country_code,:arr_country_code,"sum(flight_count) as total")
    airline_unique_routes_international =  PackageFlightSchedule.where("arr_city_code != dep_city_code and dep_city_name IS NOT NULL   and arr_city_name IS NOT NULL and carrier_code !=''  and  ((dep_country_code=? and arr_country_code!=?) OR(dep_country_code!=? and arr_country_code=?) OR (dep_country_code!=? and arr_country_code!=?))",country_code,country_code,country_code,country_code,country_code,country_code).group(:carrier_code,:carrier_brand,:dep_city_code,:arr_city_code,:dep_country_code,:arr_country_code).order("sum(flight_count) desc").pluck(:carrier_code,:carrier_brand,:dep_city_code, :arr_city_code,  :dep_city_name, :arr_city_name,:dep_country_code,:arr_country_code,"sum(flight_count) as total")
    
    
    # insert_routes(airline_unique_routes_domestic)
    insert_routes(airline_unique_routes_international)

  end
  def insert_routes(routes)
    count = 0
    routes.each do |route|
      carrier_code = route[0]
      carrier_name = route[1]
      I18n.locale = :ar
      carrier_name_ar = I18n.t("airlines.#{carrier_code}")
      I18n.locale = :en
      dep_city_code = route[2]
      arr_city_code = route[3]
      dep_city_name = route[4]
      arr_city_name = route[5]
      dep_country_code = route[6]
      arr_country_code =  route[7]
      flight_count = route[8]
      url_format  = url_escape("#{carrier_name.gsub(' ','-').downcase}-#{dep_city_name.gsub(' ','-').downcase}-#{arr_city_name.gsub(' ','-').downcase}-flights")
      r = AirlineUniqueRoute.find_by(url_format: url_format)
      if !r.present? || r.nil?
        count += 1
      AirlineUniqueRoute.find_or_create_by(carrier_code: carrier_code,carrier_name: carrier_name,carrier_name_ar: carrier_name_ar,dep_city_code: dep_city_code,arr_city_code: arr_city_code,url_format: url_format,dep_city_name: dep_city_name,arr_city_name: arr_city_name,dep_country_code: dep_country_code,arr_country_code: arr_country_code,flight_count: flight_count)
      puts "#{count} === #{url_format} created newly"
      else
        puts "#{url_format} exists already!!!"
      end
    end
    puts "#{count} new routes found !!!"
  end

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
end
