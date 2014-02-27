require 'colorize'
module Mycroft
  class Logger

    def initialize(file)
      @name = file
    end

    def log(message, level, color)
      Dir.mkdir('logs') unless Dir.exists?('logs')
      if(Date.today != @date)
        @file.close unless @file.nil?
        @file = File.open("logs/#{@name}-#{Date.today.strftime("%Y-%m-%d")}.log", 'a')
        @date = Date.today
      end
      date = Time.now.strftime('%Y-%m-%d %H:%M:%S')
      string = '[%s] [%5s] %s' % [date, level, message]
      puts string.send(color)
      @file.puts string
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