# frozen_string_literal: true

##
# Controls the flow for sending contact forms
#
class ContactFormsController < ApplicationController
  ##
  # Renders the contact form page
  #
  # ==== Path
  #    GET /contact_forms
  #
  def index
    # renders contact form
  end

  ##
  # Validates user data entered in contact form
  # If successful, redirects to {result}[rdoc-ref:ContactFormsController.result]
  # If not successful, renders {index view}[rdoc-ref:ContactFormsController.index] with errors
  #
  # ==== Path
  #    POST /contact_forms
  #
  # ==== Params
  # * +params+ - hash
  #   * +first_name+ - string, users's first name
  #   * +last_name+ - string, users's  last name
  #   * +email+ - string, user's email address
  #   * +email_confirmation+ - string, user's email confirmation address
  #   * +query_type+ - string, users's type of query
  #   * +message+ - string, users's message typed in form
  #
  def validate
    form = ContactForm.new(params['contact_form'])
    if form.valid?
      message_id = SendSqsMessage.call(contact_form: form)
      redirect_to result_contact_forms_path, alert: message_id.blank?
    else
      @errors = form.errors.messages
      log_invalid_form 'Rendering :index'
      render :index
    end
  end

  ##
  # Renders the contact form result page
  #
  # ==== Path
  #    GET /contact_forms/result
  #
  def result
    # renders static view
  end
end
