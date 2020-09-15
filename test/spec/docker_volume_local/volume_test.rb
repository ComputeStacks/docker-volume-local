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

    refute_nil vol.usage

    VCR.use_cassette('volume.destroy') do
      assert vol.destroy
    end

  end

  ##
  # Manually test against a _real_ volume to see a size greater than 0
  # it 'can read volume usage' do
  #   cs_vol = TestMocks::Volume.new
  #   cs_vol.name = 'REAL-VOLUME-NAME'
  #   vol = DockerVolumeLocal::Volume.new cs_vol
  #   assert vol.usage > 0
  # end

end