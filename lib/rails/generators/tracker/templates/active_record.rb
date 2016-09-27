<% module_namespacing do -%>
class <%= class_name %> < ActiveRecord::Base
  include ActionMessage::Tracker
end
<% end -%>
