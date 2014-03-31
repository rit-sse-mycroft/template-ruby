# Mycroft

Gem for creating mycroft application in ruby.

### Install
Install bundler:
~~~
gem install bundler
~~~

From inside the ruby app directory

~~~
bundle install
rake install
~~~
If we ever put this on ruby gems:

```
gem install mycroft
```

### Create a new App
`mycroft-ruby new APPNAME`

## Running your app
`ruby YOUR_APP.rb [--no-tls]`

### Example App
```ruby
require 'mycroft'

class MockAppRuby < Mycroft::Client

  def initialize(host, port)
    @key = ''
    @cert = ''
    @manifest = './mock_app_ruby.json'
    @verified = false
    super
  end

  on 'APP_DEPENDENCY' do |data|
    update_dependencies(data)
    up
    broadcast({message: "I'm broadcasting things"})
  end
end

Mycroft::start(MockAppRuby)
```

### Overview of MockRubyApp

#### initialize
Specify the path to key, path to cert, path to app manifest, and whether it's verified or not. Set that to false.

#### on
For each of the different messages, you create an event handler using the `on` method. You can also do this for `CONNECT`, `CONNECTION_CLOSED`, and `ERROR`. You can create multiple handlers per message if that's what you want to do. The Base class creates 3 for you. On `APP_MANIFEST_OK` `@verified` is set to `true` and it is logged. On `APP_MANIFEST_FAIL`, it raises an error. On `MSG_GENERAL_FAILURE`, the message is logged. 

### Helper Methods

#### up
Sends `APP_UP` to mycroft

#### down
Sends `APP_DOWN` to mycroft

#### in_use
Sends `APP_IN_USE` to mycroft

#### query(capability, action, data, priority = 30, instance_id = nil)
Sends a `MSG_QUERY` to mycroft

#### broadcast(content)
Sends a `MSG_BROADCAST` to mycroft

#### query_success(id, ret)
Sends a `MSG_QUERY_SUCCESS` to mycroft

#### query_fail(id, message)
Sends a `MSG_QUERY_FAIL` to mycroft

#### update_dependencies(dependencies)
Updates `@dependencies` given the dependencies json block.
