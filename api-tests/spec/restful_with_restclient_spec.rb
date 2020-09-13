load File.dirname(__FILE__) + '/../test_helper.rb'

require 'net/http'
require 'httpclient'
require 'rexml/document'
require 'rest-client'

describe "REST WebService" do
  include TestHelper
  
   it "REST create using rest-client" do
    response = RestClient.get "http://www.thomas-bayer.com/sqlrest/CUSTOMER"
    puts response.code
    expect(response.code).to eq(200)
    puts response.headers # {:server=>"Apache-Coyote/1.1", :content_type=>"application/xml", :date=>"Mon, 28 Dec 2015 01:21:18 GMT", :content_length=>"4574"}
    puts response.body  # XML
    
    new_record_xml  = <<END_OF_MESSAGE
<CUSTOMER>
   <ID>7777</ID>
   <FIRSTNAME>Clinic</FIRSTNAME>
   <LASTNAME>Wise</LASTNAME>
   <STREET>20 Ruby Street</STREET>
   <CITY>Brisbane</CITY>
</CUSTOMER>
END_OF_MESSAGE

    begin
      response = RestClient.put "http://www.thomas-bayer.com/sqlrest/CUSTOMER", new_record_xml
      puts response.body
    rescue => e
       puts e
    end
  end
  
end
