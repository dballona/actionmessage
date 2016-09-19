class BaseMessage < ActionMessage::Base
  prepend_view_path 'spec/support/views'

  def welcome_with_one_argument(person_name)
    @person_name = person_name
    sms(to: '+11231231234')
  end

  def welcome_with_two_arguments(person_name, company_name)
    @person_name = person_name
    @company_name = company_name
    sms(to: '+11231231234')
  end
end
