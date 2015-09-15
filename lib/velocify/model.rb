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
    
    def request &block
      begin
        yield block
      rescue Savon::SOAPFault => ex
        { message: ex.message }
      rescue Net::ReadTimeout => ex
        { message: ex.message }
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
