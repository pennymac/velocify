require 'test_helper'

class MessagePayloadTest < Minitest::Test
  def setup
    @message = { hello: "world" }
    @subject = Velocify::MessagePayload.new(@message)
  end

  def test_a_message_payload_contains_a_message
    assert @subject.render[:message], @message
  end

  def test_a_message_payload_can_be_authenticated
    username = 'myself'
    password = 'sekret'

    @subject.authenticate username: username, password: password

    rendered_message = @subject.render[:message]

    assert rendered_message.fetch(:username), username
    assert rendered_message.fetch(:password), password
  end
end
