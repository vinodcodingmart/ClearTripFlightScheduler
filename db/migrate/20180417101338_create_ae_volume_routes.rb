class CreateAeVolumeRoutes < ActiveRecord::Migration[5.1]
  def change
    create_table :ae_volume_routes do |t|
      t.string :dep_city_code
      t.string :arr_city_code
      t.string :dep_city_name_en
      t.string :arr_city_name_en
      t.string :dep_city_name_ar
      t.string :arr_city_name_ar
      t.string :url

      t.timestamps
    end
  end
end
