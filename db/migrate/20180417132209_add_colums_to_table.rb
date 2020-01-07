class AddColumsToTable < ActiveRecord::Migration[5.1]
  def change
  	
  	add_column :unique_routes,:dep_city_name_ar,:string
  	add_column :unique_routes,:arr_city_name_ar,:string
  	add_column :unique_routes,:dep_city_name_hi,:string
  	add_column :unique_routes,:arr_city_name_hi,:string
  end
end
