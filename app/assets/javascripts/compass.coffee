class Compass
  constructor: (options = {enableHighAccuracy: yes, maximumAge: 10000, timeout: 100000}) ->
    @lat    = 0
    @long   = 0
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
    @long   = position.coords.longitude
    @alt    = position.coords.altitude
    @acc    = position.coords.accuracy
    @altAcc = position.coords.altitudeAccuracy
    @hdg    = position.coords.heading
    @spd    = position.coords.speed
  _parseErr: (err) ->
    switch err.code
      when 1
        @error = 'Permission denied by user. Is your GPS enabled?'
      when 2
        @error = 'Cant fix GPS position. Are you in an area of poor reception?'
      when 3
        @error = 'GPS is taking too long to respond. Try restarting.'
      else
        @error = 'An unknown error has occured. Ensure your devices GPS module is enabled and that you are in an area of adequate GPS reception.'
  stop: ->
    navigator.geolocation.clearWatch()

window.compass = new Compass()