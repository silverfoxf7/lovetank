#ActionMailer::Base.smtp_settings = {
#  :address              => "smtpout.secureserver.net",
#  :port                 => 587,
#  :domain               => "premiumlegalexchange.com",
#  :user_name            => "info@premiumlegalexchange.com",
#  :password             => "e-discovery",
#  :authentication       => "plain",
#  :enable_starttls_auto => true
#}

#  Based on my Google searching, I placed these smtp settings in the
#  environment.rb file.

#  Below are the settings provided by GoDaddy.com.
#  Consider switching to SendGrid.
          
          #Incoming Server Settings
  #Port
#IMAP without SSL - 143
#IMAP with SSL - 993
#POP without SSL - 110
#For POP with SSL - 995

          #Outgoing Server Settings
  #Port
#Without SSL - One of the following: 25, 80, 3535, 587
#With SSL - 465
