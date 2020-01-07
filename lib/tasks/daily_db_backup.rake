namespace :backup_daily do 
	task :cms_panel_testing_db => :environment do 
		system "echo '' > cms_panel_testingdb_daily_backup.sql"
		system "mysqldump -h 13.251.49.54  -u  flights -pClearTripCalendar cms_panel_testing > /home/ubuntu/do_not_delete/cms_panel_testingdb_daily_backup.sql"
	end
end

