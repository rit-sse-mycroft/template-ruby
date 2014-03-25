require 'spec_helper'


describe Mycroft::Helpers do
  let(:client) {Mycroft::MockMycroftClient.new}
  context 'message parsing' do
    it 'should parse messages with a body' do
      message = 'MSG_QUERY {"something": "something else"}'
      hash = client.parse_message(message)
      expect(hash).to eql({type: 'MSG_QUERY', data: {'something' => 'something else'}})
    end

    it 'should parse messages without a body' do
      message = 'APP_UP'
      hash = client.parse_message(message)
      expect(hash).to eql({type: 'APP_UP', data: {}})
    end

    context 'malformed message' do
      it 'should raise error for backwards message' do
        message = '{"something": "something else"} MSG_QUERY'
        expect{ client.parse_message(message) }.to raise_error
      end

      it 'should raise an error for just a json object' do
        message = '{"something": "something else"}'
        expect{ client.parse_message(message) }.to raise_error
      end

      it 'should raise an error for empty string' do
        expect{ client.parse_message('') }.to raise_error
      end
    end
  end

  context 'sending messages' do
    it 'will send message with a body' do
      client.send_message('MSG_QUERY',{something: 'something else'})
      expect(client.server.read).to eql({size: 40, message: 'MSG_QUERY {"something":"something else"}'})
    end

    it 'will send message without a body' do
      client.send_message('APP_UP')
      expect(client.server.read).to eql({size: 6, message: 'APP_UP'})
    end
  end

  context 'updating dependencies' do
    it 'will update dependencies without existing dependencies' do
      deps = {'stt' => {'stt1' => 'up', 'stt2' => 'down'}, 'logger' => {'logger1' => 'up', 'logger2' => 'down'}}
      client.update_dependencies(deps)
      expect(client.dependencies).to eql(deps)
    end

    it 'will update dependencies with existing dependencies'do
      client.dependencies = {'stt' => {'stt1' => 'up', 'stt2' => 'down'}, 'logger' => {'logger1' => 'up', 'logger2' => 'down'}}
      client.update_dependencies({'stt' => {'stt1' => 'down'}})
      client.update_dependencies({'tts' => {'tts1' => 'up'}})
      new_deps = {'stt' => {'stt1' => 'down', 'stt2' => 'down'}, 'logger' => {'logger1' => 'up', 'logger2' => 'down'}, 'tts' => {'tts1' => 'up'}}
      expect(client.dependencies).to eql(new_deps)
    end
  end
end