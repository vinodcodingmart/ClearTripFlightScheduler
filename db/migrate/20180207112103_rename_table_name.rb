class RenameTableName < ActiveRecord::Migration[5.1]
  def change
  	rename_table :flight_schedule_collecitves,:flight_schedule_collectives
  end
end
