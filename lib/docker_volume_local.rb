require "active_support"
require "active_support/core_ext/object/blank"
require 'docker'
require 'docker_volume_local/connection'
require 'docker_volume_local/errors'
require "docker_volume_local/version"
require 'docker_volume_local/volume'
require 'net/ssh'

module DockerVolumeLocal

  @config = {
    node_address: nil, # tcp://127.0.0.1:3306
    ssh_address: nil, # 127.0.0.1
    ssh_key: nil, # /path/to/ssh/key
    ssh_port: 22,
    ssh_user: 'root'
  }

  ##
  # Does this use the native Docker::Volume to create the volume?
  #
  # If true, ComputeStacks will use the docker volume API to build
  # this volume.
  #
  def native_docker_volume?
    true
  end

  def self.configure(opts = {})
    opts.each {|k,v| @config[k.to_sym] = v if @config.keys.include? k.to_sym}
  end

  def self.config
    @config
  end

end
