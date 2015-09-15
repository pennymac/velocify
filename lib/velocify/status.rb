module Velocify
  class Status
    include Model

    operations :get_statuses

    def self.find_all
      verify_credentials!

      request do
        response = get_statuses(message: authenticated_message({}))
        response.body[:get_statuses_response][:get_statuses_result]
      end
    end
  end
end
