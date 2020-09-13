load File.dirname(__FILE__) + "/../test_helper.rb"

# NOTE, W3C's test services is down at the moment

require "net/http"
require "net/https"
require "erb"
require "savon"

describe "SOAP Testing with Httparty" do
  include TestHelper
  
  it "Use Soap Client - Savon library" do
    client = Savon.client(wsdl: "http://www.dneonline.com/calculator.asmx?wsdl", log: true)
    puts client.operations.inspect #  [:add, :subtract, :multiply, :divide]
    response = client.call(:add, message: { intA: 1, intB: 2 })
    expect(response.body[:add_response][:add_result]).to eq("3")
  end
  
end
