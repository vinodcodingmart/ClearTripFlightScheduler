class CreateHeaders < ActiveRecord::Migration[5.1]
  def change
    create_table :headers do |t|
      t.string :dep_city_code
      t.string :arr_city_code
      t.string :dep_city_name
      t.string :arr_city_name
      t.string :route_type
      t.string :event_city
      t.string :weekend_getaway_city
      t.string :package_city
      t.string :featured_city
      t.string :things_todo_city
      t.text :hotel_details,limit: 4294967295
      t.text :train_details,limit: 4294967295

      t.timestamps
    end
  end
end
