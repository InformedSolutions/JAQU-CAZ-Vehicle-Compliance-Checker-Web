# frozen_string_literal: true

##
# Preview all emails at http://localhost:3000/rails/mailers/contact_form_mailer
#
class ContactFormMailerPreview < ActionMailer::Preview
  def send
    user_email = 'test@example.com'
    full_name = 'James Smith'
    query_type = 'Fleets'
    message = 'Text message'
    ContactFormMailer.send(user_email, full_name, query_type, message)
  end
end
