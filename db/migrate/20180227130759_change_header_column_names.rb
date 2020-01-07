class ChangeHeaderColumnNames < ActiveRecord::Migration[5.1]
  def change
  	rename_column :headers,:event_city,:dep_city_event
  	rename_column :headers,:weekend_getaway_city,:dep_city_weekend_getaway
  	rename_column :headers,:package_city,:dep_city_package
  	rename_column :headers,:featured_city,:dep_city_featured
  	rename_column :headers,:things_todo_city,:dep_city_things_todo
  	add_column :headers,:arr_city_event,:string
  	add_column :headers,:arr_city_weekend_getaway,:string
  	add_column :headers,:arr_city_package,:string
  	add_column :headers,:arr_city_featured,:string
  	add_column :headers,:arr_things_todo,:string

  end
end

