source 'https://rubygems.org'
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.4'
gem 'activesupport', '~> 5.1.7'
# Use sqlite3 as the database for Active Record
# Use Puma as the app server
gem 'puma', '~> 3.12'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
gem 'httparty'
gem 'bullet'
gem 'utf8-cleaner'
gem 'newrelic_rpm'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
# gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
gem 'will_paginate'
gem 'htmlcompressor'
gem 'axlsx'
gem 'zip-zip'
# Use Redis adapter to run Action Cable in production
gem 'redis'
gem 'redis-rails'
gem "roo"
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
gem 'mysql2'
gem 'sidekiq', '< 5'  
gem 'sidekiq_status'
gem 'sidekiq-superworker'
gem 'sidetiq'
gem 'smarter_csv'
# gem 'listen', '~> 3.0.5'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
gem 'listen'
# Use Capistrano for deployment
gem 'capistrano'
gem 'capistrano-chruby'
# cap tasks to manage puma application server
gem 'capistrano-rails',   '~> 1.1'
gem 'capistrano-bundler', '~> 1.1'
gem 'capistrano-rvm'
gem 'capistrano-passenger'
gem 'whenever', require: false
gem 'byebug'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'pry'
  gem 'rb-readline'
  gem 'pry-nav', '~> 0.3.0'
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  # gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
