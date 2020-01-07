class CreateCityContents < ActiveRecord::Migration[5.1]
  def change
    create_table :city_contents do |t|
      t.string :city_code
      t.string :city_name
      t.string :city_name_ar
      t.string :city_name_hi
      t.text :content_in_en
      t.text :content_ae_en
      t.text :content_sa_en
      t.text :content_bh_en
      t.text :content_kw_en
      t.text :content_qa_en
      t.text :content_om_en
      t.text :content_in_hi
      t.text :content_ae_ar
      t.text :content_sa_ar
      t.text :content_bh_ar
      t.text :content_kw_ar
      t.text :content_qa_ar
      t.text :content_om_ar

      t.timestamps
    end
  end
end
