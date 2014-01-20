require 'eventmachine'

module Mycroft
  class Client < EventMachine::Connection
    include Messages
    def post_init
      puts 'Connected to Mycroft'
      connect_to_mycroft
      send_manifest
      connect
    end

    def receive_data(data)
      parsed = parse_message(data)
      if parsed[:type] == 'APP_MANIFEST_OK' || parsed[:type] == 'APP_MANIFEST_FAIL'
        check_manifest(parsed)
        @verified = true
      end
      on_data(parsed)
    end

    def unbind
      puts 'Disconnected from Mycroft'
      on_end
    end
  end
end