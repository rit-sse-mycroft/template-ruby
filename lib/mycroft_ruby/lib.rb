require 'json'

module MycroftRuby
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
end
