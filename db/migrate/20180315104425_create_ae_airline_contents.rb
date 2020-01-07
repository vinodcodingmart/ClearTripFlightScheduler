class CreateAeAirlineContents < ActiveRecord::Migration[5.1]
  def change
    create_table :ae_airline_contents do |t|
      t.string :carrier_code
      t.string :carrier_name
      t.string :country_code
      t.string :icoa_code
      t.string :meta_title_en
      t.string :meta_title_ar
      t.string :meta_description_en
      t.string :meta_description_ar
      t.text :overview_content_en, limit: 4294967295
      t.text :overview_content_ar, limit: 4294967295
      t.text :baggage_content_en, limit: 4294967295
      t.text :baggage_content_ar, limit: 4294967295
      t.text :cancellation_content_en, limit: 4294967295
      t.text :cancellation_content_ar, limit: 4294967295
      t.text :customer_support_content_en, limit: 4294967295

      t.timestamps
    end
  end
end
