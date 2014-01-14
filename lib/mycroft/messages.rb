require 'json'
require 'socket'
require 'openssl'

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

  def up(connection)
    puts 'Sending App Up'
    Helpers::send_message(connection, 'APP_UP')
  end

  def down(connection)
    puts 'Sending App Down'
    Helpers::send_message(connection, 'APP_DOWN')
  end
end
