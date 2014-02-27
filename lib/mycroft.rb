require 'mycroft/version'
require 'mycroft/cli'
require 'mycroft/helpers'
require 'mycroft/messages'
require 'mycroft/logger'
require 'mycroft/client'

module Mycroft
  extend self
  MYCROFT_PORT = 1847

  def start(app, host='localhost', port=MYCROFT_PORT)
    app.new(host, port)
  end
end
