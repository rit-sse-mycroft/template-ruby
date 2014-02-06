module Mycroft
  module Helpers

    # Parses a message
    def parse_message(msg)
      msg = msg.to_s
      re = /([A-Z_]*) ({.*})$/
      msg_split = re.match(msg)
      if msg_split.nil?
        re = /([A-Z_]*)/
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
    def send_message(type, message=nil)
      message = message.nil? ? message = '' : message.to_json
      body = type + ' ' + message
      body.strip!
      length = body.bytesize
      @logger.info "Sending Message #{type}"
      @logger.debug "#{length} #{body}"
      @client.write("#{length}\n#{body}")
    end

    def update_dependencies(deps)
      deps.each do |capability, instance|
        @dependencies[capability] ||= {}
        instance.each do |app_id, status|
          @dependencies[capability][app_id] = status
        end
      end
    end
  end
end