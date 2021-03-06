load File.dirname(__FILE__) + '/../test_helper.rb'

require 'net/http'
require 'httpclient'
require 'rexml/document'

describe "REST WebService" do
  include TestHelper

  it "REST - List all records" do
    list_rest_url = "http://www.thomas-bayer.com/sqlrest/CUSTOMER"
    resp = HTTPClient.new.get(list_rest_url)
    xml_doc  = REXML::Document.new(resp.body)
    expect(xml_doc.root.elements.size).to be > 10    
  end

  it "REST - Get a record" do
    get_rest_url = "http://www.thomas-bayer.com/sqlrest/CUSTOMER/4"    
    resp = HTTPClient.new.get(get_rest_url)
    # debug resp.body
    expect(resp.body).to include("<CITY>")
  end
  
   it "REST-Client" do
    gem "rest-client"
    require 'rest-client'
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
