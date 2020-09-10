class RegionMock

  attr_accessor :volume_backend

  def initialize
    self.volume_backend = 'local'
  end

  def nfs_backend?
    false
  end

  def has_clustered_storage?
    false
  end

end