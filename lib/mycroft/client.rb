require 'socket'
require 'io/wait'
require 'logger'
require 'yell'

module Yell #:nodoc:
  module Adapters #:nodoc:

    class Io < Yell::Adapters::Base
      TTYColors = {
        0   => "\033[0m",     # normal
        1   => "\033[1;36m",  # cyan
        2   => "\033[1;33m",  # yellow
        3   => "\033[1;31m",  # red
        4   => "\033[1;31m",  # red
        5   => "\033[1;31m",  # cyan
        -1  => "\033[0m"      # normal
      }
    end
  end
end

module Mycroft
  class Client
    include Messages

    def initialize(host, port)
      @host = host
      @port = port
      @name ||= 'mycroft'
      Dir.mkdir('logs') unless File.exists?('logs')
      @logger = Yell.new(format: Yell.format('%d [%5L] %m', '%Y-%m-%d %H:%M:%S' )) do |l|
        l.adapter :datefile, "logs/#{@name}.log"
        l.adapter :stdout, colors: true
      end
      connect_to_mycroft
      @logger.info('Connected to Mycroft')
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
          @logger.info "Got #{parsed[:type]}"
          @logger.debug "#{size.to_i} #{data}"
          unless @@handlers[parsed[:type]].nil?
            instance_exec(parsed[:data], &@@handlers[parsed[:type]])
          else
            @logger.warn "Not handling message: #{parsed[:type]}"
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
      @logger.info 'Disconnected from Mycroft'
      @client.close
    end

    on 'APP_MANIFEST_OK' do |data|
      @verified = true
      @logger.info 'Manifest Verified'
    end

    on 'APP_MANIFEST_FAIL' do |data|
      @logger.error 'Invalid application manifest'
      raise 'Invalid application manifest'
    end

    on 'MSG_GENERAL_FAILURE' do |data|
      @logger.error "MSG_GENERAL_FAILURE: #{data['message']}"
    end
  end
end