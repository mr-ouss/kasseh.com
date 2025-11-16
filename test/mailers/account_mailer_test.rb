# frozen_string_literal: true

require "test_helper"

class AccountMailerTest < ActionMailer::TestCase
  test "deletion_confirmation" do
    email = "user@example.com"
    mail = AccountMailer.deletion_confirmation(email)

    assert_equal "Your account has been deleted", mail.subject
    assert_equal [ email ], mail.to
    # From address is dynamic from ENV, defaults to noreply@example.com in test
    assert_equal [ ENV.fetch("SMTP_FROM_EMAIL", "noreply@example.com") ], mail.from
    assert_match "permanently deleted", mail.body.encoded
    assert_match email, mail.body.encoded
  end
end
