class AddColumnsToAirlineBrand < ActiveRecord::Migration[5.1]
  def change
    add_column :airline_brands, :carrier_name_ar, :string
    add_column :airline_brands, :carrier_name_hi, :string
  end
end
