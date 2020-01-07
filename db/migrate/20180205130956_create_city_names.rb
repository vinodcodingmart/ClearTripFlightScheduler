class CreateCityNames < ActiveRecord::Migration[5.1]
  def change
    create_table :city_names do |t|
      t.string :city_code
      t.string :city_name_en
      t.string :city_name_ar
      t.string :city_name_hi

      t.timestamps
    end
  end
end
