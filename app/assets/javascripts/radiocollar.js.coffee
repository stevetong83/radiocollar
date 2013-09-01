window.RadioCollar =
  Models:      {}
  Collections: {}
  Views:       {}
  Routers:     {}
  server_url: '/api/v1'
  initialize: ->
    #Bootstrap the configs
    console.log 'dont forget to change the @server_url to production.'
    Backbone.Model.idAttribute = "_id"
    window.RadioCollar.App     = new RadioCollar.Routers.MainRouter()
    Backbone.history.start()
$(document).ready ->
  RadioCollar.initialize()
