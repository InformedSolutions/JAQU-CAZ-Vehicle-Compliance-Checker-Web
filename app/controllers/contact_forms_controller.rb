# frozen_string_literal: true

##
# Controls the flow for sending emails
#
class ContactFormsController < ApplicationController
  ##
  # Renders the contact form page
  #
  # ==== Path
  #    GET /contact_form
  #
  def contact_form
    # renders contact form
  end

  ##
  # Validates user data entered in contact form
  # If successful, redirects to {contact_form_result}[rdoc-ref:ContactFormsController.contact_form_result]
  # If not successful, renders {contact_form}[rdoc-ref:ContactFormsController.contact_form] with errors
  #
  # ==== Path
  #    POST /validate_contact_form
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
  def validate_contact_form
    form = ContactForm.new(params['contact_form'])
    if form.valid?
      redirect_to contact_form_result_path
    else
      @errors = form.errors.messages
      log_invalid_form 'Rendering :new_contact_form.'
      render 'contact_form'
    end
  end

  ##
  # Renders the contact form result page
  #
  # ==== Path
  #    GET /contact_form_result
  #
  def contact_form_result
    render 'result'
  end
end
