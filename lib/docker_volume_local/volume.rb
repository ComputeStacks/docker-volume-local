module DockerVolumeLocal
  class Volume < Connection

    attr_accessor :errors,
                  :instance # ComputeStacks Volume Object

    def initialize(obj)
      self.instance = obj
      self.errors = []
    end

    # @return [Boolean]
    def provisioned?
      Docker::Volume.get(instance.name, client).is_a? Docker::Volume
    rescue Docker::Error::NotFoundError
      false
    end

    # @return [Boolean]
    def create!
      return true if provisioned?
      vol_data = {
        'Labels' => {
          'name' => instance.name,
          'deployment_id' => instance.deployment.id.to_s,
          'service_id' => instance.container_service.id.to_s
        },
        'Driver' => 'local'
      }
      result = Docker::Volume.create(instance.name, vol_data, client)
      return true if result.is_a?(Docker::Volume)
      errors << result.inspect
      false
    end

    # @return [Boolean]
    def destroy!
      obj = Docker::Volume.get(instance.name, client)
      obj.remove({}, client).blank?
    rescue Docker::Error::NotFoundError
      true
    end

  end
end