class UniqueFbOverview < ApplicationRecord
	serialize :faq_object,Array
	serialize :reviews_object,Array
end
