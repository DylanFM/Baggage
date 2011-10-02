$(function () {
  navigator.geolocation.getCurrentPosition(function(result) {
    console.log(result);
    $('body').append('<p>' + result.coords.latitude + ', ' + result.coords.longitude + '</p>');
  });
});
