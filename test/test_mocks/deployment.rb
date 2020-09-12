module TestMocks
  # @!attribute id
  #   @return [Integer]
  # @!attribute name
  #   @return [String]
  # @!attribute token
  #   @return [String]
  class Deployment

    attr_accessor :id,
                  :name,
                  :token

    def initialize
      self.id = 1
      self.name = "Test"
      self.token = 'Foo Bar'
    end

    # @return [Array]
    def container_services
      [
        TestMocks::ContainerService.new
      ]
    end

  end
end