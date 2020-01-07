class CreateFareCalendars < ActiveRecord::Migration[5.1]
  def change
    create_table :fare_calendars do |t|
      t.string :source_city_code
      t.string :destination_city_code
      t.text :calendar_json,:text,:limit => 4294967295
      t.string :section
      t.timestamps
    end
  end
end
