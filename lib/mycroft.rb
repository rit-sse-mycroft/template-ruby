require 'mycroft/version'
require 'mycroft/cli'
require 'mycroft/helpers'
require 'mycroft/messages'

module Mycroft

  extend self

  def start_simple_app(app)
    client = Mycroft::connect_to_mycroft(app.KEY, app.CERT)
    verified = false
    app_up = false

    while data = client.gets
      client.sendManifest(client, app.MANIFEST )
      parsed = Mycroft::parse_message(data)

      if parsed[:type] == 'APP_MANIFEST_OK' || parsed[:type] == 'APP_MANIFEST_FAIL'
        dependencies = Mycroft::check_manifest(parsed)
        verified = true
        app.on_app_manifest_response(parsed[:data])
      elsif parsed[:type] == 'MSG_QUERY'
        app.on_query_recieved(parsed[:data])
      elsif parsed[:type] == 'MSQ_QUERY_SUCCESS'
        app.on_query_successful(parsed[:data])
      elsif parsed[:type] == 'MSG_QUERY_FAIL'
        app.on_query_failed(parsed[:data])
      else
        app.on_unknown_message(parsed[:type], parsed[:data])
      end

      app.on_data(parsed[:type], parsed[:data]) if(verified)

      unless dependencies.nil?
        should_go_up = app.check_dependencies(dependencies)
        if should_go_up and not app_up
          Mycroft::up(client)
        elsif not should_go_up and app_up
          Mycroft::down(client)
        end
      end
    end
  end
end
