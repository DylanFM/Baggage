ws = require 'websocket-server'
redis = require 'redis'
geohash = require 'ngeohash'

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
  
  geohashKey = (lat, lng) ->
    lat = parseFloat(lat, 10)
    lng = parseFloat(lng, 10)
    geohash.encode lat, lng

  conn.addListener 'message', (msg) ->

    msg = JSON.parse msg
    key = geohashKey msg.coords.lat, msg.coords.lng
    switch msg.type
      when 'place'
        client.set key, msg.name

        msg = "Stored #{msg.name} at #{msg.coords.lat},#{msg.coords.lng} (#{key})"
        notify msg, 'stored'
      when 'check'
        client.get key, (err, reply) ->
          if err or !reply
            notify 'Checked in, nothing there'
          else
            item = reply.toString()
            notify item, 'found'
            client.del key


server.listen 8080
