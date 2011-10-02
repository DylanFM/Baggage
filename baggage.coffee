ws = require 'websocket-server'
redis = require 'redis'

# Redis stuff
client = redis.createClient()

client.on 'error', (err) ->
  console.log 'Error', err

# Websocket stuff
server = ws.createServer()

server.addListener 'connection', (conn) ->

  notify = (msg) ->
    data = 
      type: 'notice'
      msg: msg
    conn.send JSON.stringify(data)

  # Send the client information about items available

  conn.addListener 'message', (msg) ->

    msg = JSON.parse msg
    switch msg.type
      when 'place'
        client.set "obj#{msg.coords.lat},#{msg.coords.lng}", msg.name

        notice = "Stored #{msg.name} at #{msg.coords.lat},#{msg.coords.lng}"
        console.log notice
        notify notice
      when 'check'
        key = "obj#{msg.coords.lat},#{msg.coords.lng}"

        client.get key, (err, reply) ->
          if err or !reply
            console.log 'Nothing found', err, reply
            notify 'Checked in, nothing there'
          else
            item = reply.toString()
            console.log 'Found', item
            notify "Hey, you found: #{item}"
            client.del key


server.listen 8080
