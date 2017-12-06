require 'BusinessPlatformSDK/HttpDispatcher'
require 'BusinessPlatformSDK/ResponseHandler'
require 'BusinessPlatformSDK/businessapi'
require 'BusinessPlatformSDK/TextMessage'
require 'BusinessPlatformSDK/ParameterValidationException'
require "BusinessPlatformSDK/TextMessage"
require "BusinessPlatformSDK/BinaryMessage"
require "base64"
require "rubygems"

module At

module Sms

module Business

module Sdk



# The interface of an client for evaluating,creating and delegating
# sms-requests to the websms-api
# Author:: Sebastian Wilhelm
class SmsClient
  
  include At::Sms::Business::Sdk::Http
  
  # The constructor of the SmsClient.
  # 
  # ==== Attributes
  # * +username+ - The username of the account.
  # * +password+ - The password of the account.
  # * +base_url+ - The url to the websms-api.
  #
  #
  # ==== Throws
  # * +ParameterValidationException+ If an attribute in binary_message or another parameter is invalid.
  #
  def initialize(username,password,base_url)
    raise ParameterValidationException, 'username is a mandatory parameter and has to be a string' unless username.is_a? String
    raise ParameterValidationException, 'password is a mandatory parameter and has to be a string' unless password.is_a? String
    raise ParameterValidationException, 'base_url is a mandatory parameter and has to be a string' unless base_url.is_a? String

    base_url = base_url.sub(/(\/)+$/,'')
    
    @HttpDispatcher = HttpDispatcher.new(base_url)
    @username = username
    @password = password
  end

  # Delivers a text-sms-request to the websms-api.
  #
  # ==== Attributes
  # * +text_message+ - A TextMessage-object which holds every possible parameters
  #            needed for sending an text-sms.
  # * +max_sms_per_message+ - Defines an upper-limit of how many messages should be sent.
  # * +test+ - True if the use of the function is for testing-purposes, and
  #            no real-sms should be send. 
  #
  # ==== Returns
  # * +return_code+ - The status-code for the successful request otherwise exceptions will be raised.
  #
  # ==== Throws
  # * +ParameterValidationException+ - If an attribute in binary_message or another parameter is invalid.
  # * +HttpConnectionException+ - Is thrown when a problem occurs while connecting to the api.
  # * +ApiException+ - Returns an exception with a status-code, that was thrown at api-level.
  # * +AuthorizationFailedException+ Is thrown when the authorization by username/password failed.
  #
  def sendTextSms(text_message,max_sms_per_message=1,test=false)

    checkParameters(text_message.recipient_address_list, text_message.sender_address, text_message.sender_address_type,
    text_message.send_as_flash_sms, text_message.notification_callback_url, text_message.client_message_id, text_message.priority,
    test)

    raise ParameterValidationException, 'message_content is mandatory parameter and has to be a string' unless text_message.message_content.is_a? String
    raise ParameterValidationException, 'max_sms_per_message has to be an integer' unless max_sms_per_message.is_a? Integer || max_sms_per_message.nil?()

    if(!text_message.sender_address_type.nil?())
      isAValidType = false
      SenderAddressType.constants.each do |type|
        if type.equal?(text_message.sender_address_type)
          isAValidType = true
        end
      end

      if(!isAValidType)
        raise ParameterValidationException, 'sender_address_type has to be one of these attributes: ' +  SenderAddressType.constants* ", ".to_s()
      end

    end

    sms_send_request = At::Sms::Business::Api::Domain::Sms::TextSmsSendRequest.new
    sms_send_request.messageContent = text_message.message_content
    sms_send_request.recipientAddressList = text_message.recipient_address_list
    sms_send_request.senderAddress = text_message.sender_address
    sms_send_request.senderAddressType = text_message.sender_address_type
    sms_send_request.sendAsFlashSms = text_message.send_as_flash_sms
    sms_send_request.clientMessageId = text_message.client_message_id
    sms_send_request.priority = text_message.priority
    
    sms_send_request.maxSmsPerMessage = max_sms_per_message
    sms_send_request.test = test

    response_handler = ResponseHandler.new;

    @HttpDispatcher.sendPostRequest(@username, @password,
    "/json/smsmessaging/text", sms_send_request,
    response_handler, nil)

    return response_handler.return_code

  end

  # Delivers a sms-request with binary-content to the websms-api.
  #
  # ==== Attributes
  # * +binary_message+ - A BinaryMessage-object which holds every possible parameters
  #            needed for sending an binary-sms.
  # * +test+ - True if the use of the function is for testing-purposes, and
  #            no real-sms should be send. 
  #
  # ==== Returns
  # * +return_code+ - The status-code for a successful request otherwise exceptions will be raised.
  #
  # ==== Throws
  # * +ParameterValidationException+ If an attribute in binary_message or another parameter is invalid. 
  # * +HttpConnectionException+ Is thrown when a problem occurs while connecting to the api.
  # * +ApiException+ Returns an exception with a status-code, that was thrown at api-level.
  # * +AuthorizationFailedException+ Is thrown when the authorization by username/password failed.
  #
  def sendBinarySms(binary_message,
    test=false)

    puts "vorher binary_message.recipient_address_list:"
    p binary_message.recipient_address_list
    
    checkParameters(binary_message.recipient_address_list,
    binary_message.sender_address, binary_message.sender_address_type,
    binary_message.send_as_flash_sms, binary_message.notification_callback_url, binary_message.client_message_id, 
    binary_message.priority, test);

    raise ParameterValidationException, 'user_data_header_present has to be a boolean' unless !!binary_message.user_data_header_present == binary_message.user_data_header_present || binary_message.user_data_header_present.nil?() 
    raise ParameterValidationException, 'binary_message_array is a mandatory parameter' unless !binary_message.binary_message_array.nil?

    sms_send_request = At::Sms::Business::Api::Domain::Sms::BinarySmsSendRequest.new
    #p "messageContent"+ sms_send_request.messageContent
    
    binary_message_array = binary_message.binary_message_array
    

    
    binary_message_array.each do |message|
      coded_string = Base64.encode64(message)
      if coded_string[-1,1] == "\n"
        coded_string = coded_string[0,coded_string.length-1]
      end

    sms_send_request.messageContent = coded_string end

    
    sms_send_request.recipientAddressList = binary_message.recipient_address_list
    sms_send_request.userDataHeaderPresent = binary_message.user_data_header_present
    sms_send_request.senderAddress = binary_message.sender_address
    sms_send_request.senderAddressType = binary_message.sender_address_type
    sms_send_request.sendAsFlashSms = binary_message.send_as_flash_sms
    sms_send_request.clientMessageId = binary_message.client_message_id
    sms_send_request.priority = binary_message.priority
    sms_send_request.test = test

    response_handler = ResponseHandler.new;

    @HttpDispatcher.sendPostRequest(@username, @password,
    "/json/smsmessaging/binary", sms_send_request,
    response_handler, nil)

    return response_handler.return_code

  end

  def checkParameters(recipient_address_list,
    sender_address, sender_address_type,
    send_as_flash_sms, notification_callback_url, client_message_id, priority,
    test)#:nodoc:

    #Typechecking:
    
    raise ParameterValidationException, 'recipient_address_list is a mandatory parameter and has to be an array with Integers(int. telephon-numbers e.g.: 43123456789' unless recipient_address_list.all? {|i| i.is_a? Integer}

    raise ParameterValidationException, 'sender_address has to be a string' unless sender_address.nil?() || sender_address.is_a?(String)
    # Both have to be specified

    if(!sender_address.nil? && sender_address_type.nil?)
      raise ParameterValidationException, 'if the sender_address is specified the sender_address_type has to be specified too'
    end

    raise ParameterValidationException, 'send_as_flash_sms has to be a boolean' unless send_as_flash_sms .nil?() || (!!send_as_flash_sms == send_as_flash_sms)
    raise ParameterValidationException, 'client_message_id has to be a string' unless client_message_id.is_a?(String) || client_message_id.nil?
    raise ParameterValidationException, 'priority has to be an integer' unless priority.is_a?(Integer) || priority.nil?
    raise ParameterValidationException, 'priority has to be nonnegative' unless priority.nil? || priority >= 0 
    raise ParameterValidationException, 'test has to be boolean' unless !!test == test || test.nil?()

  end

end
end
end
end
end
