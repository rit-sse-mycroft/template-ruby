require 'mycroft/version'
require 'mycroft/cli'
require 'mycroft/helpers'
require 'mycroft/messages'
require 'mycroft/client'

module Mycroft
  extend self
  MYCROFT_PORT = 1847

  def start(app, host='localhost', port=MYCROFT_PORT)
    app.new(host || 'localhost' , port || MYCROFT_PORT)
  end
end
