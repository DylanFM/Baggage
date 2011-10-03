ws = require 'websocket-server'
redis = require 'redis'

# Redis stuff
client = redis.createClient()

client.on 'error', (err) ->
  console.log 'Error', err

# Websocket stuff
server = ws.createServer()

server.addListener 'connection', (conn) ->

  notify = (msg, type) ->
    data = 
      type: type or 'notice'
      msg: msg
    console.log msg
    conn.send JSON.stringify(data)

  conn.addListener 'message', (msg) ->

    msg = JSON.parse msg
    switch msg.type
      when 'place'
        lat = parseFloat(msg.coords.lat, 10).toFixed(5)
        lng = parseFloat(msg.coords.lng, 10).toFixed(5)

        client.set "obj#{lat},#{lng}", msg.name

        msg = "Stored #{msg.name} at #{lat},#{lng}"
        notify msg, 'stored'
      when 'check'
        lat = parseFloat(msg.coords.lat, 10).toFixed(5)
        lng = parseFloat(msg.coords.lng, 10).toFixed(5)

        key = "obj#{lat},#{lng}"

        client.get key, (err, reply) ->
          if err or !reply
            notify 'Checked in, nothing there'
          else
            item = reply.toString()
            notify item, 'found'
            client.del key


server.listen 8080
