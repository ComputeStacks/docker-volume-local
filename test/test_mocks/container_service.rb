module TestMocks
  class ContainerService

    attr_accessor :id,
                  :name

    def initialize
      self.id = 1
      self.name = 'test'
    end

    def deployment
      TestMocks::Deployment.new
    end

  end
end