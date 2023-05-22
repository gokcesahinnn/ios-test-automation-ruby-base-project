module BaseConfig

  @short_wait_time = 5
  def self.short_wait_time
    @short_wait_time
  end

  @moderate_wait_time = 10
  def self.moderate_wait_time
    @moderate_wait_time
  end

  @wait_time = 25
  def self.wait_time
    @wait_time
  end

  @long_wait_time = 60
  def self.long_wait_time
    @long_wait_time
  end

  @device_type = ENV['device_type'] || 'local'
  #     Available options
  #       * local - runs on the local connected device
  #       * simulator - runs on the local connected simulator
  #       * cloud_public - runs on the public device cloud environment
  #       * cloud_private - runs on the private device cloud environment
  def self.device_type
    @device_type
  end

  @environment = ENV['env'] || 'beta'
  #     Available options
  #       * beta - runs on the beta environment
  #       * prod - runs on the prod environment
  def self.environment
    @environment
  end

  @release_version = ENV['release_version']
  def self.release_version
    @release_version
  end

  @build_no_of_release_version = ENV['build_number']
  def self.build_no_of_release_version
    @build_no_of_release_version
  end

end