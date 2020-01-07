class CreateInAirlineContents < ActiveRecord::Migration[5.1]
  def change
    create_table :in_airline_contents do |t|
      t.string :carrier_code
      t.string :carrier_name
      t.string :country_code
      t.string :icoa_code
      t.string :meta_title_en
      t.string :meta_title_hi
      t.text :meta_description_en
      t.text :meta_description_hi
      t.text :overview_content_en,:limit => 4294967295 
      t.text :overview_content_hi,:limit => 4294967295 
      t.text :baggage_content_en,:limit => 4294967295 
      t.text :baggage_content_hi,:limit => 4294967295 
      t.text :cancellation_content_en,:limit => 4294967295 
      t.text :cancellation_content_hi,:limit => 4294967295 
      t.text :customer_support_content_en,:limit => 4294967295 
      t.text :customer_support_content_hi,:limit => 4294967295 
      t.text :pnr_content_en,:limit => 4294967295 
      t.text :pnr_content_hi,:limit => 4294967295 
      t.text :web_checkin_content_en,:limit => 4294967295 
      t.text :web_checkin_content_hi,:limit => 4294967295 

      t.timestamps
    end
  end
end
