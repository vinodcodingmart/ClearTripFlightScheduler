namespace :cms_sink do 
	desc " sink cms data to testing"

	task :data => :environment do
		def save_common_fileds(flight_record,record)
			flight_record.domain = record.domain
			flight_record.language = record.language 
			flight_record.title = record.title 
			flight_record.description = record.description 
			flight_record.heading = record.heading
			flight_record.content = record.content
			flight_record.faq_object = record.faq_object
			flight_record.reviews_object = record.reviews_object
			flight_record.is_approved = true
			return flight_record
		end
		table_names = CMS::FlightSection.where("edit_status=? or created_status=?" ,"new updation","new creation").pluck(:table_name)
		table_names.each do |table_name_string|
		 	table_name = table_name_string.constantize
		 	cms_table_name = "CMS::#{table_name_string.constantize}".constantize
		 	cms_records = cms_table_name.where(is_approved: true).where("edit_status='new updation' OR created_status='new creation'")
	 		case table_name_string 
			when "UniqueFsRoute"
			cms_records.each do |record|
			flight_record = table_name.find_or_create_by(url: record.url)
				begin
					save_common_fileds(flight_record,record)
					flight_record.source = record.source 
					flight_record.destination = record.destination 
					if flight_record.save 
						record.update(edit_status: 'update_sink_done', created_status: 'create_sink_done')
						puts "Sinked CMS data cms_table_name =  #{cms_table_name} and record_id = #{record.id}  successfully - #{Time.now}"
					else
						puts "CMS sinking failed"
					end
				rescue StandardError => e
					puts 	e.message
					puts 	e.backtrace
				end
			end

			when "UniqueFsFrom"	
				cms_records.each do |record|
			flight_record = table_name.find_or_create_by(url: record.url)
				begin
					save_common_fileds(flight_record,record)
					flight_record.source = record.source 
					if flight_record.save 
						record.update(edit_status: 'update_sink_done', created_status: 'create_sink_done')
						puts "Sinked CMS data cms_table_name =  #{cms_table_name} and record_id = #{record.id}  successfully - #{Time.now}"
					else
						puts "CMS sinking failed"
					end
				rescue StandardError => e
					puts 	e.message
					puts 	e.backtrace
				end
			end

			when "UniqueFsTo"
				cms_records.each do |record|
			flight_record = table_name.find_or_create_by(url: record.url)
				begin
					save_common_fileds(flight_record,record)
					flight_record.source = record.source 
					if flight_record.save 
						record.update(edit_status: 'update_sink_done', created_status: 'create_sink_done')
						puts "Sinked CMS data cms_table_name =  #{cms_table_name} and record_id = #{record.id}  successfully - #{Time.now}"
					else
						puts "CMS sinking failed"
					end
				rescue StandardError => e
					puts 	e.message
					puts 	e.backtrace
				end
			end

			when "UniqueFbOverview"
				cms_records.each do |record|
			flight_record = table_name.find_or_create_by(url: record.url)
				begin
					save_common_fileds(flight_record,record)
					flight_record.airline_name = record.airline_name
					if flight_record.save 
						record.update(edit_status: 'update_sink_done', created_status: 'create_sink_done')
						puts "Sinked CMS data cms_table_name =  #{cms_table_name} and record_id = #{record.id}  successfully - #{Time.now}"
					else
						puts "CMS sinking failed"
					end
				rescue StandardError => e
					puts 	e.message
					puts 	e.backtrace
				end
			end

			when "UniqueFbRoute"
				cms_records.each do |record|
			flight_record = table_name.find_or_create_by(url: record.url)
				begin
					save_common_fileds(flight_record,record)
					flight_record.airline_name = record.airline_name
					flight_record.source = record.source 
					flight_record.destination = record.destination
					if flight_record.save 
						record.update(edit_status: 'update_sink_done', created_status: 'create_sink_done')
						puts "Sinked CMS data cms_table_name =  #{cms_table_name} and record_id = #{record.id}  successfully - #{Time.now}"
					else
						puts "CMS sinking failed"
					end
				rescue StandardError => e
					puts 	e.message
					puts 	e.backtrace
				end
			end

			when "UniqueFbBaggageCustomer"
				cms_records.each do |record|
			flight_record = table_name.find_or_create_by(url: record.url)
				begin
					save_common_fileds(flight_record,record)
					flight_record.airline_name = record.airline_name
					if flight_record.save 
						record.update(edit_status: 'update_sink_done', created_status: 'create_sink_done')
						puts "Sinked CMS data cms_table_name =  #{cms_table_name} and record_id = #{record.id}  successfully - #{Time.now}"
					else
						puts "CMS sinking failed"
					end
				rescue StandardError => e
					puts 	e.message
					puts 	e.backtrace
				end
			end

			when "UniqueFbPnrWeb"
				cms_records.each do |record|
			flight_record = table_name.find_or_create_by(url: record.url)
				begin
					save_common_fileds(flight_record,record)
					flight_record.airline_name = record.airline_name
					if flight_record.save 
						record.update(edit_status: 'update_sink_done', created_status: 'create_sink_done')
						puts "Sinked CMS data cms_table_name =  #{cms_table_name} and record_id = #{record.id}  successfully - #{Time.now}"
					else
						puts "CMS sinking failed"
					end
				rescue StandardError => e
					puts 	e.message
					puts 	e.backtrace
				end
			end

			when "UniqueFtRoute"
				cms_records.each do |record|
			flight_record = table_name.find_or_create_by(url: record.url)
				begin
					save_common_fileds(flight_record,record)
					flight_record.source = record.source
					flight_record.destination = record.destination
					if flight_record.save 
						record.update(edit_status: 'update_sink_done', created_status: 'create_sink_done')
						puts "Sinked CMS data cms_table_name =  #{cms_table_name} and record_id = #{record.id}  successfully - #{Time.now}"
					else
						puts "CMS sinking failed"
					end
				rescue StandardError => e
					puts 	e.message
					puts 	e.backtrace
				end
			end

			else "Common"
			cms_records.each do |record|
				flight_record = table_name.find_or_create_by(domain: record.domain,language: record.language,section: record.section,page_type: record.page_type,page_subtype: record.page_subtype)
				begin
					save_common_fileds(flight_record,record)
					flight_record.page_subtype = record.page_subtype 
					flight_record.page_type = record.page_type
					flight_record.domain = record.domain
					flight_record.language = record.language
					flight_record.section = record.section
					if flight_record.save 
						record.update(edit_status: 'update_sink_done', created_status: 'create_sink_done')
						puts "Sinked CMS data cms_table_name =  #{cms_table_name} and record_id = #{record.id}  successfully - #{Time.now}"
					else
						puts "CMS sinking failed"
					end
				rescue StandardError => e
					puts 	e.message
					puts 	e.backtrace
				end
			end
			end
			CMS::FlightSection.where("edit_status=? or created_status=?" ,"new updation","new creation").update_all(edit_status: "",created_status: "")
		end
	end

end