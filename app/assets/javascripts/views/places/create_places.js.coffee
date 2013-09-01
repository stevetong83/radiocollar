class RadioCollar.Views.CreatePlacesView extends Backbone.View
  initialize: ->
    @$el.html('<a href="/#logout">[Logout]</a><input id="new-place" placeholder="Name you waypoint">')
    $('#content').empty()
    @$el.appendTo('#content')
  events:
    "keypress #new-place" : "createOnEnter"
  createOnEnter: (event) =>
    if event.keyCode is 13
      @makePlace()
      $('#new-place').val('')
  makePlace: () ->
    model = new RadioCollar.Models.Place()
    model.set
      name : $('#new-place').val()
      lat  : compass.lat
      long : compass.long
    model.save({authentication_token: localStorage.auth_token})
    @collection.add(model)
