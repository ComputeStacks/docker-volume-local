require 'test_helper'

describe DockerVolumeLocal::Volume do

  it 'can manage a local volume' do

    vol = DockerVolumeLocal::Volume.new('690a2d87-08de-4834-8cff-cecce76ecb89', {
      'name' => '690a2d87-08de-4834-8cff-cecce76ecb89',
      'deployment_id' => '10',
      'service_id' => '10'
    })

    VCR.use_cassette('volume.create') do
      assert vol.create!
    end

    VCR.use_cassette('volume.delete') do
      assert vol.destroy!
    end


  end

end