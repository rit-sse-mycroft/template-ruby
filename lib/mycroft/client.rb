require 'eventmachine'

module Mycroft
  class Client < EventMachine::Connection
    include Messages
    def post_init
      puts 'Connected to Mycroft'
      connect_to_mycroft
      send_manifest(nil, manifest)
    end

    def receive_data(data)

    end

    def unbind
      puts 'Disconnected from Mycroft'
    end
  end
end