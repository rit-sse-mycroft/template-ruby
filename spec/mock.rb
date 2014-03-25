require 'stringio'
module Mycroft
  class MockClient
    def initialize(server)
      @server = server
    end
    def write(bytes)
      @server.stream.write(bytes)
    end
  end

  class MockServer
    attr_reader :stream

    def initialize
      @stream = StringIO.new
    end

    def read
      @stream.rewind
      size = @stream.readline
      message = @stream.read(size.to_i)
      {size: size.to_i, message: message}
    end
  end

  class MockMycroftClient
    include Messages

    attr_accessor :server, :dependencies

    def initialize
      @dependencies = {}
      @server = MockServer.new
      @client = MockClient.new(@server)
    end
  end
end