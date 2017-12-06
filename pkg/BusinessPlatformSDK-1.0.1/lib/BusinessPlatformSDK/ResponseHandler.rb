require "rubygems"
require 'BusinessPlatformSDK/businessapi'
require 'BusinessPlatformSDK/AuthorizationFailedException'
require 'BusinessPlatformSDK/ApiException'

module At

module Sms

module Business

module Sdk

module Http

# Is responsible for parsing and evaluating the response when user sends an
# SmsSendRequest.
class ResponseHandler
  
  include At::Sms::Business::Sdk::Exception

  attr_reader(:return_code)
  
  # Responsible for parsing and evaluating the response of the SendSmsRequest
  # 
  # ====Attributes
  # * +response+ The response of the request.
  def process response

    sms_send_response = At::Sms::Business::Api::Domain::Sms::SmsSendResponse.from_json(JSON.parse(response.body()))

    

    case sms_send_response.statusCode
    when 2000,2001,2002

      @return_code =  sms_send_response.statusCode
    when 4021
      raise AuthorizationFailedException.new(sms_send_response.statusMessage)
    else
      api_exception = ApiException.new(sms_send_response.statusMessage)
      api_exception.status_code = sms_send_response.statusCode
      api_exception.status_message = sms_send_response.statusMessage
      raise api_exception
      #raise ApiException.new("message:" + sms_send_response.statusMessage + ", status-code:"+ sms_send_response.statusCode.to_s())

    end

  end
end
end
end
end
end
end