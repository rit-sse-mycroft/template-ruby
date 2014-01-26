require 'socket'
require 'io/wait'

module Mycroft
  class Client
    include Messages

    def initialize(host, port)
      @host = host
      @port = port
      connect_to_mycroft
      puts 'Connected to mycroft'
      if @threaded
        Thread.new do
          setup
        end
      else
        setup
      end
    end

    def setup
      send_manifest
      connect
      run
    end

    def run
      loop do
        if @client.ready?
          size = @client.readline
          data = @client.read(size.to_i)
          receive_data(data)
        end
        on_event_loop if methods.include?(:on_event_lopp)
      end
    ensure
      shutdown
    end

    def receive_data(data)
      parsed = parse_message(data)
      puts "Recieved #{parsed}"
      if parsed[:type] == 'APP_MANIFEST_OK' || parsed[:type] == 'APP_MANIFEST_FAIL'
        check_manifest(parsed)
        @verified = true
      end
      on_data(parsed)
    end

    def shutdown
      on_end
      down
      puts 'Disconnected from Mycroft'
      @client.close
    end
  end
end