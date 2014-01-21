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
      end
    ensure
      shutdown
    end

    def receive_data(data)
      parsed = parse_message(data)
      puts "Recieved #{parsed[:type]}"
      if parsed[:type] == 'APP_MANIFEST_OK' || parsed[:type] == 'APP_MANIFEST_FAIL'
        check_manifest(parsed)
        @verified = true
      end
      on_data(parsed)
    end

    def shutdown
      puts 'Disconnected from Mycroft'
      @client.close
      on_end
    end
  end
end