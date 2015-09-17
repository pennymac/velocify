module Velocify
  class Field
    include Model

    operations :get_fields

    # @return [Hash] a list of fields
    #
    def self.find_all destruct: false
      verify_credentials!
      
      request(destruct: destruct) do
        response = get_fields(message: @credentials)
        response.body[:get_fields_response][:get_fields_result]
      end
    end
  end
end
