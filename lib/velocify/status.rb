module Velocify
  class Status
    include Model

    operations :get_statuses

    def self.find_all destruct: false
      verify_credentials!

      request(destruct: destruct) do
        response = get_statuses(message: authenticated_message({}))
        response.body[:get_statuses_response][:get_statuses_result]
      end
    end
  end
end
