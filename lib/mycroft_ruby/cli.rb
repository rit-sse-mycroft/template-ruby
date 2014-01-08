require 'thor'
require 'active_support/lazy_load_hooks'
require 'active_support/core_ext/string'

module MycroftRuby
  class CLI < Thor
    desc "new APPNAME", "create a new app with the name APPNAME"
    def new(app_name)
      camelcase = app_name.camelize
      underscore = app_name.underscore
      app_template = File.read("#{Gem.dir}/gems/mycroft_ruby-#{MycroftRuby::VERSION}/lib/mycroft_ruby/templates/app_template")
      app_template.gsub!(/%%APPNAME%%/, camelcase)

      app_file = File.open("./#{underscore}.rb", 'w')
      app_file.puts app_template
      app_file.close
      puts "Successfully created #{underscore}.rb"
    end
  end
end