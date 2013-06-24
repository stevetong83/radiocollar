$ ->
  name = prompt "What is your name"
  document.write name

  $('#send-current-location').click ->
    getLocation()


getLocation = ->
  if (navigator.geolocation)
    navigator.geolocation.getCurrentPosition(showPosition)
  else
    alert('GPS not enabled on device.')

showPosition = (position) ->
  latitude = position.coords.latitude
  longitude = position.coords.longitude
  $('#map').goMap
    latitude: latitude
    longitude: longitude
    zoom: 16
    maptype: 'ROADMAP'
    markers:
      [
        latitude: latitude
        longitude: longitude
        title: 'Current Location'
        html:
          content: '<p>Latitude: ' + latitude + '</p><p>Longitude: ' + longitude + '</p>'
          popup: false
      ]

                