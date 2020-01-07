class AddColumnToAirlineBrand < ActiveRecord::Migration[5.1]
  def change
    add_column :airline_brands, :publish_status, :string
  end
end
