class ChangeColumnTypeInFooters < ActiveRecord::Migration[5.1]
  def change
  	change_column :in_footers,:current_routes_count,:integer
  end
end
