require 'test_helper'

describe DockerVolumeLocal::Connection do

  before do
    DockerVolumeLocal.configure(
      node_address: "unix:///var/run/docker.sock",
      ssh_address: "192.168.173.10",
      ssh_key: "~/.ssh/id_rsa"
    )
  end

  it 'can connect to docker' do
    VCR.use_cassette('connection.online') do
      assert DockerVolumeLocal::Connection.new.online?
    end
  end

  it 'can determine volume usage' do
    refute_empty DockerVolumeLocal::Connection.new.usage
  end

end