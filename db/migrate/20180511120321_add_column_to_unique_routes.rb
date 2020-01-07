class AddColumnToUniqueRoutes < ActiveRecord::Migration[5.1]
  def change
    add_column :unique_routes,:source,:string
  end
end
