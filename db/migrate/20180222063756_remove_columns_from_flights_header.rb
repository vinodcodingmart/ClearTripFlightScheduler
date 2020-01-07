class RemoveColumnsFromFlightsHeader < ActiveRecord::Migration[5.1]
  def change
  	remove_column :flights_headers,:section,:text
  	remove_column :flights_headers,:airport_details,:text
  	add_column :flights_headers,:status,:string
  end
end
