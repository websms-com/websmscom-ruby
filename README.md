What is it?
---
A lightweight Ruby Gem for using websms.com SMS services.

Prerequisites
---
- ruby (v1.8 or higher) installed.
- ruby-gems installed (tested with 1.3.7)

Install
---
Move to the downloaded BusinessPlatformSDK-x-x-x.gem using the command-line and type: 
   
    $ gem install BusinessPlatformSDK

This will install the Ruby-Toolkit with the documentation which can be opened using the "gem-server": 

    $ gem server


Getting Started With The Toolkit
---

The project can be included by using:

    require "BusinessPlatformSDK"

As a matter of fact there exist two ways for adding the modules(namespaces), that are needed to run the toolkit.  Either you include the whole namespace or
classes that will be used. For simplicity in the example the latter approach will be used.

The simplest example might be writing a TextSMS to one recipient. First a textMessage-Object has to be created:

    text_message =  At::Sms::Business::Sdk::Domain::TextMessage.new([43123456], "Hey you wanna hang out?")
    
The first parameter should be a list of telephone-numbers. The second describe the content of the message. Both parameters are 
mandatory attributes and nil or other parameter-types are not allowed.

As the creation of the text_message is finished we have to send it. So we need our Sms-Client to get this done:

    sms_client = At::Sms::Business::Sdk::SmsClient.new("your websms-account username", "your password", "https://api.websms.com/")
    
To initialize the SmsClient you need your websms-login credentials. If you don't own a websms-account the account-registration can be found
at http://websms.com/anmeldung. 
 
For the following shipment there are also other parameters needed:
 
    max_sms_per_message = 1
    
Max sms per message shows in this example that just one sms will be send. This is a
security parameter, that will specifies an upper limit for to be send sms. 
The tutorial on the website (http://websms.com/entwickler) will give 
further explanation about this topic.

    test=false
    
It's just a test, no real sms will be sent if set to true.

Next step is to send the SmsRequest to the websms-api and save the return code.
 
     return_code = sms_client.sendTextSms(text_message, max_sms_per_message, test)
     
If the return_code returns 2000,2001,2002 the request was successful. If something went wrong an exception will be raised.
To handle the exception that might be raised during the use of the toolkit, it is advised to write the code between a begin-rescue-clause.
The whole code-example might look like the following:

	# Include rubygems if your ruby version is below 1.9
    require "rubygems"
    require "BusinessPlatformSDK"

    # included to increase the code-readability
    include At::Sms::Business::Sdk
    include At::Sms::Business::Sdk::Exception
    include At::Sms::Business::Sdk::Domain

    begin 
        text_message =  TextMessage.new([43123456],"Hey you wanna hang out?")
        sms_client = SmsClient.new("your websms-account username", "your password", "https://api.websms.com")
        max_sms_per_message = 1
        test=false
        return_code = sms_client.sendTextSms(text_message, max_sms_per_message, test)

        puts ("success")

     rescue ApiException,AuthorizationFailedException,HttpConnectionException,ParameterValidationException => e
      puts e
    end


  
