require 'em/pure_ruby'
require 'appium_lib'
require 'rspec'
require 'yaml'
require 'allure-cucumber'
require 'faker'
require 'selenium-webdriver'
require 'open-uri'

require_relative '../../features/pages/base_page'
Dir["#{Dir.pwd}/config/**/*.rb"].each { |file| require_relative file }
Dir["#{Dir.pwd}/global/*.rb"].each { |file| require_relative file }
Dir["#{Dir.pwd}/util/**/*.rb"].each { |file| require_relative file }
Dir["#{Dir.pwd}/resources/**/*.rb"].each { |file| require_relative file }
Dir["#{Dir.pwd}/model/**/*.rb"].each { |file| require_relative file }
Dir["#{Dir.pwd}/context/**/*.rb"].each { |file| require_relative file }

#Bitrise'dan son basarili builde sahip sürüm bilgisini alıp download eder.
#DownloadIpa.download_ipa

case BaseConfig.device_type
when 'local'
  $CAPS = YAML.load_file(File.expand_path("./config/device/device_config.yml"))
  # `ios-deploy --bundle "#{Dir.pwd}/apps/#{$app_name}-#{$version}-#{$build_number}.ipa"`
  $CAPS[:caps][:udid] = `idevice_id -l`.strip
  $CAPS[:caps][:deviceName] = `idevicename`.strip
  $CAPS[:caps][:platformVersion] = `ideviceinfo -u $(idevice_id) | grep ProductVersion`.strip.split(" ")[1]
when 'simulator'
  $CAPS = YAML.load_file(File.expand_path("./config/device/device_config.yml"))
  $CAPS[:caps][:udid] = `xcrun simctl getenv booted  SIMULATOR_UDID`.strip
  $CAPS[:caps][:deviceName] = `xcrun simctl getenv booted  SIMULATOR_DEVICE_NAME`.strip
  $CAPS[:caps][:platformVersion] = `xcrun simctl getenv booted  SIMULATOR_RUNTIME_VERSION`.strip
else
  $CAPS = YAML.load_file(File.expand_path("./config/experitest/experitest_config.yml"))
  $CAPS[:caps][:accessKey] = ExperitestConfig.experitest_access_key
  $CAPS[:appium_lib][:server_url] = "#{ExperitestConfig.experitest_url}/wd/hub"
end

begin
  Appium::Driver.new($CAPS, true)
  Appium.promote_appium_methods Object

rescue Exception => e
  puts e.message
  Process.exit(0)
end

AllureCucumber.configure do |c|
  c.issue_prefix = 'JIRA:'
end

Allure.configure do |c|
  c.results_directory = 'output/allure-results'
  c.clean_results_directory = true
  c.environment_properties = {
    env: "#{BaseConfig.environment}",
    release_version: "#{BaseConfig.release_version}",
  }
end

$wait = Selenium::WebDriver::Wait.new timeout: 60
Selenium::WebDriver.logger.level = :error