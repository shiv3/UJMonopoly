require 'faye/websocket'
require 'eventmachine'
require 'json'

EM.run {
  ws = Faye::WebSocket::Client.new('ws://localhost:9292/')
  ws.on :open do |event|
    p [:open]
    ws.send('Hello, world!')
    ws.send JSON.generate({"message" => "bar"})
    p "a"
  end

  ws.on :message do |event|
    p [:message, event.data]
  end

  ws.on :close do |event|
    p [:close, event.code, event.reason]
    ws = nil
  end

}

