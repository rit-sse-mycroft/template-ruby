require 'thor'
require 'active_support/lazy_load_hooks'
require 'active_support/core_ext/string'

module Mycroft
  class CLI < Thor
    desc "new APPNAME", "create a new app with the name APPNAME"
    def new(app_name)
      camelcase = app_name.camelize
      underscore = app_name.underscore
      dashed = app_name.dasherize
      path = "#{Gem.dir}/gems/mycroft-#{Mycroft::VERSION}/lib/mycroft/templates/"
      app_template = File.read("#{path}/app_template")
      app_template.gsub!(/%%APPNAME%%/, camelcase)
      app_template.gsub!(/%%UNDERSCORE%%/, underscore)

      app_manifest = File.read("#{path}/app_manifest")
      app_manifest.gsub!(/%%DASHED%%/, dashed)

      app_file = File.open("./#{underscore}.rb", 'w')
      app_file.puts app_template
      app_file.close
      puts "Successfully created #{underscore}.rb"

      app_file = File.open("./app.json", 'w')
      app_file.puts app_manifest
      app_file.close
      puts "Successfully created app.json"
    end
  end
end