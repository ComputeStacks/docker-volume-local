require 'test_helper'

describe DockerVolumeLocal::Node do

  it 'can connect to docker' do
    VCR.use_cassette('node.online') do
      assert DockerVolumeLocal::Node.new(TestMocks::Node.new).online?
    end
  end

  it 'can retrieve node usage' do
    VCR.use_cassette('node.usage') do
      refute DockerVolumeLocal::Node.new(TestMocks::Node.new).usage.empty?
    end
  end

  it 'can list all volumes on a node' do
    VCR.use_cassette('node.list_all_volumes') do
      refute_empty DockerVolumeLocal::Node.new(TestMocks::Node.new).list_all_volumes
    end
  end

end