class CreateKwAirlineFooters < ActiveRecord::Migration[5.1]
  def change
    create_table :kw_airline_footers do |t|
     t.text :airline_footer_en,:limit => 4294967295
      t.text :airline_footer_ar,:limit => 4294967295
      t.text :airline_footer_en_dup,:limit => 4294967295
      t.text :airline_footer_ar_dup,:limit => 4294967295
      t.integer :current_count

      t.timestamps
    end
  end
end
