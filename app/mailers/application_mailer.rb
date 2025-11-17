class ApplicationMailer < ActionMailer::Base
  default from: email_address_with_name(
    ENV.fetch("SMTP_FROM_EMAIL", "noreply@example.com"),
    ENV.fetch("APP_NAME", "Kasseh")
  )
  layout "mailer"
end
