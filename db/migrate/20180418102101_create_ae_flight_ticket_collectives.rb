class CreateAeFlightTicketCollectives < ActiveRecord::Migration[5.1]
  def change
    create_table :ae_flight_ticket_collectives do |t|
      t.string :carrier_code
      t.integer :flight_no
      t.string :dep_time
      t.string :arr_time
      t.string :duration
      t.string :days_of_operation
      t.string :dep_city_code
      t.string :arr_city_code
      t.string :dep_country_code
      t.string :arr_country_code
      t.references :unique_route, foreign_key: true

      t.timestamps
    end
  end
end
