function place (conn, name, lat, lng) {
  data = {
    type: 'place',
    name: name,
    coords: {
      lat: lat,
      lng: lng
    }
  };
  conn.send(JSON.stringify(data));
}

$(function () {
  // Connect to websocket server
  // Global for testing
  conn = new WebSocket('ws://10.109.3.75:8080');

  function updatePosition () {
    // Find location
    navigator.geolocation.getCurrentPosition(function(result) {
      data = {
        type: 'check',
        coords: {
          lat: result.coords.latitude,
          lng: result.coords.longitude
        }
      };
      conn.send(JSON.stringify(data));
    });
  }

  conn.onopen = function (e) {
    console.log('Connection open');
    updatePosition();
  };

  conn.onerror = function (error) {
    console.log('Websocket error', error);
  };

  conn.onmessage = function (msg) {
    data = JSON.parse(msg.data);
    switch(data.type) {
      case 'items':
        break;
      
      default:
        $('p').text(data.msg);
    }
    _.delay(updatePosition, 5000);
  };
 
});
