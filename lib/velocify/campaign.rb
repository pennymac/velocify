module Velocify
  class Campaign
    include Model

    def self.find_all destruct: false, return_array: false
      verify_credentials!

      request do
        enable_destructuring destruct
        operation :get_campaigns
        authenticate true
        transform do |resp|
          if return_array
            arrayify resp[:campaigns][:campaign]
          else
            resp
          end
        end
      end
    end
  end
end
