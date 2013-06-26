#Nice example: http://jasongiedymin.github.io/backbone-todojs-coffeescript/docs/coffeescript/todos.html

#Make this a global for storing the API URL
@server_url = 'https://radiocollarapp.herokuapp.com/api/v1'
$ ->
  class window.Place extends Backbone.Model
    #Because we use mongo...
    idAttribute: "_id"
    initialize: (params) ->
      @set {title: params.title, lat: params.lat, lng: params.lng}
    validate: (attrs, optns) ->
      if (!@title or !@lat or !@lng)
        "Must have a title and coordinates"
    urlRoot: server_url + "/places"

    class window.PlaceList extends Backbone.Collection
      model: Place
      url: server_url + "/places"

    class window.PlaceView extends Backbone.View
      el: $('#content')
      initialize: ->
        #So that every change on the model calls a view render
        @model.bind('change', @render)
        @model.view = @
      events:
        "click #send" : "createPlace"
      createPlace: =>
        alert 'do something here...'
        @