load File.dirname(__FILE__) + '/../test_helper.rb'

# NOTE, W3C's test services is down at the moment

require 'net/http'
require 'net/https'
require 'erb'
    
describe "SOAP Testing" do
  include TestHelper
 
  it "SOAP with dynamic request data" do
    template_erb_file = File.expand_path("../../testdata/c_to_f.xml.erb", __FILE__)
    template_erb_str = File.read(template_erb_file)
    @degree = 30 # changeable in your test script
    request_xml = ERB.new(template_erb_str).result(binding)

    uri = URI.parse("https://www.w3schools.com/xml/tempconvert.asmx")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    resp, data = http.post(uri.path, request_xml,
                           {
      "SOAPAction" => "https://www.w3schools.com/xml/CelsiusToFahrenheit",
      "Content-Type" => "text/xml",
      "Host" => "www.w3schools.com",
    })
    expect(resp.code).to eq("200") # OK
    puts resp.body
    expect(resp.body).to include("<CelsiusToFahrenheitResult>86</CelsiusToFahrenheitResult>")
  end
  
end
