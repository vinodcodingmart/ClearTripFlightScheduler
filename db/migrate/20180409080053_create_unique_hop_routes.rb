class CreateUniqueHopRoutes < ActiveRecord::Migration[5.1]
  def change
    create_table :unique_hop_routes do |t|
      t.string :dep_city_code
      t.string :arr_city_code
      t.string :dep_airport_code
      t.string :arr_airport_code
      t.string :dep_country_code
      t.string :arr_country_code
      t.string :dep_city_name
      t.string :arr_city_name
      t.integer :hop
      t.integer :distance
      t.integer :weekly_flights_count
      t.integer :total_flights_count
      t.string :url

      t.timestamps
    end
  end
end
