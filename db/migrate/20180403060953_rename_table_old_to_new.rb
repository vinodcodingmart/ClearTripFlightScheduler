class RenameTableOldToNew < ActiveRecord::Migration[5.1]
  def change
  	rename_table :flight_schedule_collectives,:in_flight_schedule_collectives
  end
end
