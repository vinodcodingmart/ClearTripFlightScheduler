namespace :update do
  desc "update volume_routes"
  task volume_routes: :environment do
    count = 0
    # VolumeRoute.delete_all
		CSV.foreach("public/final_search_volume_routes.csv", :headers=>true).each_with_index do |row,index|
      volume_count = row[1].to_i
      volume_route = row[0].split(" to ")
      dep_city_name_en = volume_route[0].titleize
      arr_city_name_en = volume_route[1].gsub("flights",'').titleize
      route = UniqueRoute.find_by(dep_city_name: dep_city_name_en,arr_city_name: arr_city_name_en)
      if route.present? && !route.nil?
        dep_city_code = route.dep_city_code
        arr_city_code = route.arr_city_code
        dep_city_name_ar = route.dep_city_name_ar
        arr_city_name_ar = route.arr_city_name_ar
        url = route.schedule_route_url+"-flights"
        new_volume_route = OmVolumeRoute.find_or_create_by(dep_city_code: dep_city_code,arr_city_code: arr_city_code,dep_city_name_en: dep_city_name_en,url: url)
        new_volume_route.dep_city_name_ar = dep_city_name_ar
        new_volume_route.arr_city_name_ar =  arr_city_name_ar
        new_volume_route.volume_count =  volume_count
        new_volume_route.save!
        puts "#{count+=1} volume routes inserted"
      end
    end
  end
end
