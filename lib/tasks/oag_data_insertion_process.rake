namespace :mysql_import do
	require 'csv'
	require 'fileutils'
	SQL_PATH = Rails.root.join("OAG/dump_connections.sql")
	FOLDER_PATH = Rails.root.join("/home/ubuntu/")
	# FOLDER_PATH = "/home/giri/Documents/projects/cleartrip/ct-files/entire-oag-files/oag-unzipped/2018/"
	desc "OAG LOAD TO MYSQL"
	task :oag_load_jul_16 => :environment do
		file = Dir.glob(FOLDER_PATH+".csv").first.to_s
		puts "---------------Loading Oag file Information into flight_schedules table-------------------"
		sql = "load data local infile '#{file}' into table flight_schedules_jul_16 fields terminated by ',' enclosed by '\"' lines terminated by '\n' (carrier_code, flight_no, @dummy, @dummy, dep_airport_code, dep_city_code, dep_country_code, arr_airport_code, arr_city_code, arr_country_code, @dep_time, @arr_time, arrival_day_marker, @elapsed_journey_time, @day_of_operation, stop, intermediate_airports, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, effective_from, effective_to,@dummy,@dummy,distance) set dep_time=CONCAT(substring(@dep_Time,1,2),':',substring(@dep_time,3,4),':00'),elapsed_journey_time=CONCAT(substring(@elapsed_journey_time,1,3),':',substring(@elapsed_journey_time,4,2),':00') ,arr_time=CONCAT(substring(@arr_time,1,2),':',substring(@arr_time,3,4),':00') ,created_at= CURRENT_TIMESTAMP,day_of_operation = @day_of_operation,flight_count=length(trim(REPLACE(day_of_operation, ' ', ''))),data_source='jul_2016';"
		Mysql::FlightSchedule.connection.execute(sql)
	end

	task :new_oag_load_feb_2107 => :environment do
		file = Dir.glob(FOLDER_PATH+"directs/directs_feb_2017_samples.csv").first.to_s
		puts "---------------Loading Oag file Information into flight_schedules table-------------------"
		sql = "load data local infile '#{file}' into table flight_schedules_feb_seventeen fields terminated by ',' enclosed by '' lines terminated by '\n' STARTING BY '' (connection_id, @dummy, dep_city_code, arr_city_code, effective_from, effective_to, @day_of_operation, arrival_day_marker, elapsed_journey_time, dep_airport_code, arr_airport_code, carrier_code, flight_no, @dep_time, @arr_time, @dummy, stop, @dummy, @dummy, @dummy, @dummy, distance, dep_country_code, arr_country_code) set dep_time=CONCAT(substring(@dep_Time,1,2),':',substring(@dep_time,4,5),':', substring(@dep_time,7,8)), arr_time=CONCAT(substring(@arr_time,1,2),':',substring(@arr_time,4,5),':', substring(@arr_time,7,8)), created_at= CURRENT_TIMESTAMP, day_of_operation = @day_of_operation,flight_count=length(trim(REPLACE(day_of_operation, ' ', ''))),data_source='feb_2017';"
		Mysql::FlightSchedule.connection.execute(sql)
	end
	desc "load direct schedules from clt_new_oag_directs.csv"
	task :load_directs_oct_2017 => :environment do
		file = Dir.glob(FOLDER_PATH+"directs/directs_oct_2017_samples.csv").first.to_s
		puts "---------------Loading Oag file Information into flight_schedules table-------------------"
		sql = "load data local infile '#{file}' into table flight_schedules_oct_seventeen fields terminated by ',' enclosed by '' lines terminated by '\n' STARTING BY '' (connection_id, dep_city_code,dep_airport_code, arr_city_code,arr_airport_code, effective_from, effective_to, @day_of_operation, arrival_day_marker, elapsed_journey_time,@dummy,@dummy,@dummy,@dummy,carrier_code, flight_no,@dummy,@dummy,@dummy,@dep_time, @arr_time,@dummy,@dummy,stop,@dummy, @dummy,@dummy, distance,dep_country_code,arr_country_code) set dep_time=CONCAT(substring(@dep_Time,1,2),':',substring(@dep_time,4,5),':', substring(@dep_time,7,8)), arr_time=CONCAT(substring(@arr_time,1,2),':',substring(@arr_time,4,5),':', substring(@arr_time,7,8)), created_at= CURRENT_TIMESTAMP,  day_of_operation = @day_of_operation,flight_count=length(trim(REPLACE(day_of_operation, ' ', ''))),data_source='oct_2017';"
		  Mysql::FlightSchedule.connection.execute(sql)
	end


	desc "load direct schedules from clt_new_oag_directs.csv"
	task :load_directs_april_2018 => :environment do
		create_direct_table = "create table new_package_flight_schedules(carrier_code varchar(255),flight_no varchar(255),dep_airport_code varchar(255),dep_city_code varchar(255),dep_country_code varchar(255),arr_airport_code varchar(255),arr_city_code varchar(255),arr_country_code varchar(255),dep_time varchar(255),arr_time varchar(255),arrival_day_marker integer,elapsed_journey_time varchar(255),flight_count integer,effective_from varchar(255),effective_to varchar(255),day_of_operation varchar(255),stop integer,intermediate_airports varchar(255),data_source varchar(255),distance integer,created_at timestamp);"

		 create_csv_data_table = "create table flight_schedules_april_eighteen(connection_id INT,carrier_code varchar(255),flight_no varchar(255),dep_airport_code varchar(255),dep_city_code varchar(255),dep_country_code varchar(255),arr_airport_code varchar(255),arr_city_code varchar(255),arr_country_code varchar(255),dep_time varchar(255),arr_time varchar(255),arrival_day_marker integer,elapsed_journey_time varchar(255),flight_count integer,effective_from varchar(255),effective_to varchar(255),day_of_operation varchar(255),stop integer,intermediate_airports varchar(255),data_source varchar(255),distance integer,created_at timestamp);"
		puts "-------------started creating directs table-----------"

		# Mysql::FlightSchedule.connection.execute("drop table new_package_flight_schedules;")

		Mysql::FlightSchedule.connection.execute(create_direct_table)

		puts "-------------end of creating table -------------"


  	puts "-------------started creating table for csv data----------"
		# Mysql::FlightSchedule.connection.execute("drop table flight_schedules_april_eighteen;")
		Mysql::FlightSchedule.connection.execute(create_csv_data_table)

		puts "-------------end of creating table for csv data -------------"


		file = Dir.glob(FOLDER_PATH+"CLT_DIR.csv").first.to_s
		puts "---------------Loading Oag file Information into flight_schedules_april_eighteen table-------------------"

		sql = "load data local infile '#{file}' into table flight_schedules_april_eighteen fields terminated by ',' enclosed by '' lines terminated by '\n' STARTING BY '' (connection_id, dep_city_code,dep_airport_code, arr_city_code,arr_airport_code, effective_from, effective_to, @day_of_operation, arrival_day_marker, elapsed_journey_time,@dummy,@dummy,@dummy,@dummy,carrier_code, flight_no,@dummy,@dummy,@dummy,@dep_time, @arr_time,@dummy,@dummy,stop,@dummy, @dummy,@dummy, distance,dep_country_code,arr_country_code) set dep_time=CONCAT(substring(@dep_Time,1,2),':',substring(@dep_time,4,5),':', substring(@dep_time,7,8)), arr_time=CONCAT(substring(@arr_time,1,2),':',substring(@arr_time,4,5),':', substring(@arr_time,7,8)), created_at= CURRENT_TIMESTAMP,  day_of_operation = @day_of_operation,flight_count=length(trim(REPLACE(day_of_operation, ' ', ''))),data_source='april_2018';"
		  Mysql::FlightSchedule.connection.execute(sql)
	end

	desc "Import latest oag direct schedules into package_flight_schedule"
	task :import_latest_oag_directs => :environment do
		records = Mysql::FlightSchedule.connection.execute("select  effective_from, effective_to, day_of_operation, dep_airport_code, arr_airport_code, carrier_code, flight_no, dep_time, flight_count, arr_time, dep_country_code, arr_country_code,stop,arrival_day_marker,dep_city_code,arr_city_code,elapsed_journey_time,distance,data_source from flight_schedules_april_eighteen group by dep_airport_code, arr_airport_code, carrier_code, flight_no, dep_time, arr_time, effective_from, effective_to")
		# 
		count = 0
		records.each do |row|
			puts " #{count += 1} - `Inserted for dep_city_code #{row[14]} - #{row[15]} arr_city_code"
			Mysql::FlightSchedule.connection.execute("Insert into new_package_flight_schedules(effective_from, effective_to, day_of_operation, dep_airport_code, arr_airport_code, carrier_code, flight_no, dep_time, flight_count, arr_time, dep_country_code, arr_country_code,stop,arrival_day_marker,dep_city_code,arr_city_code,elapsed_journey_time,distance,data_source) values ('#{row[0].to_s}', '#{row[1].to_s}', '#{row[2]}', '#{row[3]}', '#{row[4]}', '#{row[5]}', '#{row[6]}', '#{row[7]}', '#{row[8]}', '#{row[9]}', '#{row[10]}', '#{row[11]}','#{row[12]}','#{row[13]}','#{row[14]}','#{row[15]}','#{row[16]}','#{row[17]}','#{row[18]}');")
		end
	end

	desc "DUMP  DIRECTS TO LOCAL"
	task :directs_dump_local => :environment do
		system "mysqldump -u flights -pClearTripCalendar air_development_testing package_flight_schedules --no-create-db --no-create-info --skip-comments  --skip-triggers --skip-quote-names --compatible=postgres > pfs_my_to_pg.sql"
	end

	task login_local_mysql: :environment do
		sql_query = ""
		Mysql::FlightSchedule.connection.execute(sql_query)
	end

	desc "load connection routes from CLT_Connections.csv"
	task :load_hops_latest_oag => :environment  do
		file = Dir.glob(FOLDER_PATH+"CLT_CONX.csv").first.to_s
		begin
		puts "---------------Loading Oag file Information into new_flight_hop_schedules table-------------------"
		sql = "load data local infile '#{file}' into table flight_hop_schedules_april_eighteen fields terminated by ',' enclosed by '' lines terminated by '\n' STARTING BY '' (connection_id, dep_city_code,dep_airport_code, arr_city_code,arr_airport_code, effective_from, effective_to, @day_of_operation, arrival_day_marker, elapsed_journey_time,l1_dep_city_code,l1_dep_airport_code,l1_arr_city_code,l1_arr_airport_code,l1_carrier_code,l1_flight_no,l1_effective_from,l1_effective_to,@l1_day_of_operation,@l1_dep_time,@l1_arr_time,l1_arrival_day_marker,l1_elapsed_journey_time,l1_stop,@dummy, @dummy,@dummy, l1_distance,l1_dep_country_code,l1_arr_country_code,l2_dep_city_code,l2_dep_airport_code,l2_arr_city_code,l2_arr_airport_code,l2_carrier_code,l2_flight_no,l2_effective_from,l2_effective_to,@l2_day_of_operation,@l2_dep_time,@l2_arr_time,l2_arrival_day_marker,l2_elapsed_journey_time,l2_stop,@dummy,@dummy,@dummy,l2_distance,l2_dep_country_code,l2_arr_country_code) set dep_time= CONCAT(substring(@l1_dep_Time,1,2),':',substring(@l1_dep_time,4,5),':', substring(@l1_dep_time,7,8)),arr_time=CONCAT(substring(@l2_arr_time,1,2),':',substring(@l2_arr_time,4,5),':', substring(@l2_arr_time,7,8)),carrier_code=l1_carrier_code,day_of_operation=@day_of_operation,flight_count=length(trim(REPLACE(day_of_operation, ' ', ''))),dep_country_code=l1_dep_country_code,arr_country_code=l2_arr_country_code,distance=l1_distance+l2_distance,l1_dep_time=CONCAT(substring(@l1_dep_Time,1,2),':',substring(@l1_dep_time,4,5),':', substring(@l1_dep_time,7,8)), l1_arr_time=CONCAT(substring(@l1_arr_time,1,2),':',substring(@l1_arr_time,4,5),':', substring(@l1_arr_time,7,8)), l1_day_of_operation = @l1_day_of_operation,l1_flight_count=length(trim(REPLACE(l1_day_of_operation, ' ', ''))),l2_dep_time=CONCAT(substring(@l2_dep_Time,1,2),':',substring(@l2_dep_time,4,5),':', substring(@l2_dep_time,7,8)), l2_arr_time=CONCAT(substring(@l2_arr_time,1,2),':',substring(@l2_arr_time,4,5),':', substring(@l2_arr_time,7,8)), l2_day_of_operation = @l2_day_of_operation,l2_flight_count=length(trim(REPLACE(l2_day_of_operation, ' ', ''))), created_at= CURRENT_TIMESTAMP;"
			Mysql::FlightSchedule.connection.execute(sql)
		rescue StandardError => e
			
		end
	end

	desc "Import latest oag package_flight_hop_schedule"
	task :import_april_2018_hop_schedules => :environment do
		records = Mysql::FlightSchedule.connection.execute("select dep_city_code,dep_airport_code,arr_city_code,arr_airport_code,effective_from,effective_to,day_of_operation,arrival_day_marker,elapsed_journey_time, dep_time,arr_time, dep_country_code, arr_country_code,distance,l1_dep_city_code,l1_dep_airport_code,l1_arr_city_code,l1_arr_airport_code,l1_carrier_code,l1_flight_no,l1_effective_from,l1_effective_to,l1_day_of_operation,l1_dep_time,l1_arr_time,l1_arrival_day_marker,l1_elapsed_journey_time,l1_distance,l1_dep_country_code,l1_arr_country_code,l2_dep_city_code,l2_dep_airport_code,l2_arr_city_code,l2_arr_airport_code,l2_carrier_code,l2_flight_no,l2_effective_from,l2_effective_to,l2_day_of_operation,l2_dep_time,l2_arr_time,l2_arrival_day_marker,l2_elapsed_journey_time,l2_distance,l2_dep_country_code,l2_arr_country_code from flight_hop_schedules_april_eighteen group by dep_city_code,arr_city_code,dep_country_code,arr_country_code,l1_carrier_code,l2_carrier_code,l1_flight_no,l2_flight_no")
		# 
		count = 0
		records.each do |row|
			puts "#{count += 1} - Inserted for dep_city_code #{row[0]} - #{row[2]} arr_city_code, distance='#{row[13]}' l1_distance='#{row[27]}',l1_distance='#{row[43]}'"
			Mysql::FlightSchedule.connection.execute("Insert into new_package_flight_hop_schedules(dep_city_code,dep_airport_code,arr_city_code,arr_airport_code,effective_from,effective_to,day_of_operation,arrival_day_marker,elapsed_journey_time,dep_time,arr_time,dep_country_code, arr_country_code,distance,l1_dep_city_code,l1_dep_airport_code,l1_arr_city_code,l1_arr_airport_code,l1_carrier_code,l1_flight_no,l1_effective_from,l1_effective_to,l1_day_of_operation,l1_dep_time,l1_arr_time,l1_arrival_day_marker,l1_elapsed_journey_time,l1_distance,l1_dep_country_code,l1_arr_country_code,l2_dep_city_code,l2_dep_airport_code,l2_arr_city_code,l2_arr_airport_code,l2_carrier_code,l2_flight_no,l2_effective_from,l2_effective_to,l2_day_of_operation,l2_dep_time,l2_arr_time,l2_arrival_day_marker,l2_elapsed_journey_time,l2_distance,l2_dep_country_code,l2_arr_country_code) values ('#{row[0]}', '#{row[1]}','#{row[2]}', '#{row[3]}', '#{row[4].to_s}','#{row[5].to_s}', '#{row[6]}', '#{row[7]}', '#{row[8]}', '#{row[9]}', '#{row[10]}', '#{row[11]}','#{row[12]}','#{row[13]}','#{row[14]}','#{row[15]}','#{row[16]}','#{row[17]}','#{row[18]}','#{row[19].to_s}','#{row[20].to_s}','#{row[21]}','#{row[22]}','#{row[23]}','#{row[24]}','#{row[25]}','#{row[26]}','#{row[27]}','#{row[28]}','#{row[29]}','#{row[30]}','#{row[31]}','#{row[32]}','#{row[33]}','#{row[34]}','#{row[35].to_s}','#{row[36].to_s}','#{row[37]}','#{row[38]}','#{row[39]}','#{row[40]}','#{row[41]}','#{row[42]}','#{row[43]}','#{row[44]}','#{row[45]}');")
		end
	end


	task :connections_dump_local => :environment do
		system "mysqldump -u root -proot clt_seo_db_merges package_flight_hop_schedules --no-create-db --no-create-info --skip-comments --complete-insert --skip-triggers --skip-quote-names --compatible=postgres > #{SQL_PATH}"
	end

	# desc "Import package_flight_schedule"
	# task :import_hop_clone => :environment do
	# 	records = Mysql::FlightSchedule.connection.execute("select effective_from, effective_to, day_of_operation, dep_city_code, arr_city_code, carrier_code, flight_no, dep_time, flight_count, arr_time, dep_country_code, arr_country_code from new_package_flight_hop_schedules group by dep_city_code, arr_city_code")
	# 	# 
	# 	records.each do |row|
	# 		puts "#{row[3]} - #{row[4]}"
	# 		Mysql::FlightSchedule.connection.execute("Insert into clone_package_flight_schedules (effective_from, effective_to, day_of_operation, dep_airport_code, arr_airport_code, carrier_code, flight_no, dep_time, flight_count, arr_time, dep_country_code, arr_country_code) values ('#{row[0]}', '#{row[1]}', '#{row[2]}', '#{row[3]}', '#{row[4]}', '#{row[5]}', '#{row[6]}', '#{row[7].strftime("%H:%M:%S")}', '#{row[8]}', '#{row[9].strftime("%H:%M:%S")}', '#{row[10]}', '#{row[11]}');")
	# 	end
	# end

	desc "IMPORT POSTGRES"
	task :load_postgres => :environment do
		system "sudo -u postgres psql flights_development_jan18  < #{SQL_PATH}"
	end

	desc "IMPORT POSTGRES"
	task :unnamed_city_codes => :environment do
		dep_city_codes = PackageFlightSchedule.where('dep_city_name is NUll').select(:dep_city_code).distinct.pluck(:dep_city_code)
		arr_city_codes = PackageFlightSchedule.where('arr_city_name is NUll').select(:arr_city_code).distinct.pluck(:arr_city_code)
		city_codes = dep_city_codes + arr_city_codes
		city_codes = city_codes.uniq
		CSV.open("unnamed_city_codes.csv","w") do |csv|
			csv << ['City Code']
			city_codes.each do |code|
				csv << [code]
			end
		end
		# system "sudo -u postgres psql waytogo_development  < #{SQL_PATH}"jui9

	end

	desc "valid routes"
	task :valid_routes => :environment do
		csv_file = "#{APP_ROOT}/public/new_hop.csv"

    csv_text = File.read(csv_file)
    csv = CSV.parse(csv_text, headers: :first_row, col_sep: ",")

		CSV.open("valid_routes.csv", "w") do |valid_r|
			csv.each do |row|
				recs = Mysql::FlightSchedule.connection.execute("select * from routes where dep_airport_code='#{row[0]}' and arr_airport_code='#{row[2]}' limit 1")
				puts "#{row[0]},#{row[1]},#{row[2]},#{row[3]},#{recs.count>0 ? 'valid': 'invalid'}"
				valid_r << [row[0], row[1], row[2], row[3], row[4], row[5], recs.count>0 ? 'valid': 'invalid']
			end
		end

	end

	desc "generate csv"
	task :generate_csv => :environment do

		I18n.locale = :en
		airports = Airport.all
		CSV.open("airports.csv", "w") do |valid_r|
			valid_r << ["Airport code", "Airpot Name", "City Code", "City Name", "Country Code"]
			airports.each do |airport|
				puts "#{airport.airport_code}, #{airport.airport_name}"
				valid_r << [airport.airport_code, airport.airport_name, airport.city_code, airport.city_name, airport.country_code]
			end
		end
	end

	desc "DUMP TO LOCAL"
	task :missing_pages => :environment do
		# "select count(distinct url) from flight_routes where section like '%IN-%' and page_type='flight_route' and page_status='published' and url not in (select url from s3_pages where country_code='in' and page_type='flight-tickets')"
		missing_routes = FlightRoute.where("section like '%IN-%' and page_type='flight_route' and page_status='published' and url not in (select url from s3_pages where country_code='in' and page_type='flight-tickets')").select(:url).distinct
		puts missing_routes.count
		missing_routes.each do |route|
			if File.exist?('generated/tourism/flight/flight-tickets/IN/en/'+route.url)
				puts route.url+'   -   true'
				FileUtils.cp('generated/tourism/flight/flight-tickets/IN/en/'+route.url, 'public/missing_flight_route_files/flight-tickets/IN/en/'+route.url)
			end
		end
	end
end
