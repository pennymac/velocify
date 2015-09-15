module Velocify
  class Lead
    include Model

    operations :get_lead,
      :get_leads,
      :get_last_created_lead,
      :get_leads_by_email,
      :get_last_modified_lead,
      :modify_lead_field,
      :modify_lead_status,
      :add_leads

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
      def add leads:
        verify_credentials!

        request do
          response = add_leads(message: authenticated_message({ leads: leads }))
          response.body[:add_leads_response][:add_leads_result]
        end
      end
      
      # Retrieves all leads
      #
      # @param from [String] The start date
      # @param to [String] The end date
      # @return [Hash] The leads between the `from:` and `to:` dates
      #
      def find_all from:, to:
        verify_credentials!

        m = { from: from, to: to }

        request do
          response = get_leads(message: authenticated_message(m))
          response.body
        end
      end

      # Retrieves a lead using an email address
      #
      # @param email [String] The email address used to search for a lead
      # @return [Hash] The leads having the matching email address
      #
      def find_by_email email
        verify_credentials!

        request do
          response = get_leads_by_email(message: authenticated_message({ email: email }))
          response.body[:get_leads_by_email_response][:get_leads_by_email_result]
        end
      end

      # Retrieves a lead by an id
      #
      # @param id [String] the id of the lead
      # @return [Hash] The lead with the matching id
      #
      def find_by_id id
        verify_credentials!
        
        request do
          response = get_lead(message: authenticated_message({ lead_id: id }))
          response.body[:get_lead_response][:get_lead_result]
        end
      end
      
      def find_last_created
        verify_credentials!
        
        request do
          response = get_last_created_lead(message: authenticated_message({}))
          response.body[:get_last_created_lead_response][:get_last_created_lead_result]
        end
      end

      def find_last_modified
        verify_credentials!
        
        request do
          response = get_last_modified_lead(message: authenticated_message({}))
          response.body[:get_last_modified_lead_response][:get_last_modified_lead_result]
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
      def update_status lead_id:, status_id:
        verify_credentials!
        
        request do
          response = modify_lead_status(message: authenticated_message({
            lead_id: lead_id,
            status_id: status_id
          }))
          response.body[:modify_lead_status_response][:modify_lead_status_result]
        end
      end

      # Updates a field for a lead
      #
      # @param lead_id [String] The id of the lead to be updated
      # @param field_id [String] The id of the field to be updated
      # @param new_value [String] The new value of the field
      # @return [Hash] The response containing the updated lead
      #
      def update_field lead_id:, field_id:, new_value:
        verify_credentials!
        
        request do
          response = modify_lead_field(message: authenticated_message({
            field_id: field_id,
            lead_id: lead_id,
            new_value: new_value
          }))
          response.body[:modify_lead_field_response][:modify_lead_field_result]
        end
      end
    end
  end
end
