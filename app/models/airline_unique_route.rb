class AirlineUniqueRoute < ApplicationRecord
  has_many :ae_airline_route_schedules
  has_many :sa_airline_route_schedules
  has_many :in_airline_route_schedules
  has_many :kw_airline_route_schedules
end
