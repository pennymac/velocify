module Velocify
  module ModelHelpers
    attr :credentials

    def authenticate!
      @credentials = {
        username: ENV['VELOCIFY_USERNAME'],
        password: ENV['VELOCIFY_PASSWORD']
      }
      valid_credentials?
    end

    def authenticated?
      valid_credentials?
    end

    private

    def verify_credentials!
      if @credentials.nil?
        raise Velocify::AuthenticationException, "You must export your credentials to the environment"
      end
    end

    def authenticated_message msg
      @credentials.merge(msg) unless @credentials.nil?
    end

    def valid_credentials?
      return false if @credentials.nil?
      !@credentials[:username].empty? && !@credentials[:password].empty?
    end
    
    def request destruct: false, &block
      begin
        if destruct
          result = yield block
          [true, result]
        else
          yield block
        end
      rescue Savon::SOAPFault => ex
        if destruct
          [false, { message: ex.message }]
        else
          { message: ex.message }
        end
      rescue Net::ReadTimeout => ex
        if destruct
          [false, { message: ex.message }]
        else
          { message: ex.message }
        end
      end
    end
  end

  module Model
    def self.included mod
      mod.extend Savon::Model
      mod.client wsdl: 'http://service.leads360.com/ClientService.asmx?WSDL'
      mod.extend Velocify::ModelHelpers
      mod.authenticate!
    end
  end
end
