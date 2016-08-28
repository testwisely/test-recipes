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
    expect(resp.body).to include("<CITY>Brisbane</CITY>")
  end
    
end
