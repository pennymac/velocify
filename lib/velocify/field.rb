module Velocify
  class Field
    include Model

    # @return [Hash] a list of fields
    #
    def self.find_all destruct: false, return_array: false
      verify_credentials!
      
      request do
        destruct_response? destruct
        operation :get_fields
        authenticate? true
        transform do |resp|
          if return_array
            arrayify resp[:fields][:field]
          else
            resp
          end
        end
      end
    end
  end
end
