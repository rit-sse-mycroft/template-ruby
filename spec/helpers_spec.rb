require 'spec_helper'
include Mycroft::Helpers
describe Mycroft::Helpers do
  context 'message parsing' do
    it 'should parse messages with a body' do
      message = 'MSG_QUERY {"something": "something else"}'
      hash = parse_message(message)
      expect(hash).to eql({type: 'MSG_QUERY', data: {'something' => 'something else'}})
    end

    it 'should parse messages without a body' do
      message = 'APP_UP'
      hash = parse_message(message)
      expect(hash).to eql({type: 'APP_UP', data: {}})
    end

    context 'malformed message' do
      it 'should raise error for backwards message' do
        message = '{"something": "something else"} MSG_QUERY'
        expect{ parse_message(message) }.to raise_error
      end

      it 'should raise an error for just a json object' do
        message = '{"something": "something else"}'
        expect{ parse_message(message) }.to raise_error
      end

      it 'should raise an error for empty string' do
        expect{ parse_message('') }.to raise_error
      end
    end
  end
end