module Velocify
  class Status
    include Model

    def self.find_all destruct: false, return_array: false
      verify_credentials!

      request do
        destruct_response? destruct
        operation :get_statuses
        authenticate? true
        transform do |resp|
          if return_array
            arrayify resp[:statuses][:status]
          else
            resp
          end
        end
      end
    end
  end
end
