    #   RAILS_ENV=development nohup bundle exec rake merge:tables QUEUE="*" --trace > rake.out 2>&1 &

	namespace :merge do
		desc "merge two different databases tables"
		task  :tables => :environment do
			begin
				updated_count = 0
				created_count = 0
				new_records = NewPackageFlightSchedule.all
				new_records.each do  |record|
				  old_record = PackageFlightSchedule.where(dep_city_code: record.dep_city_code,arr_city_code: record.arr_city_code,carrier_code: record.carrier_code,flight_no: record.flight_no,day_of_operation: record.day_of_operation,arr_time: record.arr_time,dep_time: record.dep_time).first
				  if old_record.present?
				   	old_record.dep_airport_code = record.dep_airport_code
				   	old_record.arr_airport_code = record.arr_airport_code
				   	old_record.dep_country_code = record.dep_country_code
				   	old_record.arr_country_code = record.arr_country_code
				   	old_record.effective_from = record.effective_from
				   	old_record.effective_to = record.effective_to
				   	old_record.flight_count = record.flight_count
				   	old_record.arrival_day_marker = record.arrival_day_marker
				   	old_record.elapsed_journey_time = record.elapsed_journey_time
				   	old_record.distance = record.distance
				   	old_record.intermediate_airports = record.intermediate_airports
				   	old_record.stop = record.stop
				   	old_record.data_source += "|april_2018"
				   	old_record.save!
				   	puts "#{updated_count+=1} records updated!"
				  else
				   	new_record = PackageFlightSchedule.create(dep_city_code: record.dep_city_code,arr_city_code: record.arr_city_code,dep_airport_code: record.dep_airport_code,arr_airport_code: record.arr_airport_code,carrier_code: record.carrier_code,flight_no: record.flight_no,dep_time: record.dep_time,arr_time: record.arr_time,day_of_operation: record.day_of_operation,effective_from: record.effective_from,effective_to: record.effective_to,distance: record.distance,arrival_day_marker: record.arrival_day_marker,elapsed_journey_time: record.elapsed_journey_time,intermediate_airports: record.intermediate_airports,dep_country_code: record.dep_country_code,arr_country_code: record.arr_country_code,flight_count: record.flight_count,data_source: "april_2018",stop: record.stop)
				   	puts "#{created_count += 1} records created!"
				  end
				end
				puts "final updated count = #{update_count}"
				puts "New Records created = #{created_count}"
			rescue => e
				e.message
				e.backtrace
			end
		end
		desc "merge one hop new routes into old package flight hop table"
		task  :tables => :environment do
			begin
				updated_count = 0
				created_count = 0
				new_records = NewPackageFlightHopSchedule.all
				new_records.each do  |record|
				  old_record = PackageFlightHopSchedule.where(dep_city_code: record.dep_city_code,arr_city_code: record.arr_city_code,carrier_code: record.carrier_code,flight_no: record.flight_no,day_of_operation: record.day_of_operation,arr_time: record.arr_time,dep_time: record.dep_time).first
				  if old_record.present?
				   	old_record.dep_airport_code = record.dep_airport_code
				   	old_record.arr_airport_code = record.arr_airport_code
				   	old_record.dep_country_code = record.dep_country_code
				   	old_record.arr_country_code = record.arr_country_code
				   	old_record.effective_from = record.effective_from
				   	old_record.effective_to = record.effective_to
				   	old_record.flight_count = record.flight_count
				   	old_record.arrival_day_marker = record.arrival_day_marker
				   	old_record.elapsed_journey_time = record.elapsed_journey_time
				   	old_record.distance = record.distance
				   	old_record.intermediate_airports = record.intermediate_airports
				   	old_record.stop = record.stop
				   	old_record.data_source += "|april_2018"
				   	old_record.save!
				   	puts "#{updated_count+=1} records updated!"
				  else
				   	new_record = PackageFlightHopSchedule.create(dep_city_code: record.dep_city_code,arr_city_code: record.arr_city_code,dep_airport_code: record.dep_airport_code,arr_airport_code: record.arr_airport_code,carrier_code: record.carrier_code,flight_no: record.flight_no,dep_time: record.dep_time,arr_time: record.arr_time,day_of_operation: record.day_of_operation,effective_from: record.effective_from,effective_to: record.effective_to,distance: record.distance,arrival_day_marker: record.arrival_day_marker,elapsed_journey_time: record.elapsed_journey_time,intermediate_airports: record.intermediate_airports,dep_country_code: record.dep_country_code,arr_country_code: record.arr_country_code,flight_count: record.flight_count,data_source: "april_2018",stop: record.stop)
				   	puts "#{created_count += 1} records created!"
				  end
				end
				puts "final updated count = #{update_count}"
				puts "New Records created = #{created_count}"
			rescue => e
				e.message
				e.backtrace
			end
		end
	end
