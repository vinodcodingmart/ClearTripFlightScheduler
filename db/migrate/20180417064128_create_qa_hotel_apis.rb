class CreateQaHotelApis < ActiveRecord::Migration[5.1]
  def change
    create_table :qa_hotel_apis do |t|
      t.string :city_name
      t.string :country_code
      t.string :country_name
      t.text :hotel_data,:limit => 4294967295
      t.text :properties,:limit => 4294967295
      t.text :star_data,:limit => 4294967295
      t.text :local_cities_data,:limit => 4294967295
      t.text :local_activities,:limit => 4294967295
      t.integer :current_iteration_count
      t.integer :total_iteration_count
      t.text :wayto_go,:limit => 4294967295
      t.integer :local_activities_total
      t.integer :local_activities_current

    end
  end
end
