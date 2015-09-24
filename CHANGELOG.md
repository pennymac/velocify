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

