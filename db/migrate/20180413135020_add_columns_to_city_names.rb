class AddColumnsToCityNames < ActiveRecord::Migration[5.1]
  def change
    add_column :city_names, :from_url, :string
    add_column :city_names, :to_url, :string
  end
end
