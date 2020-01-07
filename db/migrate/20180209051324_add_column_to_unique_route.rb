class AddColumnToUniqueRoute < ActiveRecord::Migration[5.1]
  def change
    add_column :unique_routes, :dep_city_name, :string
    add_column :unique_routes, :arr_city_name, :string
  end
end
