require 'test_helper'

describe DockerVolumeLocal::Volume do

  it 'can manage a volume' do

    vol = DockerVolumeLocal::Volume.new(TestMocks::Volume.new)

    VCR.use_cassette('volume.create') do
      assert vol.create!
    end

    VCR.use_cassette('volume.get') do
      assert vol.provisioned?
    end

    VCR.use_cassette('volume.destroy') do
      assert vol.destroy
    end

  end

end