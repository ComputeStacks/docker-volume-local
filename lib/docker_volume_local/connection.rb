module DockerVolumeLocal
  class Connection

    ##
    # Simple test to ensure we can connect to the required resources
    #
    # @return [Boolean]
    def online?
      Docker.ping(client) == 'OK' && !remote_exec('date').blank?
    end

    ##
    # Calculates all usage for a given ssh instance
    # @return [Array]
    def usage
      data = remote_exec %q(sudo bash -c 'du --block-size 1024 -s /var/lib/docker/volumes/*')
      data.gsub("/var/lib/docker/volumes/","").split("\n").map {|i| i.split("\t")}.map {|i,k| {size: i.strip, id: k.strip} }
    rescue
      []
    end

    protected

    ##
    # Provide a Docker Client
    #
    # @return [Docker::Connection]
    def client
      raise Error, 'Missing Docker Configuration' if DockerVolumeLocal.config[:node_address].nil?
      opts = Docker.connection.options
      opts[:connect_timeout] = 15
      opts[:read_timeout] = 75
      opts[:write_timeout] = 75
      Docker::Connection.new(DockerVolumeLocal.config[:node_address], opts)
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

    private

    # @return [Connection::Session]
    def ssh_client
      Net::SSH.start(
        DockerVolumeLocal.config[:ssh_address],
        DockerVolumeLocal.config[:ssh_user],
        keys: [ DockerVolumeLocal.config[:ssh_key] ],
        user_known_hosts_file: '/dev/null',
        auth_methods: ['publickey'],
        port: DockerVolumeLocal.config[:ssh_port]
      )
    rescue Net::SSH::AuthenticationFailed
      raise SSHError, 'SSH Authentication Failed'
    rescue => e
      raise SSHError, "Fatal error: #{e.message}"
    end

  end
end