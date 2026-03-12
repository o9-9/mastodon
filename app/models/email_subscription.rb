# frozen_string_literal: true

# == Schema Information
#
# Table name: email_subscriptions
#
#  id                 :bigint(8)        not null, primary key
#  confirmation_token :string
#  confirmed_at       :datetime
#  email              :string           not null
#  locale             :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  account_id         :bigint(8)        not null
#

class EmailSubscription < ApplicationRecord
  belongs_to :account

  validates :email, presence: true, email_address: true, uniqueness: { scope: :account_id }

  scope :confirmed, -> { where.not(confirmed_at: nil) }

  after_create_commit :send_confirmation_email

  def confirm!
    touch(:confirmed_at)
  end

  private

  def send_confirmation_email
    EmailSubscriptionMailer.confirmation(self).deliver_later(wait: 1.minute)
  end
end
