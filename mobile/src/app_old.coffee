@server_url = 'https://radiocollarapp.herokuapp.com/api/v1'
$ ->
  class window.Place extends Backbone.Model
    #Since we use mongo...
    idAttribute: "_id"
    # defaults: ->
    #   #Not too useful for this model
    #   title: ""
    initialize: (params)->
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
      @template = templayed($("#gpsCtrlTmpl").html())(@model)

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

  class window.RadioCollarRouter extends Backbone.Router
    routes:
      "": "home"

    initialize: ->
      #All the initialization stuff goes here.
      pl   = new Place {title: 'placeholder. Rendered with backbone. yay!'}
      @plvw = new PlaceNewView {model: pl}
    home: ->
      #construct the home view here...
      @plvw.render()

  window.App = new RadioCollarRouter()
  Backbone.history.start()