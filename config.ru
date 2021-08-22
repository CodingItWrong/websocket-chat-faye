require 'faye/websocket'

App = lambda do |env|
  if Faye::WebSocket.websocket?(env)
    ws = Faye::WebSocket.new(env)
    ws.send('Connected to Faye')

    ws.on :message do |event|
      puts "Faye received: #{event.data}"
      ws.send("Response from Faye: #{event.data}")
    end

    ws.on :close do |event|
      p [:close, event.code, event.reason]
      ws = nil
    end

    # Return async Rack response
    ws.rack_response

  else
    # Normal HTTP request
    [200, { 'Content-Type' => 'text/plain' }, ['Hello']]
  end
end

run App
