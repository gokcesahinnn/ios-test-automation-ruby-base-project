module PageHelper

  def self.find(locator, wait: BaseConfig.wait_time)
    wait_true(timeout: wait, message: "NoSuchElementError: #{locator}") do
      find_element(locator)
    end
  end

  def self.click_element(locator)
    find(locator).click
  end

  def self.fill_text_field(locator, text)
    mobile_element = find(locator)
    mobile_element.clear
    mobile_element.send_keys(text)
  end

  def self.tab_and_send_keys(locator, key)
    mobile_element = find(locator)
    driver.execute_script('mobile: tap', { element: mobile_element, x: mobile_element.location.x, y: mobile_element.location.y })
    mobile_element.send_keys(key)
  end

  def self.wait_until_visible(locator, wait: BaseConfig.moderate_wait_time)
    wait_true(timeout: wait) do
      find_element(locator).attribute('visible').eql?('true')
    end
  end

  def self.wait_until_enabled(locator, wait: BaseConfig.moderate_wait_time)
    wait_true(timeout: wait) do
      find_element(locator).attribute('enabled').eql?('true')
    end
  end

  def self.wait_until_accessible(locator, wait: BaseConfig.moderate_wait_time)
    wait_true(timeout: wait) do
      find_element(locator).attribute('accessible').eql?('true')
    end
  end

  def self.back_until_element(locator)
    count = 5
    visible = false
    while count.positive?
      begin
        visible = find(locator, wait: 5).attribute('visible').eql?('true') ? true : raise
        count = 0
      rescue StandardError
        back
        count -= 1
      end
    end
    raise "Element not found locator: #{locator} " if count.zero? && visible == false
  end

  def self.locator_string_format(locator, message)
    temp = Hash.new
    locator.each do |key, value|
      temp[key] = value % message
    end
    temp
  end

  def self.single_tap(x_coordinate, y_coordinate)
    driver.execute_script('mobile: tap', { x: x_coordinate, y: y_coordinate })
  end

  def self.get_element_location(locator)
    find(locator).location
  end

  def self.get_element_size(locator)
    find(locator).size
  end

  def self.accept_alert(btn_label)
    driver.execute_script('mobile: alert', { 'action': 'accept', 'buttonLabel': btn_label })
  end

  def self.check_toggle_button(locator)
    element = find(locator)
    $wait.until { element.displayed? }
    element.click if element.attribute('checked') == 'false'
    $wait.until { element.attribute('checked') == 'true' }
  end

  def self.uncheck_toggle_button(locator)
    element = find(locator)
    $wait.until { element.displayed? }
    element.click if element.attribute('checked') == 'true'
    $wait.until { element.attribute('checked') == 'false' }
  end

  def self.element_enabled(locator, wait: BaseConfig.moderate_wait_time)
    @is_element = true
    begin
      wait_true(timeout: wait, message: "NoSuchElementError: #{locator}") do
        find_element(locator).enabled?
      end
    rescue StandardError
      @is_element = false
    end
    @is_element
  end

  def self.element_accessible_info(locator, wait: BaseConfig.moderate_wait_time)
    @accessible_info = true
    begin
      wait_true(timeout: wait, message: "NoSuchElementError: #{locator}") do
        find_element(locator).attribute('accessible').eql?('true')
      end
    rescue StandardError
      @accessible_info = false
    end
    @accessible_info
  end

  def self.swipe_until_element(locator, type)
    count = 5
    visible = false
    while count.positive?
      begin
        visible = find(locator, wait: 2).attribute('enabled').eql?('true') ? true : raise
        count = 0
      rescue StandardError
        case type
        when "down"
          swipe_down
        when "up"
          swipe_up
        when "right"
          swipe_right
        when "left"
          swipe_left
        end
        count -= 1
      end
    end
    raise "Element not found locator: #{locator} " if count.zero? && visible == false
  end

  def self.swipe_down_until_element(locator)
    swipe_until_element(locator, "down")
  end

  def self.swipe_up_until_element(locator)
    swipe_until_element(locator, "up")
  end

  def self.swipe_right_until_element(locator)
    swipe_until_element(locator, "right")
  end

  def self.swipe_left_until_element(locator)
    swipe_until_element(locator, "left")
  end

  def self.swipe_to_between_locators(locator_start, locator_end)
    el_start = find(locator_start)
    el_end = find(locator_end)
    f1 = ::Selenium::WebDriver::Interactions.pointer(:touch, name: 'finger1')
    f1.create_pointer_move(duration: 0, x: el_start.location.x, y: el_start.location.y)
    f1.create_pointer_down(0)
    f1.create_pause(0.5)
    f1.create_pointer_move(duration: 1, x: el_end.location.x, y: el_end.location.y)
    f1.create_pointer_up(0)
    driver.perform_actions [f1]
  end

  def self.swipe_in_element(type, element)
    driver.execute_script 'mobile: swipe', direction: type, element: find(element)
  end

  def self.scroll_in_element(type, element)
    driver.execute_script 'mobile: scroll', direction: type, element: find(element)
  end

  def self.swipe_right
    window_width = window_size.width
    window_height = window_size.height
    f1 = ::Selenium::WebDriver::Interactions.pointer(:touch, name: 'finger1')
    f1.create_pointer_move(duration: 0, x: (window_width * 0.8).to_int, y: (window_height * 0.15).to_int)
    f1.create_pointer_down(0)
    f1.create_pause(0.5)
    f1.create_pointer_move(duration: 1, x: (window_width * 0.2).to_int, y: (window_height * 0.15).to_int)
    f1.create_pointer_up(0)
    driver.perform_actions [f1]
  end

  def self.swipe_left
    window_width = window_size.width
    window_height = window_size.height
    f1 = ::Selenium::WebDriver::Interactions.pointer(:touch, name: 'finger1')
    f1.create_pointer_move(duration: 0, x: (window_width * 0.2).to_int, y: (window_height * 0.15).to_int)
    f1.create_pointer_down(0)
    f1.create_pause(0.5)
    f1.create_pointer_move(duration: 1, x: (window_width * 0.8).to_int, y: (window_height * 0.15).to_int)
    f1.create_pointer_up(0)
    driver.perform_actions [f1]
  end

  def self.swipe_down_until_element_visible(locator)
    count = 10
    visible = false
    while count.positive?
      begin
        visible = find(locator, wait: 2).attribute('visible').eql?('true') ? true : raise
        count = 0
      rescue StandardError
        swipe_down
        count -= 1
      end
    end
    raise "Element not found locator: #{locator} " if count.zero? && visible == false
  end

  def self.scroll_in_element_until_element_visible(locator, type, in_element)
    count = 5
    visible = false
    while count.positive?
      begin
        if find(locator, wait: 2).attribute('visible').eql?('true')
          visible = true
        else
          raise
        end
        count = 0
      rescue StandardError
        scroll_in_element(type, in_element)
        count -= 1
      end
    end
    raise "Element not found locator: #{locator} " if count.zero? && visible == false
  end

  def self.swipe_multiple_times(scroll_times)
    count = scroll_times
    while count.positive?
      swipe_down
      count -= 1
    end
  end

  def self.swipe_down
    window_width = window_size.width
    window_height = window_size.height
    f1 = ::Selenium::WebDriver::Interactions.pointer(:touch, name: 'finger1')
    f1.create_pointer_move(duration: 0, x: (window_width * 0.05).to_int, y: (window_height * 0.65).to_int)
    f1.create_pointer_down(0)
    f1.create_pause(0.5)
    f1.create_pointer_move(duration: 1, x: (window_width * 0.05).to_int, y: (window_height * 0.1).to_int)
    f1.create_pointer_up(0)
    driver.perform_actions [f1]
  end

  def self.swipe_up
    window_width = window_size.width
    window_height = window_size.height
    f1 = ::Selenium::WebDriver::Interactions.pointer(:touch, name: 'finger1')
    f1.create_pointer_move(duration: 0, x: (window_width * 0.05).to_int, y: (window_height * 0.1).to_int)
    f1.create_pointer_down(0)
    f1.create_pause(0.5)
    f1.create_pointer_move(duration: 1, x: (window_width * 0.05).to_int, y: (window_height * 0.65).to_int)
    f1.create_pointer_up(0)
    driver.perform_actions [f1]
  end

  def self.verify_no_element(locator, wait: BaseConfig.moderate_wait_time)
    @has_element = false
    begin
      wait_true(timeout: wait, message: "NoSuchElementError: #{locator}") do
        find_element(locator).enabled?
      end
    rescue StandardError
      @has_element = true
    end
    @has_element
  end

  def self.back_on_page
    @driver.back
  end

  def self.hide_keyboard(key_name)
    self.driver.hide_keyboard(key_name)
  end

  def self.swipe_picker_wheel(locator, order: 'next')
    date_picker = find_element(locator)
    select_picker_wheel(element: date_picker, order: order, offset: 0.15)
  end

  def self.open_app(bundle_id)
    begin
      @driver.activate_app(bundle_id)
    rescue StandardError
      raise "#{bundle_id} application not found"
    end
  end

end

World(PageHelper)
