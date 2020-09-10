require 'test_helper'

describe DockerVolumeLocal::Volume do

  it 'can manage a local volume' do

    vol = DockerVolumeLocal::Volume.new(VolumeMock.new)

    VCR.use_cassette('volume.create') do
      assert vol.create!
    end

    VCR.use_cassette('volume.delete') do
      assert vol.destroy!
    end


  end

end