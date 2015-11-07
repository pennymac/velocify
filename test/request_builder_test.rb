require 'test_helper'

class RequestSpecTest < Minitest::Test
  def setup
    @subject = Velocify::Model::RequestBuilder.new
  end

  def test_does_not_require_auth_by_default
    refute @subject.settings[:requires_auth], "A RequestSpec does not require authentication by default"
  end
  
  def test_does_not_destruct_response_by_default
    refute @subject.settings[:destruct], "A RequestSpec does not destruct the response by default"
  end

  def test_contains_no_operation_by_default
    assert_equal @subject.settings[:operation], nil, "A RequestSpec does not have an operation by default"
  end

  def test_contains_no_xml_payload_by_default
    assert_equal @subject.settings[:xml], nil, "A RequestSpec does not have an xml payload by default"
  end

  def test_contains_empty_message_by_default
    assert_equal @subject.settings[:message], {}, "A RequestSpec has an empty message by default"
  end

  def test_default_transform_is_identity
    dummy = Object.new
    assert_equal @subject.settings[:transform].call(dummy), dummy, "A RequestSpec has an identity transform by default"
  end

  def test_overriding_destruct_response_setting
    @subject.destruct_response? true

    assert @subject.settings[:destruct], "Setting the destruct_response? overrides the default settings"
  end

  def test_overriding_the_operation_setting
    @subject.operation :quick_draw

    assert_equal @subject.settings[:operation], :quick_draw, "Setting operation must override the default"
  end

  def test_overriding_authenticate_setting
    @subject.authenticate? true

    assert @subject.settings[:requires_auth], "Setting authenticate must override the default"
  end

  def test_overriding_transform_setting
    dummy = Object.new

    @subject.transform { |x| x.class.to_s }

    assert_equal @subject.settings[:transform].call(dummy), "Object", "Setting transform must override the default"
  end

  def test_overriding_message_setting
    msg = { hello: "world" }

    @subject.message msg
    
    assert_equal @subject.settings[:message], msg, "Setting message must override the default"
  end

  def test_overriding_xml_setting
    xml = "<blah/>"

    @subject.xml xml

    assert_equal @subject.settings[:xml], xml, "Setting xml must override the default"
  end
end
