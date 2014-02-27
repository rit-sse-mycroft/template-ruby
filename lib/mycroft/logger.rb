require 'colorize'
module Mycroft
  class Logger

    def initialize(file)
      @file = file
    end

    def log(message, level, color)
      date = Time.now.strftime('%Y-%m-%d %H:%M:%S')
      string = '[%s] [%5s] %s' % [date, level, message]
      puts string.send(color)
    end

    def info(message)
      log(message, 'INFO', :cyan)
    end

    def debug(message)
      log(message, 'DEBUG', :uncolorize)
    end

    def warn(message)
      log(message, 'WARN', :yellow)
    end

    def error(message)
      log(message, 'error', :red)
    end
  end
end