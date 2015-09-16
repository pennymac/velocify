module Velocify
  class Campaign
    include Model

    operations :get_campaigns

    def self.find_all destruct: false
      verify_credentials!

      request(destruct: destruct) do
        response = get_campaigns(message: @credentials)
        response.body[:get_campaigns_response][:get_campaigns_result]
      end
    end
  end
end
