module Mycroft
  extend self

  # Parses a message
  def parse_message(msg)
    msg = msg.to_s
    re = /([A-Z_]*) ({.*})$/
    msg_split = re.match(msg)
    if msg_split.nil?
      re = /(.*)/
      msg_split = re.match(msg)
      raise "Error: Malformed Message" if not msg_split
      type = msg_split[1]
      data = {}
    else
      type = msg_split[1]
      data = JSON.parse(msg_split[2])
    end
    {type: type, data: data}
  end

  # Sends a message of a specific type
  def send_message(connection, type, message=nil)
    message = message.nil? ? message = '' : message.to_json
    body = type + ' ' + message
    body.strip!
    length = body.bytesize
    puts 'Sending Messsage'
    puts length
    puts body
    connection.puts("#{length}\n#{body}")
  end
end
