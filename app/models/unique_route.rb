class UniqueRoute < ApplicationRecord
	has_many :collectives
	has_many :ae_flight_schedule_collectives,dependent: :destroy
	has_many :in_flight_schedule_collectives,dependent: :destroy
	has_many :sa_flight_schedule_collectives,dependent: :destroy
	has_many :bh_flight_schedule_collectives,dependent: :destroy
	has_many :om_flight_schedule_collectives,dependent: :destroy
	has_many :kw_flight_schedule_collectives,dependent: :destroy
	has_many :qa_flight_schedule_collectives,dependent: :destroy
	
	has_many :in_flight_ticket_collectives,dependent: :destroy
	has_many :ae_flight_ticket_collectives,dependent: :destroy

	has_many :in_airline_brand_collectives,dependent: :destroy
	has_many :sa_airline_brand_collectives,dependent: :destroy
	has_many :ae_airline_brand_collectives,dependent: :destroy
	has_many :bh_airline_brand_collectives,dependent: :destroy
	has_many :kw_airline_brand_collectives,dependent: :destroy
	has_many :qa_airline_brand_collectives,dependent: :destroy
	has_many :om_airline_brand_collectives,dependent: :destroy
end
