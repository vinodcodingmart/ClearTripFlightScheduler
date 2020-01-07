
Rails.application.routes.draw do

	root "flight_schedules#index"
	get '/resp_airjson' => "new_srp#response_json"
	get '/calendar' => "flight_schedules#get_calendar_response"
	resources :flights
	get '/status' => "flight_schedules#status",:format => false
	post '/redirect_to_book_flow' => "flight_schedules#redirect_to_book_flow"
	scope 'flight-schedule' do
		match '/fetch_api_details' => "flight_schedules#fetch_api_details",via: [:post]
		match "/get_search_url" => "flight_schedules#get_search_url",via: [:post]
		get '/:route' => "flight_schedules#schedule_values",as: "flight_schedule"
		# get '/:route' => "flight_schedules#server",as: "flight_schedule"
	end

	scope 'flight-schedule/amp/' do
		get '/:route' => "flight_schedules#schedule_values"
	end

	scope ':lang/flight-schedule/amp/' do
		get '/:route' => "flight_schedules#schedule_values"
	end

	scope ':lang/flight-schedule' do
		get '/:route' => "flight_schedules#schedule_values",as: "lang_flight_schedule"
	end

	scope '/flight-schedule/:lang'  do
		get '/:route' => "flight_schedules#check_url"
	end

	scope 'flight-booking' do
	  get '/:airline' => "overview_bookings#booking_values",as: "flight_booking"
	end

	scope 'flight-booking/amp' do
		get '/:airline' => "overview_bookings#booking_values"
	end

	scope ':lang/flight-booking' do
	  get '/:airline' => "overview_bookings#booking_values",as: "lang_flight_booking"
	end

	scope ':lang/flight-booking/amp' do
	  get '/:airline' => "overview_bookings#booking_values"
	end

	scope "flight-booking/:lang" do
	  get '/:airline' => "overview_bookings#check_url"
	end

	scope "airlines/" do
	  get '/:airline' => "overview_bookings#redirect_airlines_to_bookings"
	end

	scope "airlines/:lang" do
	  get '/:airline' => "overview_bookings#redirect_airlines_to_bookings"
	end

	scope 'flight-tickets' do
		get '/:route' => "flight_tickets#ticket_values"
	end
	scope ':lang/flight-tickets' do
		get '/:route' => "flight_tickets#ticket_values"
	end
	get '/amp_new_search' => 'flight_schedules#amp_new_search'
	# get '*path' => redirect('/')
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
