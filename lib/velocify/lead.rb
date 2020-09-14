module Velocify
  class Lead
    include Model

    attr :fields
    attr_accessor :campaign_id, :agent_id, :status_id

    def initialize body: {}
      @body = body
    end

    def add_field id:, value:
      @fields = [] if @fields.nil?
      @fields << { id: id, value: value }
    end

    def campaign_id?; !@campaign_id.nil?; end

    def agent_id?; !@agent_id.nil?; end

    def status_id?; !@status_id.nil?; end

    class << self
      # Adds a lead or leads
      #
      # @param leads [String] The string representation of the XML document
      #                       containing the new leads
      #
      def add leads:, destruct: false, return_array: false
        verify_credentials!

        request do
          destruct_response? destruct
          operation :add_leads
          authenticate? true
          xml AddLeadsPayload.new(leads)
          transform do |resp|
            if return_array
              arrayify resp[:response][:additions][:lead]
            else
              resp
            end
          end
        end
      end

      # Retrieves all leads
      #
      # @param from [String] The start date
      # @param to [String] The end date
      # @return [Hash] The leads between the `from:` and `to:` dates
      #
      def find_all from:, to:, destruct: false, return_array: false
        verify_credentials!

        request do
          destruct_response? destruct
          operation :get_leads
          message from: from, to: to
          authenticate? true
          transform do |resp|
            if return_array
              arrayify resp[:leads][:lead]
            else
              resp
            end
          end
        end
      end

      # Retrieves a lead using an email address
      #
      # @param email [String] The email address used to search for a lead
      # @return [Hash] The leads having the matching email address
      #
      def find_by_email email, destruct: false, return_array: false
        verify_credentials!

        request do
          destruct_response? destruct
          operation :get_leads_by_email
          authenticate? true
          message email: email
          transform do |resp|
            if return_array
              arrayify resp[:leads][:lead]
            else
              resp
            end
          end
        end
      end

      # Retrieves a lead using a phone numebr
      #
      # @param phone [String] The phone number used to search for a lead
      # @return [Hash] The leads having the matching phone number
      #
      def find_by_phone phone, destruct: false, return_array: false
        verify_credentials!

        request do
          destruct_response? destruct
          operation :get_leads_by_phone
          message phone: phone.gsub(/[()\- ]/, '')
          authenticate? true
          transform do |resp|
            if return_array
              arrayify resp[:leads][:lead]
            else
              resp
            end
          end
        end
      end

      # Retrieves a lead by an id
      #
      # @param id [String] the id of the lead
      # @return [Hash] The lead with the matching id
      #
      def find_by_id id, destruct: false, return_array: false
        verify_credentials!

        request do
          destruct_response? destruct
          operation :get_lead
          authenticate? true
          message lead_id: id
          transform do |resp|
            if return_array
              arrayify resp[:leads][:lead]
            else
              resp
            end
          end
        end
      end

      def find_last_created destruct: false, return_array: false
        verify_credentials!

        request do
          destruct_response? destruct
          operation :get_last_created_lead
          authenticate? true
          transform do |resp|
            if return_array
              arrayify resp[:leads][:lead]
            else
              resp
            end
          end
        end
      end

      def find_last_modified destruct: false, return_array: false
        verify_credentials!

        request do
          destruct_response? destruct
          operation :get_last_modified_lead
          authenticate? true
          transform do |resp|
            if return_array
              arrayify resp[:leads][:lead]
            else
              resp
            end
          end
        end
      end

      def remove id:, destruct: false, return_array: false
        verify_credentials!

        request do
          destruct_response? destruct
          operation :remove_lead
          authenticate? true
          message lead_id: id
          transform do |resp|
            if return_array
              arrayify resp[:response][:removals] # also [:lead] ?
            else
              resp
            end
          end
        end
      end

      # Updates the status of a lead.
      #
      # Use the `Velocify::Status.find_all` method to retrieve the id of the status
      #
      # @see Velocify::Status.find_all
      #
      # @param lead_id [String] The id of the lead
      # @param status_id [String] The id of the status
      # @return [Hash] The response containing the updated lead
      #
      def update_status lead_id, status_id, destruct: false, return_array: false
        verify_credentials!

        request do
          destruct_response? destruct
          operation :modify_lead_status
          authenticate? true
          message lead_id: lead_id, status_id: status_id
          transform do |resp|
            if return_array
              arrayify resp[:leads][:lead]
            else
              resp
            end
          end
        end
      end

      # Updates a field for a lead
      #
      # @param lead_id [String] The id of the lead to be updated
      # @param field_id [String] The id of the field to be updated
      # @param new_value [String] The new value of the field
      # @return [Hash] The response containing the updated lead
      #
      def update_field lead_id, field_id, new_value, destruct: false, return_array: false
        verify_credentials!
      
        request do
          destruct_response? destruct
          operation :modify_lead_field
          authenticate? true
          message field_id: field_id, lead_id: lead_id, new_value: new_value
          transform do |resp|
            if return_array
              arrayify resp[:leads][:lead]
            else
              resp
            end
          end
        end
      end

      alias_method :last_created, :find_last_created
      alias_method :last_modified, :find_last_modified
    end
  end
end
