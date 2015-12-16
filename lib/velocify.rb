require "savon"
require "dotenv"

Dotenv.load

module Velocify
  class Config
    attr_accessor :username, :password
  end

  class << self
    # @return [Config] the global config object
    def config
      @config ||= Config.new.tap do |config|
        config.username = ENV['VELOCIFY_USERNAME']
        config.password = ENV['VELOCIFY_PASSWORD']
      end
    end

    # Programmatically configure your connection to Velocify
    #
    # @yield [config] the block that contains the Config object
    def configure &blk
      blk.call config
    end
  end
end

require "velocify/version"
require "velocify/model"
require "velocify/campaign"
require "velocify/agent"
require "velocify/field"
require "velocify/field_type"
require "velocify/lead"
require "velocify/status"
require "velocify/report"

require "velocify/response_reader"
require "velocify/message_payload"
require "velocify/add_leads_payload"
