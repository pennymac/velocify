require "savon"
require "dotenv"

Dotenv.load

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

module Velocify
end
