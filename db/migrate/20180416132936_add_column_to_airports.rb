class AddColumnToAirports < ActiveRecord::Migration[5.1]
  def change
  	add_column :airports, :airport_name_ar, :string
  end
end
