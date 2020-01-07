class CreateKwFlightHopScheduleCollectives < ActiveRecord::Migration[5.1]
  def change
    create_table :kw_flight_hop_schedule_collectives do |t|
      t.string :carrier_code
      t.string :dep_time
      t.string :arr_time
      t.string :dep_city_code
      t.string :arr_city_code
      t.string :dep_country_code
      t.string :arr_country_code
      t.string :dep_airport_code
      t.string :arr_airport_code
      t.string :mid_city_code
      t.string :mid_airport_code
      t.string :duration
      t.integer :first_flight_no
      t.integer :second_flight_no
      t.string :first_carrier_code
      t.string :second_carrier_code
      t.string :days_of_operation
      t.references :unique_hop_route, foreign_key: true

      t.timestamps
    end
  end
end
