class HomePage

  def initialize
    @lbl_search_bar = { id: 'NTPHomeFakeOmniboxAccessibilityID' }
    @txt_search_bar = {id: 'Address'}
  end

  def search(url)
    PageHelper.click_element(@lbl_search_bar)
    PageHelper.fill_text_field(@txt_search_bar, url)
    PageHelper.hide_keyboard('go')
  end

end
