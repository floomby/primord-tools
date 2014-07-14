#!/usr/bin/env ruby

require 'pp'

config = {}
config['web_root'] = File.join (File.dirname __FILE__), 'www'
config['bind_addr'] = '0.0.0.0'
config['http_port'] = 8000
config['sock_port'] = 8001


require 'json'
require 'date'

require 'webrick'
require 'eventmachine'
require 'em-websocket'

$:.unshift File.join (File.dirname __FILE__), 'lib'

#require 'couchcheck'
require 'dataset'

# test things
files = (Dir.entries (File.join (File.dirname __FILE__), 'www/data')).select { |f| !File.directory? f }
files.collect! { |f| File.join (File.dirname __FILE__), 'www/data', f }

test_dataset = DataSet.new files


server = WEBrick::HTTPServer.new :BindPort => config['bind_port'], :Port => config['http_port'], :DocumentRoot => config['web_root']
Thread.new { server.start }


Thread.new do
    @clients = {}
    EventMachine.run do
        EventMachine::WebSocket.start :host => config['bind_addr'], :port => config['sock_port'] do |socket|
            socket.onopen do |handshake|
                puts "[EventMachine]: Websocket Connection: #{handshake.path}"
                socket.send test_dataset.header.to_json
                test_dataset.points.each do |pt|
                    socket.send pt.to_json
                end
                #@clients[socket] = WebApp::Client.new socket, handshake.path
            end
            
            socket.onmessage do |msg|
                #@clients[socket].message msg
            end
            
            socket.onclose do
                #@clients[socket].close
                #@clients.delete socket
            end
        end
    end
end



sleep 3
trap 'INT' do
    server.shutdown
    puts "[EventMachine] Server Shutting Down"
    EventMachine.stop
    sleep 1
    exit 0
end


loop do
    sleep 10
end
