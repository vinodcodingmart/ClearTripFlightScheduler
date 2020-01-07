class AddColumnToInFromToContents < ActiveRecord::Migration[5.1]
  def change
  	add_column :in_from_to_contents,:city_name,:string
  end
end
