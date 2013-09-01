class RadioCollar.Routers.MainRouter extends Backbone.Router
  routes:
    ""      : "login"
    "main"  : "main"
    "logout": "logout"
  login: ->
    if localStorage.auth_token?
      return RadioCollar.App.navigate('/main', trigger: yes)
    else
      window.sessionView = new RadioCollar.Views.SessionView
  main: ->
    unless localStorage.auth_token?
      return RadioCollar.App.navigate('/', trigger: yes)
    $('#content').empty()
    window.placesView = new RadioCollar.Views.PlacesView
    new RadioCollar.Views.CreatePlacesView(collection: placesView.collection)
  logout: ->
    delete localStorage.auth_token
    RadioCollar.App.navigate('/', trigger: yes)