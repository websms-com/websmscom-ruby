require 'net/http'
require 'net/https'
require "BusinessPlatformSDK/AuthorizationFailedException"
require "BusinessPlatformSDK/HttpConnectionException"

module At
  module Sms
    module Business
      module Sdk
        module Http
          # The HttpDispatcher is responsible for sending synchronous requests
          # to the business-plattform-api. The standard media-type is *application/json*.
          # Author:: Sebastian Wilhelm
          class HttpDispatcher

            include At::Sms::Business::Sdk::Exception
            
            HTTP_OPEN_TIMEOUT = 30
            HTTP_READ_TIMEOUT = 60
            
            
            # Initializes the HttpDispatcher.
            #
            # ==== Attributes
            # * +base_url+ The base-url of the server where the http-request should be dispatched.
            def initialize base_url
              @base_url = base_url
            end

            # Is used for sending a synchronous post-request, where requestRessource is formatted as json-string.
            # The request is using basic-authorization for accessing the server.
            #
            # ==== Attributes
            # * +username+ The username of the account.
            # * +password+ The password of the account.
            # * +path+ The path to the ressource.
            # * +request_ressource+ The ressource that will be encoded into a json-string.
            # * +response_handler+ The handler that is processing the response.
            # * +query_params+ The query-params included into the request.
            #
            # ==== Throws
            # * +HttpConnectionException+ - When something went wrong during on the http-level.
            # * +AuthorizationFailesException+ - When the authorization went wrong.
            def sendPostRequest(username, password,
              path, request_ressource,
              response_handler, query_params)

              uri = URI.parse(@base_url+path);

              request = Net::HTTP::Post.new(uri.path)

              request.basic_auth(username, password)
              request["Content-Type"] = "application/json"
              request["Accept"] = "application/json"

              generated_json = request_ressource.to_json

              request.body= generated_json

              http = Net::HTTP.new(uri.host, uri.port)
              http.open_timeout = HTTP_OPEN_TIMEOUT
              http.read_timeout = HTTP_READ_TIMEOUT
              
              # set enabled if you want to debug
              #http.set_debug_output $stdout

              if(uri.scheme == "https")
                http.verify_mode = OpenSSL::SSL::VERIFY_NONE
                http.use_ssl= true
              end


              http.start do |http|
                response = http.request(request)

                #puts "======== response ==========="
                #puts response

                case response
                when Net::HTTPSuccess
                  response_handler.process(response)
                when Net::HTTPBadGateway
                  raise HttpConnectionException.new("Bad gateway")
                when Net::HTTPUnauthorized
                  raise AuthorizationFailedException.new("Wrong username or password.")
                else
                  raise HttpConnectionException.new(response.body)
                  
                end

              end

            end
          end
        end
      end
    end
  end
end