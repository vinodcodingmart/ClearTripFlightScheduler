class CreateInFromToContents < ActiveRecord::Migration[5.1]
  def change
    create_table :in_from_to_contents do |t|
      t.string :city_code
      t.text :en_from_content,:limit => 4294967295
      t.text :en_to_content,:limit => 4294967295
      t.text :hi_from_content,:limit => 4294967295
      t.text :hi_to_content,:limit => 4294967295

      t.timestamps
    end
  end
end


