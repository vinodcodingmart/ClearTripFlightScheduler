# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20191027133623) do

  create_table "add_column_to_in_airline_contents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ae_airline_brand_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "carrier_name"
    t.string "flight_no"
    t.string "dep_time"
    t.string "arr_time"
    t.string "duration"
    t.string "days_of_operation"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.bigint "unique_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["carrier_code", "carrier_name"], name: "indecies"
    t.index ["carrier_code", "carrier_name"], name: "indicies"
    t.index ["unique_route_id"], name: "index_ae_airline_brand_collectives_on_unique_route_id"
  end

  create_table "ae_airline_contents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "carrier_name"
    t.string "country_code"
    t.string "icoa_code"
    t.string "meta_title_en"
    t.string "meta_title_ar"
    t.string "meta_description_en"
    t.string "meta_description_ar"
    t.text "overview_content_en", limit: 4294967295
    t.text "overview_content_ar", limit: 4294967295
    t.text "baggage_content_en", limit: 4294967295
    t.text "baggage_content_ar", limit: 4294967295
    t.text "cancellation_content_en", limit: 4294967295
    t.text "cancellation_content_ar", limit: 4294967295
    t.text "customer_support_content_en", limit: 4294967295
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "overview_keywords_ar"
    t.text "overview_keywords_en"
    t.text "customer_support_content_ar"
    t.text "travel_document_ar", limit: 4294967295
    t.text "travel_document_en", limit: 4294967295
    t.text "special_assistance_ar", limit: 4294967295
    t.text "special_assistance_en", limit: 4294967295
    t.text "pnr_content_en", limit: 4294967295
    t.text "pnr_content_ar", limit: 4294967295
    t.text "web_checkin_content_en", limit: 4294967295
    t.text "web_checkin_content_ar", limit: 4294967295
  end

  create_table "ae_airline_footers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "airline_footer_en", limit: 4294967295
    t.text "airline_footer_ar", limit: 4294967295
    t.text "airline_footer_en_dup", limit: 4294967295
    t.text "airline_footer_ar_dup", limit: 4294967295
    t.integer "current_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ae_airline_route_schedules", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.integer "flight_no"
    t.string "dep_time"
    t.string "arr_time"
    t.string "duration"
    t.string "days_of_operation"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.bigint "airline_unique_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["airline_unique_route_id"], name: "index_ae_airline_route_schedules_on_airline_unique_route_id"
  end

  create_table "ae_flight_hop_schedule_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "dep_time"
    t.string "arr_time"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.string "dep_airport_code"
    t.string "arr_airport_code"
    t.string "mid_city_code"
    t.string "mid_airport_code"
    t.string "mid_country_code"
    t.string "duration"
    t.integer "first_flight_no"
    t.integer "second_flight_no"
    t.string "first_carrier_code"
    t.string "second_carrier_code"
    t.string "days_of_operation"
    t.bigint "unique_hop_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unique_hop_route_id"], name: "index_ae_flight_hop_schedule_collectives_on_unique_hop_route_id"
  end

  create_table "ae_flight_hop_ticket_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "dep_time"
    t.string "arr_time"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.string "dep_airport_code"
    t.string "arr_airport_code"
    t.string "mid_city_code"
    t.string "mid_airport_code"
    t.string "mid_country_code"
    t.string "duration"
    t.string "first_flight_no"
    t.string "second_flight_no"
    t.string "first_carrier_code"
    t.string "second_carrier_code"
    t.string "days_of_operation"
    t.bigint "unique_hop_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dep_city_code", "arr_city_code", "carrier_code"], name: "cities"
    t.index ["unique_hop_route_id"], name: "index_ae_flight_hop_ticket_collectives_on_unique_hop_route_id"
  end

  create_table "ae_flight_schedule_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code", limit: 4
    t.integer "flight_no"
    t.string "dep_time"
    t.string "arr_time"
    t.string "duration"
    t.string "days_of_operation"
    t.string "dep_city_code", limit: 3
    t.string "arr_city_code", limit: 3
    t.string "dep_country_code", limit: 3
    t.string "arr_country_code", limit: 3
    t.bigint "unique_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["carrier_code", "dep_city_code", "arr_city_code", "dep_country_code", "arr_country_code"], name: "flight_schedule_collective_idx"
    t.index ["unique_route_id"], name: "index_ae_flight_schedule_collectives_on_unique_route_id"
  end

  create_table "ae_flight_ticket_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.integer "flight_no"
    t.string "dep_time"
    t.string "arr_time"
    t.string "duration"
    t.string "days_of_operation"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.bigint "unique_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unique_route_id"], name: "index_ae_flight_ticket_collectives_on_unique_route_id"
  end

  create_table "ae_footers", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "id", null: false
    t.string "city_code"
    t.string "city_name"
    t.string "country_code"
    t.string "country_name"
    t.integer "total_routes_count"
    t.text "routes_data"
    t.integer "current_routes_count"
    t.string "city_name_ar"
    t.text "routes_data_ar"
    t.text "volume_routes_en"
    t.text "volume_routes_ar"
  end

  create_table "ae_from_to_contents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "city_code"
    t.text "en_from_content"
    t.text "en_to_content"
    t.text "ar_from_content"
    t.text "ar_to_content"
    t.string "city_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ae_hotel_apis", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "city_name"
    t.string "country_code"
    t.string "country_name"
    t.text "hotel_data", limit: 4294967295
    t.text "properties", limit: 4294967295
    t.text "star_data", limit: 4294967295
    t.text "local_cities_data", limit: 4294967295
    t.text "local_activities", limit: 4294967295
    t.text "featured_hotels", limit: 4294967295
    t.text "chain_hotels", limit: 4294967295
    t.text "wayto_go", limit: 4294967295
    t.integer "current_iteration_count"
    t.integer "total_iteration_count"
    t.integer "local_activities_total"
    t.integer "local_activities_current"
  end

  create_table "ae_volume_routes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_city_name_en"
    t.string "arr_city_name_en"
    t.string "dep_city_name_ar"
    t.string "arr_city_name_ar"
    t.string "url"
    t.integer "volume_count"
  end

  create_table "airline_brand_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "carrier_name"
    t.string "flight_no"
    t.string "dep_time"
    t.string "arr_time"
    t.string "duration"
    t.string "days_of_operation"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.bigint "unique_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["carrier_code", "carrier_name"], name: "indecies"
    t.index ["carrier_code", "carrier_name"], name: "indicies"
    t.index ["unique_route_id"], name: "index_airline_brand_collectives_on_unique_route_id"
  end

  create_table "airline_brands", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "carrier_name"
    t.string "icoa_code"
    t.string "base_airport"
    t.string "country"
    t.integer "brand_routes_count"
    t.string "country_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "publish_status"
    t.string "carrier_name_ar"
    t.string "carrier_name_hi"
    t.string "pnr_link"
    t.string "web_checkin_link"
    t.string "tag_line"
    t.string "url"
  end

  create_table "airline_footers", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "id", null: false
    t.text "airline_footer_en", limit: 4294967295
    t.text "airline_footer_ar", limit: 4294967295
    t.text "airline_footer_en_dup", limit: 4294967295
    t.text "airline_footer_ar_dup", limit: 4294967295
    t.integer "current_count"
  end

  create_table "airline_unique_routes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "carrier_name"
    t.string "carrier_name_ar"
    t.string "dep_city_name"
    t.string "dep_city_name_ar"
    t.string "arr_city_name"
    t.string "arr_city_name_ar"
    t.string "url_format"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.integer "flight_count"
    t.string "status"
  end

  create_table "airports", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "airport_code", limit: 3
    t.string "airport_name"
    t.string "city_code"
    t.string "city_name"
    t.string "country_code"
    t.string "country_name"
    t.string "address"
    t.string "phone"
    t.string "email"
    t.string "website"
    t.string "latitude"
    t.string "longitude"
    t.string "airport_type"
    t.string "wikipedia_link"
    t.string "year_of_establishment"
    t.integer "seq_order"
    t.boolean "is_published"
    t.integer "airport_routes_count"
    t.text "index_content"
    t.boolean "is_index"
    t.float "arr_latitude", limit: 53
    t.float "arr_langitude", limit: 53
    t.string "airport_name_ar"
    t.text "address_ar"
  end

  create_table "bh_airline_brand_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "carrier_name"
    t.string "flight_no"
    t.string "dep_time"
    t.string "arr_time"
    t.string "duration"
    t.string "days_of_operation"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.bigint "unique_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["carrier_code", "carrier_name"], name: "indecies"
    t.index ["carrier_code", "carrier_name"], name: "indicies"
    t.index ["unique_route_id"], name: "index_bh_airline_brand_collectives_on_unique_route_id"
  end

  create_table "bh_airline_contents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "carrier_name"
    t.string "country_code"
    t.string "icoa_code"
    t.string "meta_title_en"
    t.string "meta_title_ar"
    t.string "meta_description_en"
    t.string "meta_description_ar"
    t.text "overview_content_en", limit: 4294967295
    t.text "overview_content_ar", limit: 4294967295
    t.text "baggage_content_en", limit: 4294967295
    t.text "baggage_content_ar", limit: 4294967295
    t.text "cancellation_content_en", limit: 4294967295
    t.text "cancellation_content_ar", limit: 4294967295
    t.text "customer_support_content_en", limit: 4294967295
    t.text "customer_support_content_ar", limit: 4294967295
    t.text "pnr_content_en", limit: 4294967295
    t.text "pnr_content_ar", limit: 4294967295
    t.text "web_checkin_content_en", limit: 4294967295
    t.text "web_checkin_content_ar", limit: 4294967295
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "overview_keywords_en"
    t.text "overview_keywords_ar"
    t.text "travel_document_ar", limit: 4294967295
    t.text "travel_document_en", limit: 4294967295
    t.text "special_assistance_ar", limit: 4294967295
    t.text "special_assistance_en", limit: 4294967295
  end

  create_table "bh_airline_footers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "airline_footer_en", limit: 4294967295
    t.text "airline_footer_ar", limit: 4294967295
    t.text "airline_footer_en_dup", limit: 4294967295
    t.text "airline_footer_ar_dup", limit: 4294967295
    t.integer "current_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bh_flight_hop_schedule_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "dep_time"
    t.string "arr_time"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.string "dep_airport_code"
    t.string "arr_airport_code"
    t.string "mid_city_code"
    t.string "mid_airport_code"
    t.string "mid_country_code"
    t.string "duration"
    t.integer "first_flight_no"
    t.integer "second_flight_no"
    t.string "first_carrier_code"
    t.string "second_carrier_code"
    t.string "days_of_operation"
    t.bigint "unique_hop_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unique_hop_route_id"], name: "index_bh_flight_hop_schedule_collectives_on_unique_hop_route_id"
  end

  create_table "bh_flight_hop_ticket_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "dep_time"
    t.string "arr_time"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.string "dep_airport_code"
    t.string "arr_airport_code"
    t.string "mid_city_code"
    t.string "mid_airport_code"
    t.string "mid_country_code"
    t.string "duration"
    t.string "first_flight_no"
    t.string "second_flight_no"
    t.string "first_carrier_code"
    t.string "second_carrier_code"
    t.string "days_of_operation"
    t.bigint "unique_hop_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dep_city_code", "arr_city_code", "carrier_code"], name: "cities"
    t.index ["unique_hop_route_id"], name: "index_bh_flight_hop_ticket_collectives_on_unique_hop_route_id"
  end

  create_table "bh_flight_schedule_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.integer "flight_no"
    t.string "dep_time"
    t.string "arr_time"
    t.string "duration"
    t.string "days_of_operation"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.bigint "unique_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unique_route_id"], name: "index_bh_flight_schedule_collectives_on_unique_route_id"
  end

  create_table "bh_flight_ticket_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.integer "flight_no"
    t.string "dep_time"
    t.string "arr_time"
    t.string "duration"
    t.string "days_of_operation"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.bigint "unique_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unique_route_id"], name: "index_bh_flight_ticket_collectives_on_unique_route_id"
  end

  create_table "bh_footers", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "id", null: false
    t.string "city_code"
    t.string "city_name"
    t.string "country_code"
    t.string "country_name"
    t.integer "total_routes_count"
    t.text "routes_data"
    t.integer "current_routes_count"
    t.string "city_name_ar"
    t.text "routes_data_ar"
    t.text "volume_routes_en"
    t.text "volume_routes_ar"
  end

  create_table "bh_from_to_contents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "city_code"
    t.text "en_from_content"
    t.text "en_to_content"
    t.text "ar_from_content"
    t.text "ar_to_content"
    t.string "city_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bh_hotel_apis", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "city_name"
    t.string "country_code"
    t.string "country_name"
    t.text "hotel_data", limit: 4294967295
    t.text "properties", limit: 4294967295
    t.text "star_data", limit: 4294967295
    t.text "local_cities_data", limit: 4294967295
    t.text "local_activities", limit: 4294967295
    t.text "featured_hotels", limit: 4294967295
    t.text "chain_hotels", limit: 4294967295
    t.text "wayto_go", limit: 4294967295
    t.integer "current_iteration_count"
    t.integer "total_iteration_count"
    t.integer "local_activities_total"
    t.integer "local_activities_current"
  end

  create_table "bh_volume_routes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_city_name_en"
    t.string "arr_city_name_en"
    t.string "dep_city_name_ar"
    t.string "arr_city_name_ar"
    t.string "url"
    t.integer "volume_count"
  end

  create_table "calendars", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "source_city_code"
    t.string "destination_city_code"
    t.text "calendar_json", limit: 4294967295
    t.string "section"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "is_updated"
    t.boolean "price_exists"
  end

  create_table "city_contents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "city_code"
    t.string "city_name_en"
    t.string "city_name_ar"
    t.string "city_name_hi"
    t.text "content_in_en"
    t.text "content_ae_en"
    t.text "content_sa_en"
    t.text "content_bh_en"
    t.text "content_kw_en"
    t.text "content_qa_en"
    t.text "content_om_en"
    t.text "content_in_hi"
    t.text "content_ae_ar"
    t.text "content_sa_ar"
    t.text "content_bh_ar"
    t.text "content_kw_ar"
    t.text "content_qa_ar"
    t.text "content_om_ar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "city_names", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "city_code"
    t.string "city_name_en"
    t.string "city_name_ar"
    t.string "city_name_hi"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "from_url"
    t.string "to_url"
    t.string "country_code"
  end

  create_table "collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "operational_airlines"
    t.string "airline_flight_count"
    t.bigint "unique_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unique_route_id"], name: "index_collectives_on_unique_route_id"
  end

  create_table "commons", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "title"
    t.text "description"
    t.text "keyword"
    t.text "og_title"
    t.text "og_description"
    t.text "heading"
    t.text "content", limit: 4294967295
    t.string "page_type"
    t.string "language"
    t.string "page_subtype"
    t.string "domain"
    t.string "section"
    t.boolean "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_approved"
    t.string "edit_status", limit: 30
    t.string "created_status", limit: 30
    t.text "faq_object", limit: 4294967295
    t.text "reviews_object", limit: 4294967295
    t.text "last_modified_list", limit: 4294967295
  end

  create_table "fare_calendars", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "source_city_code"
    t.string "destination_city_code"
    t.text "calendar_json", limit: 4294967295
    t.string "section"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "is_updated"
    t.boolean "price_exists"
  end

  create_table "flight_sections", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "table_name"
    t.string "edit_status"
    t.string "created_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "flights_headers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_city_name"
    t.string "arr_city_name"
    t.string "hop"
    t.string "page_type"
    t.string "route_type"
    t.string "language"
    t.text "hotel_details", limit: 4294967295
    t.text "train_details", limit: 4294967295
    t.text "tourism_details", limit: 4294967295
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
  end

  create_table "footers", id: :integer, default: nil, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "city_code"
    t.string "city_name"
    t.string "country_code"
    t.string "country_name"
    t.integer "total_routes_count"
    t.text "routes_data"
    t.integer "current_routes_count"
    t.string "city_name_ar"
    t.text "routes_data_ar"
    t.datetime "updated_at"
  end

  create_table "headers", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_city_name"
    t.string "arr_city_name"
    t.string "route_type"
    t.string "dep_city_event"
    t.string "dep_city_weekend_getaway"
    t.string "dep_city_package"
    t.string "dep_city_featured"
    t.string "dep_city_things_todo"
    t.string "arr_city_event"
    t.string "arr_city_weekend_getaway"
    t.string "arr_city_package"
    t.string "arr_city_featured"
    t.string "arr_city_things_todo"
    t.text "hotel_details", limit: 4294967295
    t.text "trains_details", limit: 4294967295
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "header_status"
  end

  create_table "in_airline_brand_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "carrier_name"
    t.string "flight_no"
    t.string "dep_time"
    t.string "arr_time"
    t.string "duration"
    t.string "days_of_operation"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.bigint "unique_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["carrier_code", "carrier_name"], name: "indecies"
    t.index ["carrier_code", "carrier_name"], name: "indicies"
    t.index ["unique_route_id"], name: "index_in_airline_brand_collectives_on_unique_route_id"
  end

  create_table "in_airline_contents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "carrier_name"
    t.string "country_code"
    t.string "icoa_code"
    t.string "meta_title_en"
    t.string "meta_title_hi"
    t.text "meta_description_en"
    t.text "meta_description_hi"
    t.text "overview_content_en", limit: 4294967295
    t.text "overview_content_hi", limit: 4294967295
    t.text "baggage_content_en", limit: 4294967295
    t.text "baggage_content_hi", limit: 4294967295
    t.text "cancellation_content_en", limit: 4294967295
    t.text "cancellation_content_hi", limit: 4294967295
    t.text "customer_support_content_en", limit: 4294967295
    t.text "customer_support_content_hi", limit: 4294967295
    t.text "pnr_content_en", limit: 4294967295
    t.text "pnr_content_hi", limit: 4294967295
    t.text "web_checkin_content_en", limit: 4294967295
    t.text "web_checkin_content_hi", limit: 4294967295
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "special_assistance_en"
    t.text "special_assistance_ar"
    t.text "travel_document_en"
    t.text "travel_document_ar"
  end

  create_table "in_airline_footers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "airline_footer_en", limit: 4294967295
    t.text "airline_footer_ar", limit: 4294967295
    t.text "airline_footer_en_dup", limit: 4294967295
    t.text "airline_footer_ar_dup", limit: 4294967295
    t.integer "current_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "in_airline_route_schedules", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.integer "flight_no"
    t.string "dep_time"
    t.string "arr_time"
    t.string "duration"
    t.string "days_of_operation"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.bigint "airline_unique_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["airline_unique_route_id"], name: "index_in_airline_route_schedules_on_airline_unique_route_id"
  end

  create_table "in_flight_hop_schedule_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "dep_time"
    t.string "arr_time"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.string "dep_airport_code"
    t.string "arr_airport_code"
    t.string "mid_city_code"
    t.string "mid_airport_code"
    t.string "mid_country_code"
    t.string "duration"
    t.integer "first_flight_no"
    t.integer "second_flight_no"
    t.string "first_carrier_code"
    t.string "second_carrier_code"
    t.string "days_of_operation"
    t.bigint "unique_hop_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unique_hop_route_id"], name: "index_in_flight_hop_schedule_collectives_on_unique_hop_route_id"
  end

  create_table "in_flight_hop_ticket_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "dep_time"
    t.string "arr_time"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.string "dep_airport_code"
    t.string "arr_airport_code"
    t.string "mid_city_code"
    t.string "mid_airport_code"
    t.string "mid_country_code"
    t.string "duration"
    t.string "first_flight_no"
    t.string "second_flight_no"
    t.string "first_carrier_code"
    t.string "second_carrier_code"
    t.string "days_of_operation"
    t.bigint "unique_hop_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dep_city_code", "arr_city_code", "carrier_code"], name: "cities"
    t.index ["unique_hop_route_id"], name: "index_in_flight_hop_ticket_collectives_on_unique_hop_route_id"
  end

  create_table "in_flight_schedule_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code", limit: 4
    t.integer "flight_no"
    t.string "dep_time"
    t.string "arr_time"
    t.string "duration"
    t.string "days_of_operation"
    t.string "dep_city_code", limit: 3
    t.string "arr_city_code", limit: 3
    t.string "dep_country_code", limit: 3
    t.string "arr_country_code", limit: 3
    t.bigint "unique_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["carrier_code", "dep_city_code", "arr_city_code", "dep_country_code", "arr_country_code"], name: "in_flight_schedule_collective_idx"
    t.index ["unique_route_id"], name: "index_in_flight_schedule_collectives_on_unique_route_id"
  end

  create_table "in_flight_ticket_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.integer "flight_no"
    t.string "dep_time"
    t.string "arr_time"
    t.string "duration"
    t.string "days_of_operation"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.bigint "unique_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unique_route_id"], name: "index_in_flight_ticket_collectives_on_unique_route_id"
  end

  create_table "in_footers", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "id", null: false
    t.string "city_code"
    t.string "city_name"
    t.string "country_code"
    t.string "country_name"
    t.integer "total_routes_count"
    t.text "routes_data"
    t.integer "current_routes_count"
    t.string "city_name_ar"
    t.text "routes_data_ar"
    t.text "volume_routes_en"
    t.text "volume_routes_ar"
  end

  create_table "in_from_to_contents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "city_code"
    t.text "en_from_content", limit: 4294967295
    t.text "en_to_content", limit: 4294967295
    t.text "hi_from_content", limit: 4294967295
    t.text "hi_to_content", limit: 4294967295
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "city_name"
  end

  create_table "in_hotel_apis", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "city_name"
    t.string "country_code"
    t.string "country_name"
    t.text "hotel_data", limit: 4294967295
    t.text "properties", limit: 4294967295
    t.text "star_data", limit: 4294967295
    t.text "local_cities_data", limit: 4294967295
    t.text "local_activities", limit: 4294967295
    t.text "featured_hotels", limit: 4294967295
    t.text "chain_hotels", limit: 4294967295
    t.text "wayto_go", limit: 4294967295
    t.integer "current_iteration_count"
    t.integer "total_iteration_count"
    t.integer "local_activities_total"
    t.integer "local_activities_current"
  end

  create_table "in_volume_routes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_city_name_en"
    t.string "arr_city_name_en"
    t.string "dep_city_name_ar"
    t.string "arr_city_name_ar"
    t.string "url"
    t.integer "volume_count"
  end

  create_table "kw_airline_brand_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "carrier_name"
    t.string "flight_no"
    t.string "dep_time"
    t.string "arr_time"
    t.string "duration"
    t.string "days_of_operation"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.bigint "unique_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["carrier_code", "carrier_name"], name: "indecies"
    t.index ["carrier_code", "carrier_name"], name: "indicies"
    t.index ["unique_route_id"], name: "index_kw_airline_brand_collectives_on_unique_route_id"
  end

  create_table "kw_airline_contents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "carrier_name"
    t.string "country_code"
    t.string "icoa_code"
    t.string "meta_title_en"
    t.string "meta_title_ar"
    t.string "meta_description_en"
    t.string "meta_description_ar"
    t.text "overview_content_en", limit: 4294967295
    t.text "overview_content_ar", limit: 4294967295
    t.text "baggage_content_en", limit: 4294967295
    t.text "baggage_content_ar", limit: 4294967295
    t.text "cancellation_content_en", limit: 4294967295
    t.text "cancellation_content_ar", limit: 4294967295
    t.text "customer_support_content_en", limit: 4294967295
    t.text "customer_support_content_ar", limit: 4294967295
    t.text "pnr_content_en", limit: 4294967295
    t.text "pnr_content_ar", limit: 4294967295
    t.text "web_checkin_content_en", limit: 4294967295
    t.text "web_checkin_content_ar", limit: 4294967295
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "overview_keywords_en"
    t.text "overview_keywords_ar"
    t.text "special_assistance_ar", limit: 4294967295
    t.text "special_assistance_en", limit: 4294967295
    t.text "travel_document_en", limit: 4294967295
    t.text "travel_document_ar", limit: 4294967295
  end

  create_table "kw_airline_footers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "airline_footer_en", limit: 4294967295
    t.text "airline_footer_ar", limit: 4294967295
    t.text "airline_footer_en_dup", limit: 4294967295
    t.text "airline_footer_ar_dup", limit: 4294967295
    t.integer "current_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "kw_airline_route_schedules", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.integer "flight_no"
    t.string "dep_time"
    t.string "arr_time"
    t.string "duration"
    t.string "days_of_operation"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.bigint "airline_unique_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["airline_unique_route_id"], name: "index_kw_airline_route_schedules_on_airline_unique_route_id"
  end

  create_table "kw_flight_hop_schedule_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "dep_time"
    t.string "arr_time"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.string "dep_airport_code"
    t.string "arr_airport_code"
    t.string "mid_city_code"
    t.string "mid_airport_code"
    t.string "mid_country_code"
    t.string "duration"
    t.integer "first_flight_no"
    t.integer "second_flight_no"
    t.string "first_carrier_code"
    t.string "second_carrier_code"
    t.string "days_of_operation"
    t.bigint "unique_hop_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unique_hop_route_id"], name: "index_kw_flight_hop_schedule_collectives_on_unique_hop_route_id"
  end

  create_table "kw_flight_hop_ticket_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "dep_time"
    t.string "arr_time"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.string "dep_airport_code"
    t.string "arr_airport_code"
    t.string "mid_city_code"
    t.string "mid_airport_code"
    t.string "mid_country_code"
    t.string "duration"
    t.string "first_flight_no"
    t.string "second_flight_no"
    t.string "first_carrier_code"
    t.string "second_carrier_code"
    t.string "days_of_operation"
    t.bigint "unique_hop_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dep_city_code", "arr_city_code", "carrier_code"], name: "cities"
    t.index ["unique_hop_route_id"], name: "index_kw_flight_hop_ticket_collectives_on_unique_hop_route_id"
  end

  create_table "kw_flight_schedule_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code", limit: 4
    t.integer "flight_no"
    t.string "dep_time"
    t.string "arr_time"
    t.string "duration"
    t.string "days_of_operation"
    t.string "dep_city_code", limit: 3
    t.string "arr_city_code", limit: 3
    t.string "dep_country_code", limit: 3
    t.string "arr_country_code", limit: 3
    t.bigint "unique_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["carrier_code", "dep_city_code", "arr_city_code", "dep_country_code", "arr_country_code"], name: "kw_flight_schedule_collective_idx"
    t.index ["unique_route_id"], name: "index_kw_flight_schedule_collectives_on_unique_route_id"
  end

  create_table "kw_flight_ticket_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.integer "flight_no"
    t.string "dep_time"
    t.string "arr_time"
    t.string "duration"
    t.string "days_of_operation"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.bigint "unique_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unique_route_id"], name: "index_kw_flight_ticket_collectives_on_unique_route_id"
  end

  create_table "kw_footers", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "id", null: false
    t.string "city_code"
    t.string "city_name"
    t.string "country_code"
    t.string "country_name"
    t.integer "total_routes_count"
    t.text "routes_data"
    t.integer "current_routes_count"
    t.string "city_name_ar"
    t.text "routes_data_ar"
    t.text "volume_routes_en"
    t.text "volume_routes_ar"
  end

  create_table "kw_from_to_contents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "city_code"
    t.text "en_from_content"
    t.text "en_to_content"
    t.text "ar_from_content"
    t.text "ar_to_content"
    t.string "city_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "kw_hotel_apis", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "city_name"
    t.string "country_code"
    t.string "country_name"
    t.text "hotel_data", limit: 4294967295
    t.text "properties", limit: 4294967295
    t.text "star_data", limit: 4294967295
    t.text "local_cities_data", limit: 4294967295
    t.text "local_activities", limit: 4294967295
    t.text "featured_hotels", limit: 4294967295
    t.text "chain_hotels", limit: 4294967295
    t.text "wayto_go", limit: 4294967295
    t.integer "current_iteration_count"
    t.integer "total_iteration_count"
    t.integer "local_activities_total"
    t.integer "local_activities_current"
  end

  create_table "kw_volume_routes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_city_name_en"
    t.string "arr_city_name_en"
    t.string "dep_city_name_ar"
    t.string "arr_city_name_ar"
    t.string "url"
    t.integer "volume_count"
  end

  create_table "om_airline_brand_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "carrier_name"
    t.string "flight_no"
    t.string "dep_time"
    t.string "arr_time"
    t.string "duration"
    t.string "days_of_operation"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.bigint "unique_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["carrier_code", "carrier_name"], name: "indecies"
    t.index ["carrier_code", "carrier_name"], name: "indicies"
    t.index ["unique_route_id"], name: "index_om_airline_brand_collectives_on_unique_route_id"
  end

  create_table "om_airline_contents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "carrier_name"
    t.string "country_code"
    t.string "icoa_code"
    t.string "meta_title_en"
    t.string "meta_title_ar"
    t.string "meta_description_en"
    t.string "meta_description_ar"
    t.text "overview_content_en", limit: 4294967295
    t.text "overview_content_ar", limit: 4294967295
    t.text "baggage_content_en", limit: 4294967295
    t.text "baggage_content_ar", limit: 4294967295
    t.text "cancellation_content_en", limit: 4294967295
    t.text "cancellation_content_ar", limit: 4294967295
    t.text "customer_support_content_en", limit: 4294967295
    t.text "customer_support_content_ar", limit: 4294967295
    t.text "pnr_content_en", limit: 4294967295
    t.text "pnr_content_ar", limit: 4294967295
    t.text "web_checkin_content_en", limit: 4294967295
    t.text "web_checkin_content_ar", limit: 4294967295
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "overview_keywords_en"
    t.text "overview_keywords_ar"
    t.text "travel_document_ar", limit: 4294967295
    t.text "travel_document_en", limit: 4294967295
    t.text "special_assistance_en", limit: 4294967295
    t.text "special_assistance_ar", limit: 4294967295
  end

  create_table "om_airline_footers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "airline_footer_en", limit: 4294967295
    t.text "airline_footer_ar", limit: 4294967295
    t.text "airline_footer_en_dup", limit: 4294967295
    t.text "airline_footer_ar_dup", limit: 4294967295
    t.integer "current_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "om_airline_route_schedules", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.integer "flight_no"
    t.string "dep_time"
    t.string "arr_time"
    t.string "duration"
    t.string "days_of_operation"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.bigint "airline_unique_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["airline_unique_route_id"], name: "index_om_airline_route_schedules_on_airline_unique_route_id"
  end

  create_table "om_flight_hop_schedule_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "dep_time"
    t.string "arr_time"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.string "dep_airport_code"
    t.string "arr_airport_code"
    t.string "mid_city_code"
    t.string "mid_airport_code"
    t.string "mid_country_code"
    t.string "duration"
    t.integer "first_flight_no"
    t.integer "second_flight_no"
    t.string "first_carrier_code"
    t.string "second_carrier_code"
    t.string "days_of_operation"
    t.bigint "unique_hop_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unique_hop_route_id"], name: "index_om_flight_hop_schedule_collectives_on_unique_hop_route_id"
  end

  create_table "om_flight_hop_ticket_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "dep_time"
    t.string "arr_time"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.string "dep_airport_code"
    t.string "arr_airport_code"
    t.string "mid_city_code"
    t.string "mid_airport_code"
    t.string "mid_country_code"
    t.string "duration"
    t.string "first_flight_no"
    t.string "second_flight_no"
    t.string "first_carrier_code"
    t.string "second_carrier_code"
    t.string "days_of_operation"
    t.bigint "unique_hop_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dep_city_code", "arr_city_code", "carrier_code"], name: "cities"
    t.index ["unique_hop_route_id"], name: "index_om_flight_hop_ticket_collectives_on_unique_hop_route_id"
  end

  create_table "om_flight_schedule_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code", limit: 4
    t.integer "flight_no"
    t.string "dep_time"
    t.string "arr_time"
    t.string "duration"
    t.string "days_of_operation"
    t.string "dep_city_code", limit: 3
    t.string "arr_city_code", limit: 3
    t.string "dep_country_code", limit: 3
    t.string "arr_country_code", limit: 3
    t.bigint "unique_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["carrier_code", "dep_city_code", "arr_city_code", "dep_country_code", "arr_country_code"], name: "om_flight_schedule_collective_idx"
    t.index ["unique_route_id"], name: "index_om_flight_schedule_collectives_on_unique_route_id"
  end

  create_table "om_flight_ticket_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.integer "flight_no"
    t.string "dep_time"
    t.string "arr_time"
    t.string "duration"
    t.string "days_of_operation"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.bigint "unique_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unique_route_id"], name: "index_om_flight_ticket_collectives_on_unique_route_id"
  end

  create_table "om_footers", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "id", null: false
    t.string "city_code"
    t.string "city_name"
    t.string "country_code"
    t.string "country_name"
    t.integer "total_routes_count"
    t.text "routes_data"
    t.integer "current_routes_count"
    t.string "city_name_ar"
    t.text "routes_data_ar"
    t.text "volume_routes_en"
    t.text "volume_routes_ar"
  end

  create_table "om_from_to_contents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "city_code"
    t.text "en_from_content"
    t.text "en_to_content"
    t.text "ar_from_content"
    t.text "ar_to_content"
    t.string "city_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "om_hotel_apis", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "city_name"
    t.string "country_code"
    t.string "country_name"
    t.text "hotel_data", limit: 4294967295
    t.text "properties", limit: 4294967295
    t.text "star_data", limit: 4294967295
    t.text "local_cities_data", limit: 4294967295
    t.text "local_activities", limit: 4294967295
    t.text "featured_hotels", limit: 4294967295
    t.text "chain_hotels", limit: 4294967295
    t.text "wayto_go", limit: 4294967295
    t.integer "current_iteration_count"
    t.integer "total_iteration_count"
    t.integer "local_activities_total"
    t.integer "local_activities_current"
  end

  create_table "om_volume_routes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_city_name_en"
    t.string "arr_city_name_en"
    t.string "dep_city_name_ar"
    t.string "arr_city_name_ar"
    t.string "url"
    t.integer "volume_count"
  end

  create_table "package_flight_hop_schedules", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "dep_city_code"
    t.string "dep_airport_code"
    t.string "dep_city_name"
    t.string "arr_city_code"
    t.string "arr_airport_code"
    t.string "arr_city_name"
    t.date "effective_from"
    t.date "effective_to"
    t.string "day_of_operation", limit: 7
    t.integer "arrival_day_marker"
    t.string "elapsed_journey_time"
    t.string "dep_time"
    t.string "arr_time"
    t.integer "flight_count"
    t.integer "distance"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.string "l1_dep_city_code"
    t.string "l1_dep_city_name"
    t.string "l1_dep_airport_code"
    t.string "l1_arr_city_code"
    t.string "l1_arr_city_name"
    t.string "l1_arr_airport_code"
    t.string "l1_carrier_code"
    t.string "l1_carrier_brand"
    t.string "l1_flight_no"
    t.date "l1_effective_from"
    t.date "l1_effective_to"
    t.string "l1_day_of_operation", limit: 7
    t.string "l1_dep_time"
    t.string "l1_arr_time"
    t.integer "l1_arrival_day_marker"
    t.string "l1_elapsed_journey_time", limit: 20
    t.integer "l1_stop"
    t.integer "l1_distance"
    t.string "l1_dep_country_code"
    t.string "l1_arr_country_code"
    t.integer "l1_flight_count"
    t.string "l2_dep_city_code"
    t.string "l2_dep_city_name"
    t.string "l2_dep_airport_code"
    t.string "l2_arr_city_code"
    t.string "l2_arr_city_name"
    t.string "l2_arr_airport_code"
    t.string "l2_carrier_code"
    t.string "l2_carrier_brand"
    t.string "l2_flight_no"
    t.date "l2_effective_from"
    t.date "l2_effective_to"
    t.string "l2_day_of_operation", limit: 7
    t.string "l2_dep_time"
    t.string "l2_arr_time"
    t.integer "l2_arrival_day_marker"
    t.string "l2_elapsed_journey_time", limit: 20
    t.integer "l2_stop"
    t.integer "l2_distance"
    t.integer "l2_flight_count"
    t.string "l2_dep_country_code"
    t.string "l2_arr_country_code"
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "carrier_code"
    t.string "carrier_brand"
    t.index ["dep_city_code", "arr_city_code", "l1_arr_city_code"], name: "cities"
  end

  create_table "package_flight_schedules", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "carrier_brand"
    t.string "carrier_logo"
    t.string "flight_no"
    t.string "dep_airport_code"
    t.string "dep_city_code"
    t.string "dep_city_name"
    t.string "dep_country_code"
    t.string "arr_airport_code"
    t.string "arr_city_code"
    t.string "arr_city_name"
    t.string "arr_country_code"
    t.string "dep_time"
    t.string "arr_time"
    t.integer "arrival_day_marker"
    t.string "elapsed_journey_time"
    t.integer "flight_count"
    t.date "effective_from"
    t.date "effective_to"
    t.string "day_of_operation"
    t.integer "stop"
    t.string "intermediate_airports"
    t.string "full_routing"
    t.string "is_active"
    t.string "brand_type"
    t.integer "weekly_count"
    t.string "icoa_code"
    t.string "data_source"
    t.integer "distance"
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["dep_city_code", "arr_city_code", "carrier_code"], name: "indicies"
  end

  create_table "popular_route_infos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "domain"
    t.string "arr_date"
    t.string "dep_date"
    t.text "en_route_info", limit: 4294967295
    t.text "ar_route_info", limit: 4294967295
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "popular_routes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "dep_city_code", limit: 20
    t.string "arr_city_code", limit: 20
    t.string "dep_city_name", limit: 60
    t.string "arr_city_name", limit: 60
    t.string "domain", limit: 20, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "url_format", limit: 60, default: "", null: false
    t.index ["url_format"], name: "url_format"
  end

  create_table "popular_routes_copy", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "dep_city_code", limit: 20
    t.string "arr_city_code", limit: 20
    t.string "dep_city_name", limit: 60
    t.string "arr_city_name", limit: 60
    t.string "domain", limit: 20, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "url_format", limit: 60, default: "", null: false
  end

  create_table "qa_airline_brand_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "carrier_name"
    t.string "flight_no"
    t.string "dep_time"
    t.string "arr_time"
    t.string "duration"
    t.string "days_of_operation"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.bigint "unique_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["carrier_code", "carrier_name"], name: "indecies"
    t.index ["carrier_code", "carrier_name"], name: "indicies"
    t.index ["unique_route_id"], name: "index_qa_airline_brand_collectives_on_unique_route_id"
  end

  create_table "qa_airline_contents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "carrier_name"
    t.string "country_code"
    t.string "icoa_code"
    t.string "meta_title_en"
    t.string "meta_title_ar"
    t.string "meta_description_en"
    t.string "meta_description_ar"
    t.text "overview_content_en", limit: 4294967295
    t.text "overview_content_ar", limit: 4294967295
    t.text "baggage_content_en", limit: 4294967295
    t.text "baggage_content_ar", limit: 4294967295
    t.text "cancellation_content_en", limit: 4294967295
    t.text "cancellation_content_ar", limit: 4294967295
    t.text "customer_support_content_en", limit: 4294967295
    t.text "customer_support_content_ar", limit: 4294967295
    t.text "pnr_content_en", limit: 4294967295
    t.text "pnr_content_ar", limit: 4294967295
    t.text "web_checkin_content_en", limit: 4294967295
    t.text "web_checkin_content_ar", limit: 4294967295
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "overview_keywords_en"
    t.text "overview_keywords_ar"
    t.text "travel_document_ar", limit: 4294967295
    t.text "travel_document_en", limit: 4294967295
    t.text "special_assistance_ar", limit: 4294967295
    t.text "special_assistance_en", limit: 4294967295
  end

  create_table "qa_airline_footers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "airline_footer_en", limit: 4294967295
    t.text "airline_footer_ar", limit: 4294967295
    t.text "airline_footer_en_dup", limit: 4294967295
    t.text "airline_footer_ar_dup", limit: 4294967295
    t.integer "current_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "qa_airline_route_schedules", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.integer "flight_no"
    t.string "dep_time"
    t.string "arr_time"
    t.string "duration"
    t.string "days_of_operation"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.bigint "airline_unique_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["airline_unique_route_id"], name: "index_qa_airline_route_schedules_on_airline_unique_route_id"
  end

  create_table "qa_flight_hop_schedule_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "dep_time"
    t.string "arr_time"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.string "dep_airport_code"
    t.string "arr_airport_code"
    t.string "mid_city_code"
    t.string "mid_airport_code"
    t.string "mid_country_code"
    t.string "duration"
    t.integer "first_flight_no"
    t.integer "second_flight_no"
    t.string "first_carrier_code"
    t.string "second_carrier_code"
    t.string "days_of_operation"
    t.bigint "unique_hop_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unique_hop_route_id"], name: "index_qa_flight_hop_schedule_collectives_on_unique_hop_route_id"
  end

  create_table "qa_flight_hop_ticket_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "dep_time"
    t.string "arr_time"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.string "dep_airport_code"
    t.string "arr_airport_code"
    t.string "mid_city_code"
    t.string "mid_airport_code"
    t.string "mid_country_code"
    t.string "duration"
    t.string "first_flight_no"
    t.string "second_flight_no"
    t.string "first_carrier_code"
    t.string "second_carrier_code"
    t.string "days_of_operation"
    t.bigint "unique_hop_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dep_city_code", "arr_city_code", "carrier_code"], name: "cities"
    t.index ["unique_hop_route_id"], name: "index_qa_flight_hop_ticket_collectives_on_unique_hop_route_id"
  end

  create_table "qa_flight_schedule_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code", limit: 4
    t.integer "flight_no"
    t.string "dep_time"
    t.string "arr_time"
    t.string "duration"
    t.string "days_of_operation"
    t.string "dep_city_code", limit: 3
    t.string "arr_city_code", limit: 3
    t.string "dep_country_code", limit: 3
    t.string "arr_country_code", limit: 3
    t.bigint "unique_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["carrier_code", "dep_city_code", "arr_city_code", "dep_country_code", "arr_country_code"], name: "qa_flight_schedule_collective_idx"
    t.index ["unique_route_id"], name: "index_qa_flight_schedule_collectives_on_unique_route_id"
  end

  create_table "qa_flight_ticket_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.integer "flight_no"
    t.string "dep_time"
    t.string "arr_time"
    t.string "duration"
    t.string "days_of_operation"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.bigint "unique_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unique_route_id"], name: "index_qa_flight_ticket_collectives_on_unique_route_id"
  end

  create_table "qa_footers", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "id", null: false
    t.string "city_code"
    t.string "city_name"
    t.string "country_code"
    t.string "country_name"
    t.integer "total_routes_count"
    t.text "routes_data"
    t.integer "current_routes_count"
    t.string "city_name_ar"
    t.text "routes_data_ar"
    t.text "volume_routes_en"
    t.text "volume_routes_ar"
  end

  create_table "qa_from_to_contents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "city_code"
    t.text "en_from_content"
    t.text "en_to_content"
    t.text "ar_from_content"
    t.text "ar_to_content"
    t.string "city_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "qa_hotel_apis", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "city_name"
    t.string "country_code"
    t.string "country_name"
    t.text "hotel_data", limit: 4294967295
    t.text "properties", limit: 4294967295
    t.text "star_data", limit: 4294967295
    t.text "local_cities_data", limit: 4294967295
    t.text "local_activities", limit: 4294967295
    t.text "featured_hotels", limit: 4294967295
    t.text "chain_hotels", limit: 4294967295
    t.text "wayto_go", limit: 4294967295
    t.integer "current_iteration_count"
    t.integer "total_iteration_count"
    t.integer "local_activities_total"
    t.integer "local_activities_current"
  end

  create_table "qa_volume_routes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_city_name_en"
    t.string "arr_city_name_en"
    t.string "dep_city_name_ar"
    t.string "arr_city_name_ar"
    t.string "url"
    t.integer "volume_count"
  end

  create_table "rhs_hotels", id: :integer, default: nil, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.text "city"
    t.integer "current_value"
  end

  create_table "route_details", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.text "template", limit: 4294967295
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "popular_route_id"
    t.index ["popular_route_id"], name: "popular_route_id"
  end

  create_table "route_details_copy", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.text "template", limit: 4294967295
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "popular_route_id"
  end

  create_table "sa_airline_brand_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "carrier_name"
    t.string "flight_no"
    t.string "dep_time"
    t.string "arr_time"
    t.string "duration"
    t.string "days_of_operation"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.bigint "unique_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["carrier_code", "carrier_name"], name: "indecies"
    t.index ["carrier_code", "carrier_name"], name: "indicies"
    t.index ["unique_route_id"], name: "index_sa_airline_brand_collectives_on_unique_route_id"
  end

  create_table "sa_airline_contents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "carrier_name"
    t.string "country_code"
    t.string "icoa_code"
    t.string "meta_title_en"
    t.string "meta_title_ar"
    t.string "meta_description_en"
    t.string "meta_description_ar"
    t.text "overview_content_en", limit: 4294967295
    t.text "overview_content_ar", limit: 4294967295
    t.text "baggage_content_en", limit: 4294967295
    t.text "baggage_content_ar", limit: 4294967295
    t.text "cancellation_content_en", limit: 4294967295
    t.text "cancellation_content_ar", limit: 4294967295
    t.text "customer_support_content_en", limit: 4294967295
    t.text "customer_support_content_ar", limit: 4294967295
    t.text "pnr_content_en", limit: 4294967295
    t.text "pnr_content_ar", limit: 4294967295
    t.text "web_checkin_content_en", limit: 4294967295
    t.text "web_checkin_content_ar", limit: 4294967295
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "overview_keywords_en"
    t.text "overview_keywords_ar"
    t.text "travel_document_ar", limit: 4294967295
    t.text "travel_document_en", limit: 4294967295
    t.text "special_assistance_ar", limit: 4294967295
    t.text "special_assistance_en", limit: 4294967295
  end

  create_table "sa_airline_footers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "airline_footer_en", limit: 4294967295
    t.text "airline_footer_ar", limit: 4294967295
    t.text "airline_footer_en_dup", limit: 4294967295
    t.text "airline_footer_ar_dup", limit: 4294967295
    t.integer "current_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sa_airline_route_schedules", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.integer "flight_no"
    t.string "dep_time"
    t.string "arr_time"
    t.string "duration"
    t.string "days_of_operation"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.bigint "airline_unique_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["airline_unique_route_id"], name: "index_sa_airline_route_schedules_on_airline_unique_route_id"
  end

  create_table "sa_flight_hop_schedule_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "dep_time"
    t.string "arr_time"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.string "dep_airport_code"
    t.string "arr_airport_code"
    t.string "mid_city_code"
    t.string "mid_airport_code"
    t.string "mid_country_code"
    t.string "duration"
    t.integer "first_flight_no"
    t.integer "second_flight_no"
    t.string "first_carrier_code"
    t.string "second_carrier_code"
    t.string "days_of_operation"
    t.bigint "unique_hop_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unique_hop_route_id"], name: "index_sa_flight_hop_schedule_collectives_on_unique_hop_route_id"
  end

  create_table "sa_flight_hop_ticket_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "dep_time"
    t.string "arr_time"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.string "dep_airport_code"
    t.string "arr_airport_code"
    t.string "mid_city_code"
    t.string "mid_airport_code"
    t.string "mid_country_code"
    t.string "duration"
    t.string "first_flight_no"
    t.string "second_flight_no"
    t.string "first_carrier_code"
    t.string "second_carrier_code"
    t.string "days_of_operation"
    t.bigint "unique_hop_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dep_city_code", "arr_city_code", "carrier_code"], name: "cities"
    t.index ["unique_hop_route_id"], name: "index_sa_flight_hop_ticket_collectives_on_unique_hop_route_id"
  end

  create_table "sa_flight_schedule_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code", limit: 4
    t.integer "flight_no"
    t.string "dep_time"
    t.string "arr_time"
    t.string "duration"
    t.string "days_of_operation"
    t.string "dep_city_code", limit: 3
    t.string "arr_city_code", limit: 3
    t.string "dep_country_code", limit: 3
    t.string "arr_country_code", limit: 3
    t.bigint "unique_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["carrier_code", "dep_city_code", "arr_city_code", "dep_country_code", "arr_country_code"], name: "kw_flight_schedule_collective_idx"
    t.index ["unique_route_id"], name: "index_sa_flight_schedule_collectives_on_unique_route_id"
  end

  create_table "sa_flight_ticket_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.integer "flight_no"
    t.string "dep_time"
    t.string "arr_time"
    t.string "duration"
    t.string "days_of_operation"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.bigint "unique_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unique_route_id"], name: "index_sa_flight_ticket_collectives_on_unique_route_id"
  end

  create_table "sa_footers", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "id", null: false
    t.string "city_code"
    t.string "city_name"
    t.string "country_code"
    t.string "country_name"
    t.integer "total_routes_count"
    t.text "routes_data"
    t.integer "current_routes_count"
    t.string "city_name_ar"
    t.text "routes_data_ar"
    t.text "volume_routes_en"
    t.text "volume_routes_ar"
  end

  create_table "sa_from_to_contents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "city_code"
    t.text "en_from_content"
    t.text "en_to_content"
    t.text "ar_from_content"
    t.text "ar_to_content"
    t.string "city_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sa_hotel_apis", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "city_name"
    t.string "country_code"
    t.string "country_name"
    t.text "hotel_data", limit: 4294967295
    t.text "properties", limit: 4294967295
    t.text "star_data", limit: 4294967295
    t.text "local_cities_data", limit: 4294967295
    t.text "local_activities", limit: 4294967295
    t.text "featured_hotels", limit: 4294967295
    t.text "chain_hotels", limit: 4294967295
    t.text "wayto_go", limit: 4294967295
    t.integer "current_iteration_count"
    t.integer "total_iteration_count"
    t.integer "local_activities_total"
    t.integer "local_activities_current"
  end

  create_table "sa_volume_routes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_city_name_en"
    t.string "arr_city_name_en"
    t.string "dep_city_name_ar"
    t.string "arr_city_name_ar"
    t.string "url"
    t.integer "volume_count"
  end

  create_table "unique_fb_baggage_customers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "title"
    t.text "description"
    t.text "keyword"
    t.text "og_title"
    t.text "og_description"
    t.text "heading"
    t.text "content", limit: 4294967295
    t.string "airline_name"
    t.string "url"
    t.string "page_type"
    t.string "language"
    t.string "page_subtype"
    t.string "domain"
    t.string "section"
    t.boolean "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "edit_status", limit: 30
    t.string "created_status", limit: 30
    t.boolean "is_approved"
    t.text "faq_object", limit: 4294967295
    t.text "reviews_object", limit: 4294967295
    t.text "last_modified_list", limit: 4294967295
  end

  create_table "unique_fb_overviews", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "title"
    t.text "description"
    t.text "keyword"
    t.text "og_title"
    t.text "og_description"
    t.text "heading"
    t.text "content", limit: 4294967295
    t.string "airline_name"
    t.string "url"
    t.string "page_type"
    t.string "language"
    t.string "page_subtype"
    t.string "domain"
    t.string "section"
    t.boolean "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "review_content", limit: 4294967295
    t.string "edit_status", limit: 30
    t.string "created_status", limit: 30
    t.boolean "is_approved"
    t.text "faq_object", limit: 4294967295
    t.text "reviews_object", limit: 4294967295
    t.text "last_modified_list", limit: 4294967295
  end

  create_table "unique_fb_pnr_webs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "title"
    t.text "description"
    t.text "keyword"
    t.text "og_title"
    t.text "og_description"
    t.text "heading"
    t.text "content", limit: 4294967295
    t.string "airline_name"
    t.string "url"
    t.string "page_type"
    t.string "language"
    t.string "page_subtype"
    t.string "domain"
    t.string "section"
    t.boolean "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "edit_status", limit: 30
    t.string "created_status", limit: 30
    t.boolean "is_approved"
    t.text "faq_object", limit: 4294967295
    t.text "reviews_object", limit: 4294967295
    t.text "last_modified_list", limit: 4294967295
  end

  create_table "unique_fb_routes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "title"
    t.text "description"
    t.text "keyword"
    t.text "og_title"
    t.text "og_description"
    t.text "heading"
    t.text "content", limit: 4294967295
    t.string "source"
    t.string "airline_name"
    t.string "destination"
    t.string "url"
    t.string "page_type"
    t.string "language"
    t.string "page_subtype"
    t.string "domain"
    t.string "section"
    t.boolean "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "edit_status", limit: 30
    t.string "created_status", limit: 30
    t.boolean "is_approved"
    t.text "faq_object", limit: 4294967295
    t.text "reviews_object", limit: 4294967295
    t.text "last_modified_list", limit: 4294967295
  end

  create_table "unique_fs_froms", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "title"
    t.text "description"
    t.text "keyword"
    t.text "og_title"
    t.text "og_description"
    t.text "heading"
    t.text "content", limit: 4294967295
    t.string "city_name"
    t.string "url"
    t.string "page_type"
    t.string "language"
    t.string "page_subtype"
    t.string "domain"
    t.string "section"
    t.boolean "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "edit_status", limit: 30
    t.string "created_status", limit: 30
    t.boolean "is_approved"
    t.text "faq_object", limit: 4294967295
    t.text "reviews_object", limit: 4294967295
    t.text "last_modified_list", limit: 4294967295
  end

  create_table "unique_fs_routes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "title"
    t.text "description"
    t.text "keyword"
    t.text "og_title"
    t.text "og_description"
    t.text "heading"
    t.text "content", limit: 4294967295
    t.string "source"
    t.string "destination"
    t.string "url"
    t.string "page_type"
    t.string "language"
    t.string "page_subtype"
    t.string "domain"
    t.string "section"
    t.boolean "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "edit_status", limit: 30
    t.string "created_status", limit: 30
    t.boolean "is_approved"
    t.text "h2_schedule_title"
    t.text "h2_calendar_title"
    t.text "h2_lowest_fare_title"
    t.text "faq_object", limit: 4294967295
    t.text "reviews_object", limit: 4294967295
    t.text "last_modified_list", limit: 4294967295
  end

  create_table "unique_fs_tos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "title"
    t.text "description"
    t.text "keyword"
    t.text "og_title"
    t.text "og_description"
    t.text "heading"
    t.text "content", limit: 4294967295
    t.string "city_name"
    t.string "url"
    t.string "page_type"
    t.string "language"
    t.string "page_subtype"
    t.string "domain"
    t.string "section"
    t.boolean "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "edit_status", limit: 30
    t.string "created_status", limit: 30
    t.boolean "is_approved"
    t.text "faq_object", limit: 4294967295
    t.text "reviews_object", limit: 4294967295
    t.text "last_modified_list", limit: 4294967295
  end

  create_table "unique_ft_routes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "title"
    t.text "description"
    t.text "keyword"
    t.text "og_title"
    t.text "og_description"
    t.text "heading"
    t.text "content", limit: 4294967295
    t.string "source"
    t.string "destination"
    t.string "url"
    t.string "page_type"
    t.string "language"
    t.string "page_subtype"
    t.string "domain"
    t.string "section"
    t.boolean "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "faq_object", limit: 4294967295
    t.text "reviews_object", limit: 4294967295
    t.text "is_approved", limit: 4294967295
    t.text "last_modified_list", limit: 4294967295
  end

  create_table "unique_hop_routes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "dep_city_code", limit: 3
    t.string "arr_city_code", limit: 3
    t.string "dep_airport_code", limit: 3
    t.string "arr_airport_code", limit: 3
    t.string "dep_country_code", limit: 3
    t.string "arr_country_code", limit: 3
    t.string "dep_city_name"
    t.string "arr_city_name"
    t.integer "hop"
    t.integer "distance"
    t.integer "weekly_flights_count"
    t.integer "total_flights_count"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "dep_city_name_ar"
    t.string "arr_city_name_ar"
    t.string "schedule_route_url"
    t.index ["dep_airport_code", "arr_airport_code", "dep_country_code", "arr_country_code", "dep_city_code", "arr_city_code"], name: "unique_hop_route_idx"
    t.index ["url", "dep_city_code", "arr_city_code"], name: "indicies"
  end

  create_table "unique_routes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "dep_city_code", limit: 3
    t.string "arr_city_code", limit: 3
    t.string "dep_airport_code", limit: 3
    t.string "arr_airport_code", limit: 3
    t.string "dep_country_code", limit: 3
    t.string "arr_country_code", limit: 3
    t.integer "weekly_flights_count"
    t.integer "distance"
    t.integer "hop"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "dep_city_name"
    t.string "arr_city_name"
    t.string "schedule_route_url"
    t.string "ticket_route_url"
    t.string "dep_city_name_ar"
    t.string "arr_city_name_ar"
    t.string "dep_city_name_hi"
    t.string "arr_city_name_hi"
    t.string "source"
    t.index ["dep_airport_code", "arr_airport_code", "dep_country_code", "arr_country_code", "dep_city_code", "arr_city_code"], name: "unique_route_idx"
    t.index ["schedule_route_url", "ticket_route_url", "dep_city_code", "arr_city_code"], name: "indecies"
  end

  add_foreign_key "ae_airline_brand_collectives", "unique_routes", name: "fk_rails_83a2d28fel"
  add_foreign_key "ae_airline_route_schedules", "airline_unique_routes", name: "fk_rails_8e487f41bt"
  add_foreign_key "ae_flight_hop_schedule_collectives", "unique_hop_routes"
  add_foreign_key "ae_flight_hop_ticket_collectives", "unique_hop_routes"
  add_foreign_key "ae_flight_schedule_collectives", "unique_routes"
  add_foreign_key "ae_flight_ticket_collectives", "unique_routes"
  add_foreign_key "airline_brand_collectives", "unique_routes"
  add_foreign_key "bh_airline_brand_collectives", "unique_routes", name: "fk_rails_83a2d28fei"
  add_foreign_key "bh_flight_hop_schedule_collectives", "unique_hop_routes"
  add_foreign_key "bh_flight_hop_ticket_collectives", "unique_hop_routes"
  add_foreign_key "bh_flight_schedule_collectives", "unique_routes"
  add_foreign_key "bh_flight_ticket_collectives", "unique_routes"
  add_foreign_key "collectives", "unique_routes"
  add_foreign_key "in_airline_brand_collectives", "unique_routes", name: "fk_rails_83a2d28fem"
  add_foreign_key "in_airline_route_schedules", "airline_unique_routes", name: "fk_rails_8e487f41bp"
  add_foreign_key "in_flight_hop_schedule_collectives", "unique_hop_routes"
  add_foreign_key "in_flight_hop_ticket_collectives", "unique_hop_routes"
  add_foreign_key "in_flight_schedule_collectives", "unique_routes"
  add_foreign_key "in_flight_ticket_collectives", "unique_routes"
  add_foreign_key "kw_airline_brand_collectives", "unique_routes", name: "fk_rails_83a2d28feh"
  add_foreign_key "kw_airline_route_schedules", "airline_unique_routes", name: "fk_rails_8e487f41bg"
  add_foreign_key "kw_flight_hop_schedule_collectives", "unique_hop_routes"
  add_foreign_key "kw_flight_hop_ticket_collectives", "unique_hop_routes"
  add_foreign_key "kw_flight_schedule_collectives", "unique_routes"
  add_foreign_key "kw_flight_ticket_collectives", "unique_routes"
  add_foreign_key "om_airline_brand_collectives", "unique_routes", name: "fk_rails_83a2d28feg"
  add_foreign_key "om_airline_route_schedules", "airline_unique_routes"
  add_foreign_key "om_flight_hop_schedule_collectives", "unique_hop_routes"
  add_foreign_key "om_flight_hop_ticket_collectives", "unique_hop_routes"
  add_foreign_key "om_flight_schedule_collectives", "unique_routes"
  add_foreign_key "om_flight_ticket_collectives", "unique_routes", name: "fk_rails_620694a11g"
  add_foreign_key "qa_airline_brand_collectives", "unique_routes", name: "fk_rails_83a2d28fej"
  add_foreign_key "qa_airline_route_schedules", "airline_unique_routes", name: "fk_rails_8e487f41br"
  add_foreign_key "qa_flight_hop_schedule_collectives", "unique_hop_routes"
  add_foreign_key "qa_flight_hop_ticket_collectives", "unique_hop_routes"
  add_foreign_key "qa_flight_schedule_collectives", "unique_routes"
  add_foreign_key "qa_flight_ticket_collectives", "unique_routes"
  add_foreign_key "sa_airline_brand_collectives", "unique_routes", name: "fk_rails_83a2d28ffh"
  add_foreign_key "sa_airline_route_schedules", "airline_unique_routes", name: "fk_rails_8e487f41bq"
  add_foreign_key "sa_flight_hop_schedule_collectives", "unique_hop_routes"
  add_foreign_key "sa_flight_hop_ticket_collectives", "unique_hop_routes"
  add_foreign_key "sa_flight_schedule_collectives", "unique_routes"
  add_foreign_key "sa_flight_ticket_collectives", "unique_routes"
end
