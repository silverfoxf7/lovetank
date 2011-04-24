# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
SampleApp::Application.initialize!
# may want to change SampleApp to Plea::Application.initialize!  ???

ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.smtp_settings = {
:address => "smtpout.secureserver.net",
:domain  => "premiumlegalexchange.com",
:port      => 80,
:user_name => "info@premiumlegalexchange.com",
:password => "e-discovery",
:authentication => :plain
}

ActionMailer::Base.default_url_options[:host] = "plea.heroku.com"
ActionMailer::Base.default_url_options[:host] = "localhost:3000" if Rails.env.development?
# Change to "plea.heroku.com" for deployment.

#Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?
ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?