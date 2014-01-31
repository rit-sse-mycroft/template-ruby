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
      instance_eval &@@handlers['connect'] unless @@handlers['end'].nil?
      run
    end

    def self.on(type, &block)
      @@handlers ||= {}
      @@handlers[type] = block
    end

    def run
      loop do
        if @client.ready?
          size = @client.readline
          data = @client.read(size.to_i)
          parsed = parse_message(data)
          puts "Recieved #{parsed[:type]}"
          unless @@handlers[parsed[:type]].nil?
            instance_exec(parsed[:data], &@@handlers[parsed[:type]])
          else
            puts "Not handling message: #{parsed[:type]}"
          end
        end
        on_event_loop if methods.include?(:on_event_loop)
      end
    ensure
      shutdown
    end

    def shutdown
      instance_eval &@@handlers['end'] unless @@handlers['end'].nil?
      down
      puts 'Disconnected from Mycroft'
      @client.close
    end

    on 'APP_MANIFEST_OK' do |data|
      @verified = true
      puts 'Manifest Verified'
    end

    on 'APP_MANIFEST_FAIL' do |data|
      raise 'Invalid application manifest'
    end
  end
end