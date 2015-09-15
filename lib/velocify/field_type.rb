module Velocify  
  class FieldType
    include Model

    operations :get_field_types
    
    # @return [Hash] a list of fields
    def self.find_all
      verify_credentials!
      
      request do
        response = get_field_types(message: authenticated_message({}))
        response.body[:get_field_types_response][:get_field_types_result]
      end
    end
  end
end
