module DockerVolumeLocal
  class Volume < Connection

    attr_accessor :id,
                  :labels,
                  :errors


    def initialize(id, labels = {})
      raise VolumeError, 'Missing Volume ID' if id.blank?
      self.id = id
      self.labels = labels
      self.errors = []
    end

    # @return [Boolean]
    def provisioned?
      Docker::Volume.get(id, client).is_a? Docker::Volume
    rescue Docker::Error::NotFoundError
      false
    end

    # @return [Boolean]
    def create!
      return true if provisioned?
      vol_data = {
        'Labels' => labels,
        'Driver' => 'local'
      }
      result = Docker::Volume.create(id, vol_data, client)
      return true if result.is_a?(Docker::Volume)
      errors << result.inspect
      false
    end

    # @return [Boolean]
    def destroy!
      obj = Docker::Volume.get(id, client)
      obj.remove({}, client).blank?
    rescue Docker::Error::NotFoundError
      true
    end

  end
end