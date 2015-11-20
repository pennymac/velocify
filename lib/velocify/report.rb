module Velocify
  class Report
    include Model

    class << self
      def find_all destruct: false, return_array: false
        verify_credentials!

        request do
          destruct_response? destruct
          operation :get_reports
          authenticate? true
          transform do |resp|
            if return_array
              arrayify resp[:reports][:report]
            else
              resp
            end
          end
        end
      end

      def find_results report_id:, template_values: nil, destruct: false, return_array: false
        verify_credentials!

        request do
          destruct_response? destruct
          operation :get_report_results
          authenticate? true
          message report_id: report_id
          transform do |resp|
            if return_array
              arrayify resp[:report_results][:result]
            else
              resp
            end
          end
        end
      end
    end
  end
end
