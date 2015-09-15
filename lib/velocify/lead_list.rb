require 'erb'

module Velocify
  class LeadList
    include ERB::Util
    
    attr :leads

    def initialize
      @leads = []
    end

    def add_lead lead
      @leads << lead
    end

    def render
      relative_path = File.join 'xml', 'leads.xml.erb'
      current_dir = File.dirname(__FILE__)
      path = File.expand_path relative_path, current_dir
      template = File.read(path)
      ERB.new(template).result binding
    end
  end
end
