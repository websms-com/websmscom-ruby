module At

module Sms

module Business

module Sdk

module Domain


#A basic Message-Domain object 
class Message
  
  # The list of receiver-telephone-numbers. of international format e.g.:49xxxxxxxx. The attribute is mandatory.
  attr_accessor(:recipient_address_list)
  
  # The address of the sender  (e.g. The number to which the receiver can answer).
  attr_accessor(:sender_address)
  
  # The type of the sender-address. Based on String-constants found at businessapi.rb (e.g.: national,international,alphanumeric,shortcode).
  attr_accessor(:sender_address_type)
  
  # The boolean if the message is sent as flash-sms. If not set api will assume false.
  attr_accessor(:send_as_flash_sms)
  
  # The url for the notification-callback.
  attr_accessor(:notification_callback_url)
  
  # The id of the message choosen by the client.
  attr_accessor(:client_message_id)
  
  # The priority he priority of the message. Should be between 0-9 and if not set the api will assume 0.
  attr_accessor(:priority)
  
end
end
end
end
end
end
