module TestMocks
  # @!attribute id
  #   @return [Integer]
  # @!attribute primary_ip
  #   @return [String]
  # @!attribute ssh_port
  #   @return [Integer]
  class Node

    attr_accessor :id,
                  :primary_ip,
                  :ssh_port

    def initialize
      self.id = 1
      self.primary_ip = '192.168.173.10'
      self.ssh_port = 22
    end

  end
end