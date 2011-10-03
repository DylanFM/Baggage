# Baggage
A wee app hastily sketched together at JSconf.EU. Mostly just finding an opportunity to play with serverside JS, redis and the HTML5 geolocation api.
The web socket server sits there and waits for connections to check in or store something at a location. If there's something stored where the check in occurs, they "acquire" the "thing".