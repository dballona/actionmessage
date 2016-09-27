<% module_namespacing do -%>
class <%= class_name %>
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActionMessage::Tracker
end
<% end -%>
