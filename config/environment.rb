# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.smtp_settings = {
address:              'smtp.sendgrid.net',
port:                 587,
domain:               'gmail.com',
user_name:            'ctseoinfra',
password:             'root1234$',
authentication:       :plain,
enable_starttls_auto: true
# openssl_verify_mode:  'none'
}
