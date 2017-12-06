require "BusinessPlatformSDK"

# included to increase the code-readability
include At::Sms::Business::Sdk
include At::Sms::Business::Sdk::Exception
include At::Sms::Business::Sdk::Domain
include At::Sms::Business::Api::Domain::Sms

begin
    text_message =  TextMessage.new([43123456], "Es kommt ein Eurozeichen: €")
    sms_client = SmsClient.new("your websms-account username", "your password", "https://api.websms.com")
    max_sms_per_message = 1
    test=false
    #text_message.sender_address = "RUBYSDK"
    #text_message.sender_address_type = :Alphanumeric
    
    return_code = sms_client.sendTextSms(text_message, max_sms_per_message,test)
    puts ("success " + return_code.to_s())
rescue ApiException,AuthorizationFailedException,
    HttpConnectionException => e
    puts "HttpConnectionException caught:"
    puts e
end