class RemoveColumnFromFareCalendar < ActiveRecord::Migration[5.1]
  def change
    remove_column :fare_calendars, :text, :text
  end
end
