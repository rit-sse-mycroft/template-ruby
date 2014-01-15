require 'json'
require 'socket'
require 'openssl'
require 'securerandom'

module Mycroft
  module Messages
    include Helpers
    MYCROFT_PORT = 1847

    # Connects to mycroft
    def connect_to_mycroft(key='', cert='')
      if ARGV.length == 1 and ARGV[0] == '--no-tls'
        puts 'Not Using TLS'
      else
        puts ('Using TLS')
        start_tls(private_key_file: key, cert_chain_file: cert)
      end
    end

    # Checks if the manifest is valid and returns dependencies
    def check_manifest(parsed)
      if parsed[:type] == 'APP_MANIFEST_OK' || parsed[:type] == 'APP_MANIFEST_FAIL'
        puts "Response type: #{parsed[:type]}"
        puts "Response recived: #{parsed[:data]}"
        raise 'Invalid application manifest' if parsed[:type] == 'APP_MANIFEST_FAIL'
        puts 'Manifest Validated'
        return parsed[:data]['dependencies']
      end
      nil
    end

    # Sends the app manifest to mycroft
    def send_manifest(connection, path)
      begin
        manifest = JSON.parse(File.read(path))
      rescue
        puts 'Invalid File Path'
      end
      send_message(connection, 'APP_MANIFEST', manifest)
    end

    # Sends app up to mycroft
    def up(connection)
      send_message(connection, 'APP_UP')
    end

    # Sends app down to mycroft
    def down(connection)
      send_message(connection, 'APP_DOWN')
    end

    # Sends a query to mycroft
    def query(connection, capability, remote_procedure, args, instance_id = nil)
      query_message = {
        id: SecureRandom.uuid,
        capability: capability,
        remoteProcedure: remote_procedure,
        args: args
      }
      query_message[:instanceId] = instance_id unless instance_id.nil?

      send_message(connection, 'MSG_QUERY', query_message)
    end

    # Sends a broadcast to the mycroft message board
    def broadcast(connection, content)
      message = {
        content: content
      }

      send_message(connection, 'MSG_BROADCAST', message)
    end
  end
end
