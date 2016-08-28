load File.dirname(__FILE__) + '/../test_helper.rb'

require 'net/http'
require 'net/https'
require 'erb'
    
describe "SOAP Testing" do
  include TestHelper

  before(:all) do    
  end

  after(:all) do
  end

  # A list of free web services,  http://www.service-repository.com/  
  it "SOAP with sample XML" do
    request_xml = <<END_OF_MESSAGE
<?xml version="1.0" encoding="utf-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" 
                  xmlns:x="http://www.w3schools.com/xml/">
   <soapenv:Header/>
   <soapenv:Body>
      <x:CelsiusToFahrenheit>
         <x:Celsius>10</x:Celsius>
      </x:CelsiusToFahrenheit>
   </soapenv:Body>
</soapenv:Envelope>
END_OF_MESSAGE

    http = Net::HTTP.new('www.w3schools.com', 80)
    resp, data = http.post("/xml/tempconvert.asmx", request_xml,
        {
          "SOAPAction" => "http://www.w3schools.com/xml/CelsiusToFahrenheit", 
          "Content-Type" => "text/xml",
          "Host" => "www.w3schools.com",
        }
      )
    expect(resp.code).to eq("200") # OK
    # debug resp.body
    # resp.each { |key, val| debug(key + ' = ' + val) }    
    expect(resp.body).to include("<CelsiusToFahrenheitResult>50</CelsiusToFahrenheitResult>")
  end
 
 
  it "SOAP with dynamic request data" do
    template_erb_file = File.expand_path("../../testdata/c_to_f.xml.erb", __FILE__)
    template_erb_str = File.read(template_erb_file)
    @degree = 30 # changeable in your test script
    request_xml = ERB.new(template_erb_str).result(binding)
    
    http = Net::HTTP.new('www.w3schools.com', 80)
    resp, data = http.post("/xml/tempconvert.asmx", request_xml,
      {
        "SOAPAction" => "http://www.w3schools.com/xml/CelsiusToFahrenheit", 
        "Content-Type" => "text/xml",
        "Host" => "www.w3schools.com",
      }
    )
    expect(resp.code).to eq("200") # OK
    debug resp.body
    expect(resp.body).to include("<CelsiusToFahrenheitResult>86</CelsiusToFahrenheitResult>")
  end

  
end
