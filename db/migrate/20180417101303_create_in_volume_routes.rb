class CreateInVolumeRoutes < ActiveRecord::Migration[5.1]
  def change
    create_table :in_volume_routes do |t|
      t.string :dep_city_code
      t.string :arr_city_code
      t.string :dep_city_name_en
      t.string :arr_city_name_en
      t.string :dep_city_name_hi
      t.string :arr_city_name_hi
      t.string :url

      t.timestamps
    end
  end
end
