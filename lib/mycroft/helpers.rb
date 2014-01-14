module Mycroft
  extend self

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

  # Sends a message of a specific type
  def send_message(connection, type, message=nil)
    message = message.nil? ? message = '' : message.to_json
    body = type + ' ' + message
    length = body.bytesize
    puts 'Sending Messsage'
    puts length
    puts body
    connection.puts("#{length}\n#{body}")
  end
end
