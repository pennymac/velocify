require 'erb'

module Velocify
  class MessagePayload
    def initialize msg
      @msg = msg || {}
    end
    
    def authenticate username:, password:
      @msg.merge!({ username: username, password: password })
    end

    def render
      { message: @msg }
    end
  end

  class AddLeadsPayload
    include ERB::Util
    
    # Creates a new request to add leads
    #
    # @param leads [Array<Lead>] A list of leads to be added
    def initialize leads
      @leads = leads
      @credentials = {}
    end

    # Stores credentials for making an authenticated request
    #
    # @param username [String]
    # @param password [String]
    # @return [Hash]
    def authenticate username:, password:
      @credentials = Hash[:username, username, :password, password]
    end

    # @return [String] The XML payload to send to Velocify's AddLeads operation
    def render
      relative_path = File.join '..', '..', 'templates', 'add_leads.xml.erb'
      current_dir = File.dirname(__FILE__)
      path = File.expand_path relative_path, current_dir
      template = File.read(path)
      xml_str = ERB.new(template).result binding
      { xml: xml_str.gsub(/[\n\t]*/, '').gsub(/[ ]{2,}/, '') }
    end
  end

  class GetReportResultsPayload
    include ERB::Util

    def initialize report_id, filter_items
      @filter_items = filter_items
      @report_id = report_id
      @credentials = {}
    end

    # Stores credentials for making an authenticated request
    #
    # @param username [String]
    # @param password [String]
    # @return [Hash]
    def authenticate username:, password:
      @credentials = Hash[:username, username, :password, password]
    end

    # @return [String] The XML payload to send to Velocify's GetReportResults operation
    def render
      relative_path = File.join '..', '..', 'templates', 'get_report_results.xml.erb'
      current_dir = File.dirname(__FILE__)
      path = File.expand_path relative_path, current_dir
      template = File.read(path)
      xml_str = ERB.new(template).result binding
      { xml: xml_str.gsub(/[\n\t]*/, '').gsub(/[ ]{2,}/, '') }
    end
  end
end
