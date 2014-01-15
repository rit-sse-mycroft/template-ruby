require 'mycroft/version'
require 'mycroft/cli'
require 'mycroft/helpers'
require 'mycroft/messages'
require 'mycroft/client'

module Mycroft
  extend self
  MYCROFT_PORT = 1847

  def start(app)
    EventMachine.run do
      EventMachine.connect('localhost', MYCROFT_PORT, app)
    end
  end
end
