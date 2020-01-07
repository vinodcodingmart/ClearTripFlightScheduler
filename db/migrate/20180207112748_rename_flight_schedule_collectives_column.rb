class RenameFlightScheduleCollectivesColumn < ActiveRecord::Migration[5.1]
  def change
  	rename_column :flight_schedule_collectives,:airline_code,:carrier_code
  end
end
