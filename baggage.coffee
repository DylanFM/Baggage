ws = require 'websocket-server'
redis = require 'redis'

# Redis stuff
client = redis.createClient()

client.on 'error', (err) ->
  console.log 'Error', err

# Websocket stuff
server = ws.createServer()

server.addListener 'connection', (conn) ->
  conn.addListener 'message', (msg) ->

    msg = JSON.parse msg
    switch msg.type
      when 'place'
        client.set "obj#{msg.coords.lat},#{msg.coords.lng}", msg.name

        notice = "Stored #{msg.name} at #{msg.coords.lat},#{msg.coords.lng}"
        console.log notice
        server.send notice
      when 'check'
        key = "obj#{msg.coords.lat},#{msg.coords.lng}"

        client.get key, (err, reply) ->
          if err or !reply
            console.log 'Nothing found', err, reply
            conn.send 'Checked in, nothing there'
          else
            item = reply.toString()
            console.log 'Found', item
            conn.send "Hey, you found: #{item}"
            client.del key


server.listen 8080
