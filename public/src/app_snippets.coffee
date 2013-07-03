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

#==================== MORE SNIPPETS

  class window.Place extends Backbone.Model
    #Since we use mongo...
    idAttribute: "_id"
    # defaults: ->
    #   #Not too useful for this model
    #   title: ""
    initialize: (params) ->
      @set title: params.title
    validate: (attrs, optns) ->
      if !@title
        "Title is required"
      else if !@lat
        "Latitude is required"
      else if !@lng
        "Longitude is required"
      #Returning undefined == good
    urlRoot: server_url + "/places"

  class window.Places extends Backbone.Collection
    model: Place
    #Can I comment this out? Seems redundant...
    # url: "/places"

  class window.PlaceNewView extends Backbone.View
    el: $ '#content'
    initialize: ->
      # _.bindAll this, "render", "remove"
      # @model.bind "change", @render
      # @model.bind "destroy", @remove
      #commented this out for now
      @template = null#templayed($("#gpsCtrlTmpl").html())(@model)

    events:
      "click #send": "createPlace"

    clear: ->
      #Probably should implement this at some point...
      @model.destroy()

    edit: ->
      #See comment for @clear()
      oldTitle = @model.get("title")

    createPlace: (e) ->
      @model.save()

    render: =>
      $(@el).html @template
      #@ for method chaining
      @

