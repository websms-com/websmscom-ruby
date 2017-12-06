module At

module Sms

module Business

module Sdk

module Exception

# Thrown when an exception occurs at API-Level.
class ApiException < StandardError
  # The status-code the server returned
  attr_accessor(:status_code)
  # The status-message the server returned
  attr_accessor(:status_message)
end

end
end
end
end
end