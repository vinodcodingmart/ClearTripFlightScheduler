class RemoveColumnsFromUniqueRoutes < ActiveRecord::Migration[5.1]
  def change
  	remove_column :unique_routes,:dep_city_name
  	remove_column :unique_routes,:arr_city_name
  end
end
