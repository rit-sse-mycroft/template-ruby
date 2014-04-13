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
    rescue Exception => e
      instance_exec(e, &@@handlers['ERROR']) unless @@handlers['ERROR'].nil?
    end

    def setup
      send_manifest
      instance_eval &@@handlers['CONNECT'] unless @@handlers['CONNECT'].nil?
      run
    end

    def self.on(type, &block)
      @@handlers ||= {}
      @@handlers[type] = block
    end

    def run
      loop do
        size = @client.readline
        data = @client.read(size.to_i)
        parsed = parse_message(data)
        unless @@handlers[parsed[:type]].nil?
          instance_exec(parsed[:data], &@@handlers[parsed[:type]])
        end
        on_event_loop if methods.include?(:on_event_loop)
      end
    ensure
      shutdown
    end

    def shutdown
      instance_eval &@@handlers['CONNECTION_CLOSED'] unless @@handlers['CONNECTION_CLOSED'].nil?
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
      raise data.message
    end

    on 'APP_DEPENDENCY' do |data|
      update_dependencies(data)
    end
  end
end