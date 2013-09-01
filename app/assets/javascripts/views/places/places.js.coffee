class RadioCollar.Views.PlacesView extends Backbone.View
  tagName: 'ul'
  initialize: ->
    @collection = new RadioCollar.Collections.Places()
    @collection.on('add remove reset sort', (=> @render()))
    @collection.fetch
      data: {authentication_token: localStorage.auth_token}
      success: ( => @render())
  events:
    #Nothing yet.
    {}
  render: =>
    #See if you can skip this line and just empty the whole div.
    @$el.empty()
    for place in @collection.models
      view = new RadioCollar.Views.PlaceView(model: place)
      view.$el.appendTo(this.$el)
    @$el.appendTo('#content')