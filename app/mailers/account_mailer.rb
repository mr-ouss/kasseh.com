class AccountMailer < ApplicationMailer
  def deletion_confirmation(email_address)
    @email = email_address
    mail(
      to: email_address,
      subject: "Your account has been deleted"
    )
  end
end
