class CreateAirlineBrands < ActiveRecord::Migration[5.1]
  def change
    create_table :airline_brands do |t|
      t.string :carrier_code
      t.string :carrier_name
      t.string :icoa_code
      t.string :base_airport
      t.string :country
      t.integer :brand_routes_count
      t.string :country_code

      t.timestamps
    end
  end
end
