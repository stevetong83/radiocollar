class Compass
  constructor: (options = {enableHighAccuracy: yes, maximumAge: 10000, timeout: 100000}) ->
    @lat    = 0
    @lng    = 0
    @alt    = 0
    @acc    = 0
    @altAcc = 0
    @hdg    = 0
    @spd    = 0
    @_grabGPS(options)
  _grabGPS: (options) ->
    navigator.geolocation.watchPosition(@_parseGPS, @_parseErr, options)
  _parseGPS: (position) =>
    @lat    = position.coords.latitude
    @lng    = position.coords.longitude
    @alt    = position.coords.altitude
    @acc    = position.coords.accuracy
    @altAcc = position.coords.altitudeAccuracy
    @hdg    = position.coords.heading
    @spd    = position.coords.speed
  _parseErr: (err) ->
    switch err.code
      when 1
        @error = 'Permission denied by user'
      when 2
        @error = 'Cant fix GPS position'
      when 3
        @error = 'GPS is taking too long to respond'
      else
        @error = 'Well, this is embarassing...'
    console.log @error
  stop: ->
    navigator.geolocation.clearWatch()

window.compass = new Compass()

$ ->
  setInterval ->
    message = "LAT: #{compass.lat} LNG: #{compass.lng} ALT: #{compass.alt} ACC: #{compass.acc} ALTACC: #{compass.altacc} HDG: #{compass.hdg} SPD: #{compass.spd} "
    $('#info').text(message)
  , 200