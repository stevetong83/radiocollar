class RadioCollar.Views.PlaceView extends Backbone.View
  tagName:  'li'
  initialize: ->
    #That's wrong. Models should be ignorant to views.
    @model.view = this if @model
    #What's going on here??
    @template = -> templayed('<a href="{{location_url}}">{{name}}</a><span class="destroy">[X]</span>')(@model.attributes)
    @render()
  render: =>
    @$el.html(@template())
    this
  events:
    "click .destroy"  : "erase"
  erase: =>
    @model.destroy {data: {authentication_token: localStorage.auth_token}, processData: yes}