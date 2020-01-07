class CreateQaFromToContents < ActiveRecord::Migration[5.1]
  def change
    create_table :qa_from_to_contents do |t|
      t.string :city_code
      t.text :en_from_content
      t.text :en_to_content
      t.text :ar_from_content
      t.text :ar_to_content
      t.string :city_name

      t.timestamps
    end
  end
end
