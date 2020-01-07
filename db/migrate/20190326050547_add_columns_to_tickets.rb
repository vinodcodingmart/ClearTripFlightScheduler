class AddColumnsToTickets < ActiveRecord::Migration[5.1]
  def change
  	add_column :unique_ft_routes,:is_approved,:longtext
  end
end
