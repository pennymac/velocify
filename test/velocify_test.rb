require 'test_helper'

module Velocify
  class VelocifyTest < Minitest::Test
    def test_programmatically_configure_credentials
      username = "dummy"
      password = "password"

      Velocify.configure do |config|
        config.username = username
        config.password = password
      end

      assert_equal username, Velocify.config.username
      assert_equal password, Velocify.config.password
    end
  end
end
