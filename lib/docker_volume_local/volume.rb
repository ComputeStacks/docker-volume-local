module DockerVolumeLocal
  # @!attribute errors
  #   @return [Array]
  # @!attribute instance
  #   @return [TestMocks::Volume]
  class Volume

    attr_accessor :errors,
                  :instance

    # @param [TestMocks::Volume]
    def initialize(instance)
      self.instance = instance
      self.errors = []
    end

    # @return [Boolean]
    def provisioned?
      result = true
      instance.nodes.each do |node|
        result = docker_client(node).is_a?(Docker::Volume)
        break unless result # halt if failed
      end
      result
    end

    # @return [Boolean]
    def create!
      raise VolumeError, 'Missing Volume' if instance.nil?
      instance.nodes.each do |node|
        result = Docker::Volume.create(instance.name, volume_data, DockerVolumeLocal::Node.new(node).client)
        unless result.is_a?(Docker::Volume)
          errors << "Fatal error provisioning volume on node: #{node.label}"
          return false
        end
      end
      errors.empty?
    end

    # @return [Boolean]
    def destroy
      success = true
      instance.nodes.each do |node|
        client = DockerVolumeLocal::Node.new(node).client
        success = docker_client(node).remove({}, client).blank?
        break unless success
      end
      errors << "Error removing volume from docker. Volume still exists on remote server." unless success
      success
    rescue Docker::Error::NotFoundError
      true
    end

    private

    # @return [Hash]
    def volume_data
      {
        'Labels' => {
          'name' => instance.name,
          'deployment_id' => instance.deployment.id.to_s,
          'service_id' => instance.container_service.id.to_s
        },
        'Driver' => 'local'
      }
    end

    # @return [Docker::Volume]
    def docker_client(node)
      Docker::Volume.get(instance.name, DockerVolumeLocal::Node.new(node).client)
    end

  end
end