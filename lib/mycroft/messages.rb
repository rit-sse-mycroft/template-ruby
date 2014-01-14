require 'json'
require 'socket'
require 'openssl'
require 'securerandom'

module Mycroft
  extend self
  # Sends the app manifest to mycroft
  def send_manifest(connection, path)
    begin
      manifest = JSON.parse(File.open(path))
    rescue
      puts 'Invalid File Path'
    end
    puts 'Sending Manifest'
    Helpers::send_message(connection, 'APP_MANIFEST', manifest)
  end

  # Sends app up to mycroft
  def up(connection)
    puts 'Sending App Up'
    Helpers::send_message(connection, 'APP_UP')
  end

  # Sends app down to mycroft
  def down(connection)
    puts 'Sending App Down'
    Helpers::send_message(connection, 'APP_DOWN')
  end

  # Sends a query to mycroft
  def query(connection, capability, remote_procedure, args, instance_id)
    query_message = {
      id: SecureRandom.uuid,
      capability: capability,
      remoteProcedure: remote_procedure,
      args: args
    }
    query_message[:instanceId] = instance_id unless instance_id.nil?

    Helpers::send_message(connection, 'MSG_QUERY', query_message)
  end

  # Sends a broadcast to the mycroft message board
  def broadcast(connection, content)
    message = {
      content: content
    }

    Helpers::send_message(connection, 'MSG_BROADCAST', message)
  end
end
