module Velocify
  module Model
    class Client
      WSDL = 'http://service.leads360.com/ClientService.asmx?WSDL'

      attr :request, :soap_client, :username, :password
      
      def initialize request, username: nil, password: nil
        @request = request
        @username = username
        @password = password
        @soap_client = Savon.client wsdl: WSDL
      end

      def call
        if request.requires_auth?
          request.authenticate username: @username, password: @password
        end

        raw_response = soap_client.call(request.operation, request.payload).body
        response_tag = "#{request.operation.to_s}_response".to_sym
        result_tag = "#{request.operation.to_s}_result".to_sym
        response = raw_response[response_tag][result_tag]
        request.transform.call response
      end

      private

      def soap_client; @soap_client ; end
      def credentials; @credentials ; end
      def request    ; @request     ; end
    end

    module RequestHelpers
      def arrayify data
        if data.instance_of? Array
          data
        else
          [data]
        end
      end
    end
    
    class Request
      attr_writer :payload, :requires_auth, :destruct_response
      attr_accessor :transform
      attr_accessor :operation
      
      def initialize
        @destruct_response = false
        @requires_auth = false
      end

      def authenticate username:, password:
        @payload.authenticate username: username, password: password
      end

      def transform= transform
        @transform = transform
      end

      def payload
        @payload.render
      end

      def destruct_response? ; @destruct_response ; end
      def requires_auth?     ; @requires_auth     ; end
    end
    
    class RequestBuilder
      include RequestHelpers
      
      def initialize
        @destruct = false
      end

      def destruct_response? is_on
        @destruct = is_on
      end

      def authenticate? is_on
        @authenticate = is_on
      end

      def transform &block
        @transform = block
      end

      def operation op
        @operation = op.to_sym
      end

      def xml xml
        @xml = xml
      end

      def message msg
        @message = msg
      end

      def build
        Request.new.tap do |req|
          req.payload = @xml || MessagePayload.new(@message)
          req.requires_auth = @authenticate
          req.transform = @transform || -> (resp) { resp }
          req.operation = @operation
          req.destruct_response = @destruct          
        end
      end
    end
        
    module ModelHelpers
      attr :username, :password

      def authenticate!
        @username = ENV['VELOCIFY_USERNAME']
        @password = ENV['VELOCIFY_PASSWORD']
        valid_credentials?
      end

      def authenticated?
        valid_credentials?
      end

      private
      
      def verify_credentials!
        if @username.nil? || @password.nil?
          raise Velocify::AuthenticationException, "You must export your credentials to the environment"
        end
      end

      def valid_credentials?
        return false if @username.nil? || @password.nil?
        !@username.empty? && !@password.empty?
      end

      def request destruct: false, &block
        begin
          request_builder = RequestBuilder.new
          request_builder.instance_eval(&block)
          request = request_builder.build
          client = Client.new request, username: @username, password: @password

          if destruct || request.destruct_response?
            result = client.call
            [true, result]
          else
            client.call
          end
        rescue Savon::SOAPFault => ex
          if destruct || request.destruct_response?
            [false, { message: ex.message }]
          else
            { message: ex.message }
          end
        rescue Net::ReadTimeout => ex
          if destruct || request.destruct_response?
            [false, { message: ex.message }]
          else
            { message: ex.message }
          end
        end
      end
    end
    
    def self.included mod
      mod.extend ModelHelpers
      mod.authenticate!
    end
  end
end
