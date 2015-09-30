module Velocify
  class Agent
    include Model

    # Retrieve the entire list of agents
    #
    def self.find_all destruct: false, return_array: false
      verify_credentials!

      request do
        destruct_response? destruct
        operation :get_agents
        authenticate? true
        transform do |resp|
          if return_array
            arrayify resp[:agents][:agent]
          else
            resp
          end
        end
      end
    end
  end
end
