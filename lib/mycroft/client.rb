require 'celluloid/io'
require 'celluloid/autostart'

module Mycroft
  class Client
    include Celluloid::IO
    include Messages

    finalizer :shutdown

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
        wait_readable(@client)
        size = @client.readline
        data = @client.read(size.to_i)
        receive_data(data)
      end
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