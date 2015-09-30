module Velocify
  class MessagePayload
    def initialize msg
      @msg = msg || {}
    end
    
    def authenticate username:, password:
      @msg.merge!({ username: username, password: password })
    end

    def render
      { message: @msg }
    end
  end
end
