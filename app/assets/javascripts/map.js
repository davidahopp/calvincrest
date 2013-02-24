
$(function(){
  var directionsDisplay;
  var directionsService = new google.maps.DirectionsService();
  var map

  directionsDisplay = new google.maps.DirectionsRenderer();
  var camp = new google.maps.LatLng(41.418176, -96.542844);
  var myOptions = {
    zoom: 12,
    center: camp,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
  directionsDisplay.setMap(map);
  directionsDisplay.setPanel(document.getElementById("directionsPanel"));

  $('.get-map-directions').click(function(){
    var start = document.getElementById("startAddress").value;
    var end = "2870 County Road 13 Fremont, NE 68025"
    var request = {
      origin:start,
      destination:end,
      travelMode: google.maps.DirectionsTravelMode.DRIVING
    };
    directionsService.route(request, function(response, status) {
      if (status == google.maps.DirectionsStatus.OK) {
        directionsDisplay.setDirections(response);
      }
    })
  })

})
