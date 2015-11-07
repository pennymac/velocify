require 'test_helper'

class AddLeadsPayloadTest < Minitest::Test
  def setup
    @campaign_id = '12345'
    @status_id = '23456'
    @agent_id = '34567'
    @username = 'myuser'
    @password = 'sekret'

    lead = Minitest::Mock.new
    lead.expect :campaign_id, @campaign_id
    lead.expect :status_id, @status_id
    lead.expect :agent_id, @agent_id
    lead.expect :campaign_id?, true
    lead.expect :agent_id?, true
    lead.expect :status_id?, true
    lead.expect :fields, []

    @subject = Velocify::AddLeadsPayload.new [lead]
  end

  def test_creates_xml_template_to_add_leads
    xml_payload = "<env:Envelope xmlns:env=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ser=\"https://service.leads360.com\"><env:Body><ser:AddLeads><ser:username>#{@username}</ser:username><ser:password>#{@password}</ser:password><ser:leads><Leads><Lead><Status StatusId=\"#{@status_id}\"></Status><Campaign CampaignId=\"#{@campaign_id}\"></Campaign><Agent AgentId=\"#{@agent_id}\"></Agent></Lead></Leads></ser:leads></ser:AddLeads></env:Body></env:Envelope>"

    @subject.authenticate username: @username, password: @password

    assert_equal @subject.render[:xml], xml_payload, "AddLeadsPayload must render an xml string contaning lead data and credentials"
  end
end
