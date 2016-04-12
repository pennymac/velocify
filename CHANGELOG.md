# Changes in 0.1.7

* Supports adding filter items to the template_values option when retrieving report results

```
require 'ostruct'

item = OpenStruct.new field_title: 'Last Status Change Date', value: '4/12/2016 12:00:00'
Velocify::Report.find_results report_id: 123, template_values: [ item ]
```

# Changes in 0.1.6

* Supports programmatic configuration of Velocify credentials:

``` ruby
Velocify.configure do |config|
  config.username = "dummy"
  config.password = "pass"
end
```

# Changes in 0.1.5

* Fixes bug in ```return_array: ``` option for ```Velocify::Lead.add```
* Adds new feature for retrieving all reports

``` ruby
Velocify::Report.find_all
```

* Adds new feature for retrieving the results of a report

``` ruby
Velocify::Report.find_results id: 89
```

# Changes in 0.1.4

* ```Velocify::Lead.add``` now works:

``` ruby
lead = Velocify::Lead.new
lead.status_id = 13
lead.campaign_id = 35
lead.agent_id = 89
lead.add_field id: 2, value: "First"
lead.add_field id: 3, value: "Lead"

Velocify::Lead.add leads: [lead]
```

* Support for retrieving agents

``` ruby
agents = Velocify::Agent.find_all return_array: true
```

# Changes in 0.1.3

* All model classes now support the optional keyword argument ```return_array:``` if you want to receive
  a response that wraps the results in an array:

``` ruby
leads = Velocify::Lead.find_by_email 'hi@example.org', return_array: true
# Every element in the array would contain a lead
# => [{ ... }, ... ]
```

## Breaking Changes

* ```Velocify::Lead.find_all``` by default returns a response like so ```{leads=>{lead=> ... }```
  instead of ```{get_leads_response=>{get_leads_result=>{leads=>lead=> ... }```.

