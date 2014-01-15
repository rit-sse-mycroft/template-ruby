require 'mycroft/version'
require 'mycroft/cli'
require 'mycroft/helpers'
require 'mycroft/messages'
require 'mycroft/client'

module Mycroft

  extend self

  def start_simple_app(app)
    client = Mycroft::connect_to_mycroft(app.key, app.cert)
    verified = false
    app_up = false

    Mycroft::send_manifest(client, app.manifest)

    while length = client.gets
      data = client.read(length.to_i)
      parsed = Mycroft::parse_message(data)

      if parsed[:type] == 'APP_MANIFEST_OK' || parsed[:type] == 'APP_MANIFEST_FAIL'
        dependencies = Mycroft::check_manifest(parsed)
        verified = true
        app.on_app_manifest_response(client, parsed[:data])
      elsif parsed[:type] == 'MSG_QUERY'
        app.on_query_recieved(client, parsed[:data])
      elsif parsed[:type] == 'MSQ_QUERY_SUCCESS'
        app.on_query_successful(client, parsed[:data])
      elsif parsed[:type] == 'MSG_QUERY_FAIL'
        app.on_query_failed(client, parsed[:data])
      else
        app.on_unknown_message(client, parsed[:type], parsed[:data])
      end

      unless dependencies.nil?
        should_go_up = app.check_dependencies(dependencies)
        if should_go_up and not app_up
          Mycroft::up(client)
        elsif not should_go_up and app_up
          Mycroft::down(client)
        end
      end

      app.on_data(client, parsed[:type], parsed[:data]) if(verified)
    end
  end
end
