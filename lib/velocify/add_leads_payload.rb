require 'erb'

module Velocify
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
end
