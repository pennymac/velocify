require 'active_support/core_ext/string/inflections'

module Velocify
  class ResponseReader
    class << self
      # Convenience method to create a ResponseReader
      #
      # @param kind [Symbol] Choose from [:field]
      # @param response [Hash] The SOAP response received as returned by the other
      # Velocify model objects
      #
      def read kind:, response:
        singular_key = kind.to_s
        plural_key = singular_key.pluralize
        fields = response
        
        if response.instance_of? Hash
          fields = response[plural_key.to_sym][singular_key.to_sym]
        end
          
        ResponseReader.new kind: kind, elements: fields
      end
    end

    # Retrieve the id of a `kind` given a title
    #
    # @param title [String] the title of the `kind`
    # @return [String] the id of the `kind` that matches the title you searched for
    #
    def find_id_by_title title
      element = select_one_by_title title
      element["@#{kind}_id".to_sym] if element
    end

    def find_value_by_title title
      element = select_one_by_title title
      element["@value".to_sym] if element
    end

    def search_by_title title
      element = @elements.select { |el|
        el["@#{kind}_title".to_sym] =~ /#{title}/
      }

      element if element
    end

    def find_by_title title
      element = select_one_by_title title
      element if element
    end

    # @return [String] a list of all the titles
    def all_titles
      @elements.map { |el| el["@#{kind}_title".to_sym] }
    end

    private

    attr :kind, :hash
    
    def initialize kind:, elements:
      @kind, @elements = kind.to_s, elements
    end

    def select_one_by_title title
      @elements.select { |el|
        el["@#{kind}_title".to_sym] == title
      }.pop
    end
  end
end
