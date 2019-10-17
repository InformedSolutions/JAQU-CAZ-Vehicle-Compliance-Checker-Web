# frozen_string_literal: true

##
# Class used to create email sent to the admin
#
class ContactFormMailer < ApplicationMailer
  ##
  # Action sending an email to the admin.
  #
  # ==== Attributes
  #
  # * +user_email+ - string, user email address
  # * +full_name+ - string, full name of user
  # * +query_type+ - string, type of query
  # * +message+ - string, user message typed in form
  #
  def send_email(user_email, full_name, query_type, message)
    @user_email = user_email
    @full_name = full_name
    @message = message
    admin_email = Rails.configuration.x.contact_form_email
    mail(to: admin_email, subject: query_type)
  end
end
