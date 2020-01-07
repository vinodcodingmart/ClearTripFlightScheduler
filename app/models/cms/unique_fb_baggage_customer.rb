class CMS::UniqueFbBaggageCustomer < ApplicationRecord
	establish_connection :cms_development
	serialize :faq_object,Array
    serialize :reviews_object,Array
    serialize :last_modified_list,Array
end
