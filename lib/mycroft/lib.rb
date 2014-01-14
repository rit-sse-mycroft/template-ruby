require 'json'
require 'socket'
require 'openssl'

module Mycroft
  MYCROFT_PORT = 1847

  # Parses a message
  def parse_message(msg)
    msg = msg.to_s
    re = /(\d+)\n([A-Z_]*) ({.*})$/
    msg_split = re.match(msg)
    if msg_split.nil?
      re = /(\d+)\n(.*)/
      msg_split = re.match(msg)
      raise "Error: Malformed Message" if not msg_split
      type = msg_split[2]
      data = {}
    else
      type = msg_split[2]
      data = JSON.parse(msg_split[3])
    end
    {type: type, data: data}
  end

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
      console.log('Using TLS')
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
end
