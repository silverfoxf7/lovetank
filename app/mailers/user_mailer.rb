class UserMailer < ActionMailer::Base

  default :from => "info@premiumlegalexchange.com"

  def registration_confirmation(user)
    @user = user
#    attachments["logo.png"] = File.read("#{Rails.root}/public/images/logo.png")
#    Attachments not currently working; F/U with Google search on subject
    mail(:to => user.email, :subject => "You Are Registered")
  end

  def apply_for_job(user, job, bid)
    @user = user
    @job = job
    @bid = bid
#    attachments["logo.png"] = File.read("#{Rails.root}/public/images/logo.png")
#    Attachments not currently working; F/U with Google search on subject
    mail(
#         :from => user.email,
#         :bcc => user.email,
#  this was commented out due to a EOFError; cannot set From: using
#  GoDaddy's SMTP settings.
         :to => @job.email,
         :cc => user.email,
         :subject => "Applying for '#{@job.title}' via PLE"
        )
  end

end
