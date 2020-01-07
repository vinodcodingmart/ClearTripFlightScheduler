class CreateFlightsHeaders < ActiveRecord::Migration[5.1]
  def change
    create_table :flights_headers do |t|
      t.string :dep_city_code
      t.string :arr_city_code
      t.string :dep_city_name
      t.string :arr_city_name
      t.string :hop
      t.string :section
      t.string :page_type
      t.string :route_type
      t.string :language
      t.text :airport_details,:limit => 4294967295
      t.text :hotel_details,:limit => 4294967295
      t.text :train_details,:limit => 4294967295
      t.text :tourism_details,:limit => 4294967295

      t.timestamps
    end
  end
end
