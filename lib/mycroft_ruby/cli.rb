require 'thor'
require 'active_support/core_ext/string'

module MycroftRuby
  class CLI < Thor
    desc "new APPNAME", "create a new app with the name APPNAME"
    def new(app_name)
      camelcase = app_name.camelize
      underscore = app_name.underscore
      app_template = File.read('templates/app_template')
      app_template.gsub!(/%%APPNAME%%/, camelcase)

      post_file = File.open("./#{underscore}.rb", 'w')
      post_file.puts app_template
      post_file.close
      puts "Successfully created #{underscore}.rb"
    end
  end
end