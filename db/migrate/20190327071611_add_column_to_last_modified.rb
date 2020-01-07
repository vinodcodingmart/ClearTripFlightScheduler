class AddColumnToLastModified < ActiveRecord::Migration[5.1]
  def change
  	# add_column :unique_ft_routes,:last_modified_list,:longtext
  	# add_column :commons,:last_modified_list,:longtext
  	# add_column :unique_fs_routes,:last_modified_list,:longtext
  	# add_column :unique_fb_routes,:last_modified_list,:longtext
  	add_column :unique_fb_overviews,:last_modified_list,:longtext
  	add_column :unique_fb_pnr_webs,:last_modified_list,:longtext
   	add_column :unique_fs_froms,:last_modified_list,:longtext
  	add_column :unique_fs_tos,:last_modified_list,:longtext
  	add_column :unique_fb_baggage_customers,:last_modified_list,:longtext
  end
end
