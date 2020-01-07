class DropTable < ActiveRecord::Migration[5.1]
  def change
  	drop_table :in_from_to_contents
  end
end
