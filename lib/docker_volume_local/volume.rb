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
        next unless node.online?
        result = docker_client(node).is_a?(Docker::Volume)
        break unless result # halt if failed
      end
      result
    end

    # @return [Boolean]
    def create!
      raise VolumeError, 'Missing Volume' if instance.nil?
      instance.nodes.each do |node|
        next unless node.online?
        next unless docker_client(node).nil?
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
        next unless node.online?
        client = DockerVolumeLocal::Node.new(node).client
        vol_client = docker_client(node)
        next if vol_client.nil?
        success = vol_client.remove({}, client).blank?
        break unless success
      end
      errors << "Error removing volume from docker. Volume still exists on remote server." unless success
      success
    end

    ##
    # Returns the volume usage in KB.
    def usage
      usage = 0
      instance.nodes.each do |node|
        data = DockerVolumeLocal::Node.new(node).remote_exec(
          %Q(sudo bash -c "du --total --block-size 1024 -s #{DockerVolumeLocal.config[:docker_volume_path]}/#{instance.name}/_data | grep total")
        )
        usage += data.split("\t")[0].strip.to_i
      end
      usage
    rescue
      nil
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
    rescue Docker::Error::NotFoundError
      nil
    end

  end
end