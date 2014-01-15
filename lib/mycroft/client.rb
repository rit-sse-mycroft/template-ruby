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
      on_data(data)
    end

    def unbind
      puts 'Disconnected from Mycroft'
      on_end
    end
  end
end