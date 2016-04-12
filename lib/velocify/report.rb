require 'ostruct'

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

      # Retrieves report results with or without a filter
      #
      # @param report_id [Number] The id of the report
      #
      # @param template_values [Array<#field_title, #value>] (Optional) A list of filter items
      #
      # @example Including a filter item for retrieving report results with a last status change date filter
      #   require 'ostruct'
      #
      #   item = OpenStruct.new field_title: 'Last Status Change Date', value: '4/12/2016 12:00:00'
      #   Velocify::Report.find_results report_id: 123, template_values: [ item ]
      #
      # @note The template_values option must contain an array of filter items. Filter items are objects that must respond to #field_title and #value.
      #
      def find_results report_id:, template_values: [], destruct: false, return_array: false
        verify_credentials!

        request do
          destruct_response? destruct
          operation :get_report_results
          authenticate? true
          xml GetReportResultsPayload.new(report_id, template_values)
          transform do |resp|
            if return_array
              if template_values.empty?
                arrayify resp[:report_results][:result]
              else
                arrayify resp[:report_results]
              end
            else
              resp
            end
          end
        end
      end
    end
  end
end
