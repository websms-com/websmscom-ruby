require 'BusinessPlatformSDK/Message'

module At

module Sms

module Business

module Sdk

module Domain


# A Domain-Object used for specifying a binary-message.
class BinaryMessage < Message

  
   # The content of the binary-message as array of byte-arrays.
  attr_accessor(:binary_message_array)
  
  # The boolean if a user-data-header in the binary is present.
  attr_accessor(:user_data_header_present)
  
  # Constructor for creating a binary-message.
  #
  #====Attributes
  #* +recipient_address_list+ - The list of recipients for the message.
  #* +binary_message_array+ -  The content of the binary-message as array of byte-arrays.
  #            Every byte-array outlines an sms to be send. (e.g.: user sends an
  #            array consisting of 3 byte-arrays. 3 sms with binary-content will be send. 
  def initialize(recipient_address_list, binary_message_array)
     self.binary_message_array = binary_message_array
     self.recipient_address_list = recipient_address_list

     
   end

end
end
end
end
end
end