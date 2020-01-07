class CreateCollectives < ActiveRecord::Migration[5.1]
  def change
    create_table :collectives do |t|
      t.string :operational_airlines
      t.string :airline_flight_count
      t.references :unique_route, foreign_key: true

      t.timestamps
    end
  end
end
