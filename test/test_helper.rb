require "minitest/autorun"
require "minitest/spec"
require "minitest/reporters"
require "vcr"
require "docker_volume_local"

VCR.configure do |config|
  config.cassette_library_dir = "test/fixtures/vcr"
  config.hook_into :excon # Excon is loaded by docker-api.
end

DockerVolumeLocal.configure node_address: "unix:///var/run/docker.sock"

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
