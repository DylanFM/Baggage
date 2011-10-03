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
  // Using an IP because I want to test with my phone
  conn = new WebSocket('ws://192.168.178.87:8080');

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

    // Setup placing
    $('form').submit(function (e) {
      e.preventDefault();
      navigator.geolocation.getCurrentPosition(function(result) {
        place(conn, $('#name').val(), result.coords.latitude, result.coords.longitude);
      });
    });
    
    // Begin updating position
    updatePosition();
  };

  conn.onerror = function (error) {
    console.log('Websocket error', error);
  };

  conn.onmessage = function (msg) {
    data = JSON.parse(msg.data);

    switch(data.type) {
      case 'found':
        $('#found').append('<li>' + data.msg + '</li>');
        break;

      //case 'stored':
      //  break;
      
      default:
        $('p').text(data.msg);
    }
    _.delay(updatePosition, 5000);
  };
 
});
