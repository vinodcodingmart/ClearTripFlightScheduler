class CMS::Common < ApplicationRecord
	establish_connection :cms_development
    serialize :faq_object,Array
end
