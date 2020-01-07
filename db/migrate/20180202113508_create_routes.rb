class CreateRoutes < ActiveRecord::Migration[5.1]
  def change
    create_table :routes do |t|
      t.string :dep_city_code
      t.string :arr_city_code
      t.string :dep_city_name
      t.string :arr_city_name
      t.string :dep_airport_code
      t.string :arr_airport_code
      t.string :dep_country_code
      t.string :arr_country_code
      t.integer :weekly_flights_count
      t.integer :distance
      t.integer :hop

      t.timestamps
    end
  end
end
