require_relative 'api_util'

class DownloadIpa

  @bitrise_header = { 'Content-Type' => 'application/json', "Authorization" => BitriseConfig.bitrise_token }

  def self.get_app_slug
    response = ApiUtil.get_request(BitriseConfig.bitrise_url, "/apps", @bitrise_header)
    $app_slug = response["data"][0]["slug"]
  end

  def self.get_build_info_with_build_number(build_number)
    query = {
      workflow: "#{BitriseConfig.bitrise_workflow_url}",
      status: "1",
      build_number: "#{build_number}",
      limit: "10" }
    response = ApiUtil.get_request_with_query(BitriseConfig.bitrise_url, "/apps/#{$app_slug}/builds",
                                              query,
                                              @bitrise_header)
    $builds_info = []
    if $build_number.nil?
      response['data'].each { |item| $builds_info << { build_slug: item['slug'], build_number: item['build_number'] } }
    else
      response['data'].each { |item| $builds_info << { build_slug: item['slug'], build_number: item['build_number'] } if item['build_number'] == build_number.to_i }
    end
  end

  def self.get_builds_artifacts_slug
    response_prod = ApiUtil.get_request("https://itunes.apple.com", "/lookup?bundleId=com.istegelsin.ios", { 'Content-Type' => 'application/json' }) if BaseConfig.environment == "prod"
    i = 0
    while i < $builds_info.size
      response = ApiUtil.get_request(BitriseConfig.bitrise_url, "/apps/#{$app_slug}/builds/#{$builds_info[i][:build_slug]}/artifacts",
                                     @bitrise_header)
      if BaseConfig.environment == "prod"
        if response["data"][2]["artifact_meta"]["app_info"]["version"] != JSON.parse(response_prod)["results"][0]["version"]
          i += 1
        else
          $version = JSON.parse(response_prod)["results"][0]["version"]
          break
        end
      else
        $version = response["data"][2]["artifact_meta"]["app_info"]["version"]
        break
      end
    end
    $artifact_slug = response["data"][2]["slug"]
    $build_number = $builds_info[i][:build_number]
    $build_slug = $builds_info[i][:build_slug]
  end

  def self.get_app_info
    response = ApiUtil.get_request(BitriseConfig.bitrise_url, "/apps/#{$app_slug}/builds/#{$build_slug}/artifacts/#{$artifact_slug}",
                                   @bitrise_header)
    $app_name = response["data"]["artifact_meta"]["app_info"]["app_title"]
    $ipa_url = response["data"]["expiring_download_url"]
  end

  def self.download_ipa_from_bitrise
    IO.copy_stream(URI.open($ipa_url), "apps/#{$app_name}-#{$version}-#{$build_number}.ipa")
  end

  def self.get_version_of_app(build_number: nil)
    get_app_slug
    get_build_info_with_build_number(build_number)
    get_builds_artifacts_slug
    get_app_info
  end

  def self.download_ipa
    $build_number = BaseConfig.build_no_of_release_version
    get_version_of_app(build_number: $build_number)
    file_name = Dir.children("apps/")
    if file_name != [] && file_name.to_s.scan(/\d+/).last.match?($build_number.to_s)
      IGLoggers.log_info("This version is already downloaded")
    else
      Dir.each_child("apps/") do |file|
        fn = File.join("apps/", file)
        File.delete(fn)
      end
      download_ipa_from_bitrise
    end
  end
end