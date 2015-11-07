require 'test_helper'

class VelocifyLeadTest < Minitest::Test
  def setup
    @subject = Velocify::Lead.new
  end

  def test_has_no_campaign_id_by_default
    refute @subject.campaign_id?, "A lead doesn't have a campaign id by default"
  end

  def test_has_no_agent_id_by_default
    refute @subject.agent_id?, "A lead doesn't have an agent id by default"
  end

  def test_has_no_status_id_by_default
    refute @subject.status_id?, "A lead doesn't have a status id by default"
  end

  def test_add_an_arbitrary_field
    field_id = '12345'
    field_value = 'aoeuhtns'

    @subject.add_field id: field_id, value: field_value

    assert @subject.fields, [{ id: field_id, value: field_value }]
  end

  def test_add_more_than_one_field
    field1_id = '12345'
    field1_value = 'aoeuhtns'
    field2_id = '67890'
    field2_value = 'htnsaoeu'

    @subject.add_field id: field1_id, value: field1_value
    @subject.add_field id: field2_id, value: field2_value

    assert @subject.fields, [{ id: field1_id, value: field1_value }, { id: field2_id, value: field2_value }]
  end
end
