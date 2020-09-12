require "minitest/autorun"
require "minitest/spec"
require "minitest/reporters"
require "docker_volume_local"

require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = "test/fixtures/vcr"
  config.hook_into :excon # Excon is loaded by docker-api.
end

require 'test_mocks'

DockerVolumeLocal.configure ssh_key: "~/.ssh/id_rsa"

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
