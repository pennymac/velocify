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
        fields = response[plural_key.to_sym][singular_key.to_sym]
        ResponseReader.new kind: kind, hash: fields
      end
    end

    # Retrieve the id of a `kind` given a title
    #
    # @param title [String] the title of the `kind`
    # @return [String] the id of the `kind` that matches the title you searched for
    #
    def find_id_by_title title
      key = @hash.select { |f|
        f["@#{kind}_title".to_sym] == title
      }.pop

      key["@#{kind}_id".to_sym] if key
    end

    def search_by_title title
      key = @hash.select { |k|
        k["@#{kind}_title".to_sym] =~ /#{title}/
      }

      key if key
    end

    def find_by_title title
      key = @hash.select { |k|
        k["@#{kind}_title".to_sym] == title
      }.pop

      key if key
    end

    # @return [String] a list of all the titles
    def all_titles
      @hash.map { |k| k["@#{kind}_title".to_sym] }
    end

    private

    attr :kind, :hash
    
    def initialize kind:, hash:
      @kind, @hash = kind.to_s, hash
    end
  end
end
