require 'BusinessPlatformSDK/Message'

module At

module Sms

module Business

module Sdk

module Domain


#Domain-Object used for specifying a text-message.
class TextMessage < Message

  # The textual content of the message. Has to be utf-8 encoded.
  attr_accessor(:message_content)
 
  #Constructor for creating a text-message.
  #
  #====Attributes
  #* +recipient_address_list+ - The list of recipients for the message.
  #* +message_content+ - The content of the message.
  def initialize(recipient_address_list, message_content)

    self.message_content = message_content
    self.recipient_address_list = recipient_address_list

  end

end
end
end
end
end
end