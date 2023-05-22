class SearchPage

  def initialize
    @lbl_search_result_title = { class_chain: '**/XCUIElementTypeLink[`label CONTAINS "%s"`]' }
  end

  def verify_search_result
    PageHelper.element_enabled(PageHelper.locator_string_format(@lbl_search_result_title, $searched_word)).should == true
    self
  end
end