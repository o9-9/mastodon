# frozen_string_literal: true

class UnsubscriptionsController < ApplicationController
  layout 'auth'

  skip_before_action :require_functional!

  before_action :set_recipient
  before_action :set_type

  protect_from_forgery with: :null_session

  def show; end

  def create
    case @recipient.class
    when User
      @recipient.settings[@type] = false if @type.present?
      @recipient.save!
    when EmailSubscription
      @recipient.destroy!
    end
  end

  private

  def set_recipient
    @recipient = GlobalID::Locator.locate_signed(params[:token], for: 'unsubscribe')
    not_found unless @recipient
  end

  def set_type
    @type = email_type_from_param
  end

  def email_type_from_param
    case params[:type]
    when 'follow', 'reblog', 'favourite', 'mention', 'follow_request'
      "notification_emails.#{params[:type]}"
    end
  end
end
