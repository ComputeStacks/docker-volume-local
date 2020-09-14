module DockerVolumeLocal
  # @!attribute instance
  #   @return [TestMocks::Node]
  class Node

    attr_accessor :instance # ComputeStacks Node

    # @param [TestMocks::Node] instance
    def initialize(instance)
      self.instance = instance
    end

    def usage
      data = remote_exec %Q(sudo bash -c 'du --block-size 1024 -s #{DockerVolumeLocal.config[:docker_volume_path]}/*')
      data.gsub("#{DockerVolumeLocal.config[:docker_volume_path]}/","").split("\n").map {|i| i.split("\t")}.map {|i,k| {size: i.strip, id: k.strip} }
    rescue
      []
    end

    def online?
      Docker.ping(client) == 'OK' && !remote_exec('date').blank?
    end

    ##
    # Provide a Docker Client
    #
    # @return [Docker::Connection]
    def client
      opts = Docker.connection.options
      opts[:connect_timeout] = 15
      opts[:read_timeout] = 75
      opts[:write_timeout] = 75
      Docker::Connection.new(connection_string, opts)
    end

    ##
    # Run a given command via SSH
    #
    # @return [String]
    def remote_exec(cmd)
      rsp = ''
      Timeout.timeout(300) do
        ssh = ssh_client
        ssh.exec!(cmd) do |_, _, line|
          rsp += line
        end
        ssh.close
      end
      rsp
    rescue Timeout::Error
      raise SSHError, 'SSH Timeout'
    end

    ##
    # Find all volumes on this node
    def list_all_volumes
      Docker::Volume.all({}, client)
    rescue
      []
    end

    private

    # @return [Connection::Session]
    def ssh_client
      raise SSHError, 'Missing SSH Key' if DockerVolumeLocal.config[:ssh_key].nil?
      Net::SSH.start(
        instance.primary_ip,
        'root',
        keys: [ DockerVolumeLocal.config[:ssh_key] ],
        user_known_hosts_file: '/dev/null',
        auth_methods: ['publickey'],
        port: instance.ssh_port
      )
    rescue Net::SSH::AuthenticationFailed
      raise SSHError, 'SSH Authentication Failed'
    rescue => e
      raise SSHError, "Fatal error: #{e.message}"
    end

    ##
    # Allow setting the primary_ip to a unix socket
    #
    # @return [String]
    def connection_string
      instance.primary_ip.split('://')[0] == 'unix' ? instance.primary_ip : "tcp://#{instance.primary_ip}:2376"
    end

  end
end
