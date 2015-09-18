module Velocify
  module Model
    class Client
      WSDL = 'http://service.leads360.com/ClientService.asmx?WSDL'

      attr :spec, :client, :credentials
      
      def initialize spec, credentials: nil
        @spec = spec
        @credentials = credentials
        @client = Savon.client wsdl: WSDL
      end

      def call
        payload = {}

        if spec.has_message?
          payload = spec.__message
        end
        
        if spec.requires_auth?
          payload.merge! credentials
        end

        raw_response = client.call(spec.__operation, { message: payload }).body
        response_tag = "#{spec.__operation.to_s}_response".to_sym
        result_tag = "#{spec.__operation.to_s}_result".to_sym
        response = raw_response[response_tag][result_tag]

        if spec.has_transform?
          spec.__transform.call response
        else
          response
        end
      end

      private

      def client; @client; end
      
      def credentials; @credentials; end
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
    
    class RequestSpecification
      include RequestHelpers
      
      attr :destruct, :operation, :transform, :message, :credentials, :authenticate
      
      def initialize
        @destruct = false
      end

      def enable_destructuring is_on
        @destruct = is_on
      end

      def destruct?
        @destruct
      end
      
      def authenticate is_on
        @authenticate = is_on
      end
      
      def message *msg
        @message = Hash[ *msg ]
      end
      
      def operation op
        @operation = op.to_sym
      end

      def transform &block
        @transform = block
      end

      def has_message?
        !@message.nil?
      end

      def requires_auth?
        !@authenticate.nil?
      end

      def has_transform?
        !@transform.nil?
      end

      def __message
        @message
      end

      def __operation
        @operation
      end

      def __transform
        @transform
      end
    end
    
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
          spec = RequestSpecification.new
          spec.instance_eval(&block)
          client = Client.new spec, credentials: @credentials

          if destruct || spec.destruct?
            result = client.call
            [true, result]
          else
            client.call
          end
        rescue Savon::SOAPFault => ex
          if destruct || spec.destruct?
            [false, { message: ex.message }]
          else
            { message: ex.message }
          end
        rescue Net::ReadTimeout => ex
          if destruct || spec.destruct?
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
