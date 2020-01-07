require 'open-uri'
require 'net/http'
namespace :test do
	task :serpbook => :environment do 
    category_urls = {
					  "AE Q1 Hotels Keywords" => "https://serpbook.com/serp/api/?viewkey=0lmho81&auth=fb55c1fb716c89952e8c43453bcf0f6b",
					  "Emirates - UAE Campaign" => "https://serpbook.com/serp/api/?viewkey=cc8mu6q&auth=646e1d43104e87efe2c567016990c88c",
					  "Flight XP - Mobile rank tracking" => "https://serpbook.com/serp/api/?viewkey=fbq5smr&auth=a03ceec002ce9333b2bd6e37db2885cc",
					  "India Flights" => "https://serpbook.com/serp/api/?viewkey=ruqb3wu&auth=5ed80817c49b612b86282421f98193df",
					  "India Hotels" => "https://serpbook.com/serp/api/?viewkey=1as1wu5&auth=14d2eba99340194884a32467b3e6c890",
					  "KSA Q1 Arabic Keywords" => "https://serpbook.com/serp/api/?viewkey=tcf1x65&auth=d147b1fd1eb39be2689c39819068b60b",
					  "KSA Q1 Keywords" => "https://serpbook.com/serp/api/?viewkey=5s93s48&auth=65dd0b44fdad1a61a090f958bb1e4356",
					  "Random" => "https://serpbook.com/serp/api/?viewkey=zoogy4x&auth=a883dfd72521122efbb002573762e07b",
					  "UAE Q1 Activities" => "https://serpbook.com/serp/api/?viewkey=k5fnuac&auth=02a2ff3d4e63723b681c4bd9c4a8e5d5",
					  "UAE Q1 Keywords" => "https://serpbook.com/serp/api/?viewkey=5vr2e2v&auth=1e28505c5290737680abe8d33a8d1a67",
					  "Visa" => "https://serpbook.com/serp/api/?viewkey=agiurll&auth=2b8b6fdc5e22426d48491aa0e494ea7e"
					}
					response = {}
    category_urls.each do |k,v| 
    	key = "#{k.downcase.gsub(' ','_')}"
 	  	response["#{key}_url_response"]  = HTTParty.get(v) 
		end
		return response
	end	
end

