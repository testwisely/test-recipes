load File.dirname(__FILE__) + '/../test_helper.rb'

require 'net/http'
require 'net/https'

describe "Parse XML" do
  include TestHelper

  it "Parse XML with REXML" do
    require "rexml/document"
    
    xml_string = <<EOF
  <Products>
    <Product>TestWise</Product>
    <Product>BuildWise</Product>
  </Products>
EOF
    doc = REXML::Document.new(xml_string)
    file = File.new(File.join(File.dirname(__FILE__), "../testdata", "books.xml"))
    doc = REXML::Document.new(file)
    
    # Accessing elements
    expect(doc.root.name).to eq("books")
    # expect(doc.root.elements["category"].size).to eq(2)
    
    # Creating an array of matching elements
    all_book_elems = doc.elements.to_a("//books/category/book/title" )
    all_book_titles = all_book_elems.collect{|x| x.text}
    expect(all_book_titles).to eq(["Practical Web Test Automation", "Selenium WebDriver Recipes in Ruby", "Learn Ruby Programming by Examples", "Learn Swift Programming by Examples"])

    # specific elmenent, 1-based
    second_book = doc.elements["//book[2]/title"].text
    puts "2nd => " + second_book
    
    # match first occurence
    first_programming_book = doc.elements["books/category[@name='Programming']/book/title"].text
    expect(first_programming_book).to eq("Learn Ruby Programming by Examples")
      
    # Gets an array of all of the "book" elements in the document.
    book_elems_array = REXML::XPath.match( doc, "//book" ) 
    expect(book_elems_array.size).to eq(4)    

    REXML::XPath.each(doc, "//category[@name='Test Automation']/book") { |book_elem|
      puts book_elem.elements["title"].text  # element text
      puts book_elem.attributes["isbn"]      # attribute value
    }
  end
  
  it "Parse XML with Nokogiri" do
    require 'nokogiri'
    file = File.join(File.dirname(__FILE__), "../testdata", "books.xml")
    doc = Nokogiri::XML(File.open(file))
    
    expect( doc.xpath("//book").count ).to eq(4)
    expect( doc.xpath("//book/title")[0].text).to eq("Practical Web Test Automation")        
  end
  
 
end
