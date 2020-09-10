require_relative 'container_service_mock'
require_relative 'project_mock'
require_relative 'region_mock'

class VolumeMock

  attr_accessor :id,
                :name


  def initialize
    self.id = 10
    self.name = '690a2d87-08de-4834-8cff-cecce76ecb89'
  end

  def deployment
    ProjectMock.new
  end

  def container_service
    ContainerServiceMock.new
  end

  def region
    RegionMock.new
  end


end