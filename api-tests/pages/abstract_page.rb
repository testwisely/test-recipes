# This is the parent page for all page objects, for operations across all pages, define here
class AbstractPage

  def initialize(driver, text = nil)
    @driver = driver
    # driver.page_source.should include(text) if @driver && text
  end

  def browser
    @browser
  end

  def driver
    @driver
  end

end
