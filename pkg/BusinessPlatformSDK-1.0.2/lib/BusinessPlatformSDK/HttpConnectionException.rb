module At
module Sms
module Business
module Sdk
module Exception


# Is thrown when a discrepancy compared to successfull request (200 OK) happens, while connecting to the server, this might
# range from a simple 'no connection could be established' to a server returned http-error-code. Exception to this is if the 
# authorization fails, in this special case an AuthorizationException is thrown.  
class HttpConnectionException < StandardError
end

end
end
end
end
end