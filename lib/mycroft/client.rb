require 'socket'
require 'io/wait'

module Mycroft
  class Client
    include Messages

    def initialize(host, port)
      @host = host
      @port = port
      @name ||= 'mycroft'
      connect_to_mycroft
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
      instance_eval &@@handlers['connect'] unless @@handlers['connect'].nil?
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
          unless @@handlers[parsed[:type]].nil?
            instance_exec(parsed[:data], &@@handlers[parsed[:type]])
          else
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
      @client.close
    end

    on 'APP_MANIFEST_OK' do |data|
      @verified = true
    end

    on 'APP_MANIFEST_FAIL' do |data|
      raise 'Invalid application manifest'
    end

    on 'MSG_GENERAL_FAILURE' do |data|
    end
  end
end