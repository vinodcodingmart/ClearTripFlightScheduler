class CreateInFooters < ActiveRecord::Migration[5.1]
  def change
    create_table :in_footers do |t|
      t.string :city_code
      t.string :city_name
      t.string :city_name_ar
      t.string :country_code
      t.string :country_name
      t.integer :total_routes_count
      t.text :routes_data
      t.text :current_routes_count
      t.text :routes_data_ar

      t.timestamps
    end
  end
end
