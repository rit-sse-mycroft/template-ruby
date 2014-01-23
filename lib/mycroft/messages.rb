require 'json'
require 'securerandom'

module Mycroft
  module Messages
    include Helpers

    # connects to mycroft aka starts tls if necessary
    def connect_to_mycroft
      if ARGV.length == 1 and ARGV[0] == '--no-tls'
        puts 'Not Using TLS'
        @client = TCPSocket.open(@host, @port)
      else
        puts ('Using TLS')
        socket = TCPSocket.new(@host, @port)
        ssl_context = OpenSSL::SSL::SSLContext.new
        ssl_context.cert = OpenSSL::X509::Certificate.new(File.open(@cert))
        ssl_context.key = OpenSSL::PKey::RSA.new(File.open(@key))
        @client = OpenSSL::SSL::SSLSocket.new(socket, ssl_context)
        begin
          @client.connect
        rescue
          puts "There was an error in establishing TLS connection"
        end
      end
    end

    # Checks if the manifest is valid and returns dependencies
    def check_manifest(parsed)
      if parsed[:type] == 'APP_MANIFEST_OK' || parsed[:type] == 'APP_MANIFEST_FAIL'
        raise 'Invalid application manifest' if parsed[:type] == 'APP_MANIFEST_FAIL'
        puts 'Manifest Validated'
        return parsed[:data]['dependencies']
      end
      nil
    end

    # Sends the app manifest to mycroft
    def send_manifest
      begin
        manifest = JSON.parse(File.read(@manifest))
        manifest["instanceId"] = "#{ENV["COMPUTERNAME"]}_#{SecureRandom.uuid}" if @generate_instance_ids
      rescue
        puts 'Invalid File Path'
      end
      send_message('APP_MANIFEST', manifest)
    end

    # Sends app up to mycroft
    def up
      send_message('APP_UP')
    end

    # Sends app down to mycroft
    def down
      send_message('APP_DOWN')
    end

    def in_use(priority)
      send_message('APP_IN_USE', {priority: (priority or 30)})
    end

    # Sends a query to mycroft
    def query(capability, action, data, priority = 30, instance_id = nil)
      query_message = {
        id: SecureRandom.uuid,
        capability: capability,
        action: action,
        data: data,
        priority: priority,
        instanceId: []
      }
      query_message[:instanceId] = instance_id unless instance_id.nil?

      send_message('MSG_QUERY', query_message)
    end

    def query_success(id, ret)
      query_success_message = {
        id: id,
        ret: ret
      }
      send_message('MSG_QUERY_SUCCESS', query_success_message)
    end

    def query_fail(id, message)
      query_fail_message = { 
        id: id, 
        message: message
      }
      send_message('MSG_QUERY_FAIL', query_fail_message)
    end

    # Sends a broadcast to the mycroft message board
    def broadcast(content)
      message = {
        id: SecureRandom.uuid,
        content: content
      }

      send_message('MSG_BROADCAST', message)
    end
  end
end
