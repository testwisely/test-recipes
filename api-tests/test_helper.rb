require 'rubygems'
require 'selenium-webdriver'
require 'rspec'

# when running in TestWise, it will auto load TestWiseRuntimeSupport
# otherwise, ignore
if defined?(TestWiseRuntimeSupport)
  ::TestWise::Runtime.load_webdriver_support # for selenium webdriver support
end
require "#{File.dirname(__FILE__)}/testwise_support.rb"

# this loads defined page objects under pages folder
require "#{File.dirname(__FILE__)}/pages/abstract_page.rb"
Dir["#{File.dirname(__FILE__)}/pages/*_page.rb"].each { |file| load file }

# The default base URL for running from command line or continuous build process

$BASE_URL = "file://#{File.join(File.dirname(__FILE__), 'site', 'index.html')}" 

# $BASE_URL = "file:///Users/zhimin/work/books/SeleniumRecipes/sources/site/index.html"
#$TESTWISE_BROWSER = :chrome

# This is the helper for your tests, every test file will include all the operation
# defined here.
module TestHelper

  if defined?(TestWiseRuntimeSupport)  # TestWise 5
    include TestWiseRuntimeSupport 
  else
    include TestWiseSupport
  end

  def browser_type
    if $TESTWISE_BROWSER then
      $TESTWISE_BROWSER.downcase.to_sym
    else
      RUBY_PLATFORM =~ /mingw/ ? "chrome".to_sym : "firefox".to_sym
    end
  end
  alias the_browser browser_type

  def site_url(default = $BASE_URL)
    
    the_site_url = $TESTWISE_PROJECT_BASE_URL || default
    # puts "SITE_URL => #{the_site_url}"
    return the_site_url
  end
	
	def browser
		@driver
	end
	
	def driver
		@driver
	end

  def page_text
    driver.find_element(:tag_name => "body").text
  end
  
end
