# frozen_string_literal: true

class EmailSubscriptionMailer < Devise::Mailer
  include BulkMailSettingsConcern

  layout 'mailer'

  helper :accounts
  helper :application
  helper :formatting
  helper :instance
  helper :routing
  helper :statuses

  before_action :set_instance
  before_action :set_skip_preferences_link

  after_action :use_bulk_mail_delivery_settings, except: [:confirmation]
  after_action :set_list_headers

  default to: -> { @subscription.email }

  def confirmation(subscription)
    @subscription = subscription
    @unsubscribe_url = unsubscribe_url(token: @subscription.to_sgid(for: 'unsubscribe').to_s)

    I18n.with_locale(locale) do
      mail subject: I18n.t('email_subscription_mailer.confirmation.subject', name: @subscription.account.username, domain: @instance)
    end
  end

  private

  def set_list_headers
    headers(
      'List-ID' => "<#{@subscription.account.username}.#{Rails.configuration.x.local_domain}>",
      'List-Unsubscribe-Post' => 'List-Unsubscribe=One-Click',
      'List-Unsubscribe' => "<#{@unsubscribe_url}>"
    )
  end

  def set_instance
    @instance = Rails.configuration.x.local_domain
  end

  def set_skip_preferences_link
    @skip_preferences_link = true
  end

  def locale
    @subscription.locale.presence || I18n.default_locale
  end
end
