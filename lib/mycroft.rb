require 'mycroft/version'
require 'mycroft/cli'
require 'mycroft/helpers'
require 'mycroft/messages'

module Mycroft
  extend self
  MYCROFT_PORT = 1847

  # Connects to mycroft
  def connect_to_mycroft(key='', cert='')
    client = nil
    if ARGV.length == 1 and ARGV[0] == '--no-tls'
      puts 'Not Using TLS'
      begin
        client = TCPSocket.open('localhost', MYCROFT_PORT)
      rescue
        puts "There was an error establishing connection"
      end
    else
      puts ('Using TLS')
      ssl_context = OpenSSL::SSL::SSLContext.new
      ssl_context.cert = OpenSSL::X509::Certificate.new(File.open(cert))
      ssl_context.key = OpenSSL::PKey::RSA.new(File.open(key))
      ssl_socket = OpenSSL::SSL::SSLSocket.new(socket, ssl_context)
      begin
        ssl_socket.connect
      rescue
        puts "There was an error in establishing TLS connection"
      end
    end
    client
  end

  def check_manifest(data)
    parsed = Helpers::parse_message(data)
    if parsed[:type] == 'APP_MANIFEST_OK' || parsed[:type] == 'APP_MANIFEST_FAIL'
      puts 'Response type: ' + parsed[:type]
      puts 'Response recived: ' + parsed[:data]
      raise 'Invalid application manifest' if parsed[:type] == 'APP_MANIFEST_FAIL'
      puts 'Manifest Validated'
      return parsed[:data]['dependencies']
    end
    nil
  end
end
