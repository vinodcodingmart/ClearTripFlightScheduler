class RenameRoutesToUniqueRoutes < ActiveRecord::Migration[5.1]
  def change
  	rename_table :routes, :unique_routes
  end
end
