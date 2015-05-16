require 'rubygems'
require 'websocket-client-simple'
require 'json'

ws = WebSocket::Client::Simple.connect 'http://localhost:9292/websocket'

ws.on :message do |msg|
		  puts msg.data
end

ws.on :open do
		 ws.send JSON.generate({"message" => "bar"})
end

ws.on :close do |e|
		  p e
		    exit 1
end

loop do
		  ws.send STDIN.gets
end
