require "rubygems"
require "selenium-webdriver"
require "rspec"
require "active_support/all"
require "faker"

# use utils in RWebSpec and better integration with TestWise
require "#{File.dirname(__FILE__)}/agileway_utils.rb"

# when running in TestWise, it will auto load TestWiseRuntimeSupport, ignore otherwise
if defined?(TestWiseRuntimeSupport)
  ::TestWise::Runtime.load_webdriver_support # for selenium webdriver support
end

# The default base URL for running from command line or continuous build process
$BASE_URL = "http://localhost:8080"

# This is the helper for your tests, every test file will include all the operation
# defined here.
module TestHelper
  include AgilewayUtils

  if defined?(TestWiseRuntimeSupport) # TestWise 5+
    include TestWiseRuntimeSupport
  end

  def debugging?
    # return ENV["RUN_IN_TESTWISE"].to_s == "true" && ENV["TESTWISE_RUNNING_AS"] == "test_case"

    if (ENV["TESTWISE_DEBUGGING"].to_s == "true" || ENV["RUN_IN_TESTWISE"].to_s == "true") && ENV["TESTWISE_RUNNING_AS"] == "test_case"
      return true
    end
    return $TESTWISE_DEBUGGING && $TESTWISE_RUNNING_AS == "test_case"
  end

  #
  # An Example helper function
  #
  # In you test case, you can use
  #
  #   login_as("homer", "Password")
  #   login_as("bart")  # the password will be default to 'TestWise'
  #   login("lisa")     # same as login_as
  #
  #
  # def login_as(username, password = "TestWise")
  #   enter_text("username", username)
  #   enter_text("password", password)
  #   click_link("Login")
  # end
  # alias login login_as

  def browser_type
    if $TESTWISE_BROWSER
      $TESTWISE_BROWSER.downcase.to_sym
    elsif ENV["BROWSER"]
      ENV["BROWSER"].downcase.to_sym
    else
      "chrome".to_sym
    end
  end

  alias the_browser browser_type

  def download_path
    the_dowonload_path = RUBY_PLATFORM =~ /mingw/ ? "C:\\TEMP" : "/Users/zhimin/tmp"
  end

  def browser_options
    the_browser_type = browser_type.to_s

    if the_browser_type == "chrome"
      the_chrome_options = Selenium::WebDriver::Chrome::Options.new
      # make the same behaviour as Python/JS
      # leave browser open until calls 'driver.quit'
      the_chrome_options.add_option("detach", true)
      
      # old way
      # prefs = {
      #  :prompt_for_download => false,
      #  :default_directory => download_path,
      #}
      # the_chrome_options.add_preference(:download, prefs)
            
      the_chrome_options.add_preference("download.prompt_for_download", false)
      the_chrome_options.add_preference("download.default_directory", download_path)
      
      if $TESTWISE_BROWSER_HEADLESS || ENV["BROWSER_HEADLESS"] == "true"
        the_chrome_options.add_argument("--headless")
      end

      if defined?(TestWiseRuntimeSupport)
        browser_debugging_port = get_browser_debugging_port() rescue 19218 # default port
        puts("Enabled chrome browser puts port: #{browser_debugging_port}")
        the_chrome_options.add_argument("--remote-debugging-port=#{browser_debugging_port}")
      else
        # puts("Chrome debugging port not enabled.")
      end

      return :options => the_chrome_options

    elsif the_browser_type == "firefox"
      the_firefox_options = Selenium::WebDriver::Firefox::Options.new
      if $TESTWISE_BROWSER_HEADLESS || ENV["BROWSER_HEADLESS"] == "true"
        the_firefox_options.add_argument("--headless")
      end
      return :options => the_firefox_options
    elsif the_browser_type == "ie"
      the_ie_options = Selenium::WebDriver::IE::Options.new
      if $TESTWISE_BROWSER_HEADLESS || ENV["BROWSER_HEADLESS"] == "true"
        # not supported yet?
        # the_ie_options.add_argument('--headless')
      end
      return :options => the_ie_options
    else
      return {}
    end
  end
    

  def site_url(default = $BASE_URL)
    $TESTWISE_PROJECT_BASE_URL || ENV["BASE_URL"] || default
  end

  def site_env
    the_site_url = site_url
    if the_site_url =~ /localhost/
      return "local"
    else
      return nil
    end
  end
  

  def driver
    @driver
  end

  alias browser driver

  def page_text
    driver.find_element(:tag_name => "body").text
  end

  def page_body_html
    elem = driver.find_element(:tag_name, "body")
    elem_html = driver.execute_script("return arguments[0].outerHTML;", elem)
  end

  def visit(path)
    driver.navigate.to(site_url + path)
  end

end
