class UniqueHopRoute < ApplicationRecord
	has_many :in_flight_hop_schedule_collectives,dependent: :nullify
	has_many :ae_flight_hop_schedule_collectives,dependent: :nullify
	has_many :sa_flight_hop_schedule_collectives,dependent: :nullify
	has_many :kw_flight_hop_schedule_collectives,dependent: :nullify
	has_many :om_flight_hop_schedule_collectives,dependent: :nullify
	has_many :bh_flight_hop_schedule_collectives,dependent: :nullify
	has_many :qa_flight_hop_schedule_collectives,dependent: :nullify
	has_many :ae_flight_hop_ticket_collectives
end
