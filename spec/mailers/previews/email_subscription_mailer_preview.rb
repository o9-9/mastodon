# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/admin_mailer

class EmailSubscriptionMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/email_subscription_mailer/confirmation
  def confirmation
    EmailSubscriptionMailer.confirmation(EmailSubscription.last!)
  end
end
