require 'test_helper'

class RequestTest < Minitest::Test
  def setup
    @subject = Velocify::Model::Request.new
  end

  def test_does_not_destruct_response_by_default
    refute @subject.destruct_response?, "A request must not destruct the response by default"
  end

  def test_does_not_require_auth_by_default
    refute @subject.requires_auth?, "A request must not require authentication by default"
  end

  def test_adding_a_message_payload_renders_the_payload
    message = { message: { username: "blah", password: "argh" } }

    payload = Minitest::Mock.new
    payload.expect :authenticate, message
    payload.expect :render, message

    @subject.payload = payload

    assert_equal @subject.payload, message, "A Request's payload must be rendered"
  end

  def test_store_transforms
    transform = Object.new

    @subject.transform = transform

    assert_equal @subject.transform, transform, "A Request must return the stored transform"
  end

  def test_store_the_operation
    operation = Object.new

    @subject.operation = operation

    assert_equal @subject.operation, operation, "A Request must return the stored operation"
  end
end
