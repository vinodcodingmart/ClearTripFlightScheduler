class RenameCityContentTableColumn < ActiveRecord::Migration[5.1]
  def change
  	rename_column :city_contents,:city_name, :city_name_en
  end
end
