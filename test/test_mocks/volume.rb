module TestMocks
  # @!attribute id
  #   @return [Integer]
  # @!attribute name
  #   @return [String]
  class Volume

    attr_accessor :id,
                  :name

    def initialize
      self.id = 10
      self.name = '690a2d87-08de-4834-8cff-cecce76ecb89'
    end

    # @return [TestMocks::Deployment]
    def deployment
      TestMocks::Deployment.new
    end

    # @return [Array]
    def nodes
      [
        TestMocks::Node.new
      ]
    end

    # @return [TestMocks::ContainerService]
    def container_service
      TestMocks::ContainerService.new
    end

  end
end