load File.dirname(__FILE__) + '/../test_helper.rb'

require 'net/http'
require 'net/https'
require 'httpclient'
require 'rexml/document'
require 'nokogiri'

# http://sqlrest.sourceforge.net/5-minutes-guide.htm

describe "REST WebService" do
  include TestHelper


  it "REST - List all records" do
    http = HTTPClient.new
    list_rest_url = "http://www.thomas-bayer.com/sqlrest/CUSTOMER"
    resp = http.get(list_rest_url)
    debug resp.body
    File.open("C:/temp/rest.xml", "w").puts(resp.body) if RUBY_PLATFORM =~ /mingw/
    xml_doc  = REXML::Document.new(resp.body)
    expect(xml_doc.root.elements.size).to be > 10    
  end

  it "REST - Get a record" do
    http = HTTPClient.new
    customer_id = 4
    get_rest_url = "http://www.thomas-bayer.com/sqlrest/CUSTOMER/#{customer_id}"    
    resp = http.get(get_rest_url)
    expect(resp.body).to include("<CITY>Brisbane</CITY>")
  end
    
end
