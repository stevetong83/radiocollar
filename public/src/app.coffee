@server_url  = '/api/v1'
console.log 'dont forget to change the @server_url to production.'
Backbone.Model.idAttribute = "_id"

class window.Session extends Backbone.Model
  url: server_url + '/sessions'

class window.SessionView extends Backbone.View
  el: '#content'
  initialize: ->
    @template = """
    <form id='sessionCreate'>
    <div><input type="text" id="email" placeholder="User ID" tabindex="2" name="userID" maxlength="255"></div>
    <div><input type="password" placeholder="Password" tabindex="3" class="password hide" id="password" name="password" maxlength="32"></div>
    <div><a href="#" id="go" class="btn-wide">Login now.</a></div></form>
    """
    @model = new Session()
    @render()
  events:
    "click #go" : "authenticate"
  render: ->
    $(@el).html(@template)
  proceed: =>
    #Override backbone.sync to attach the token.
    localStorage.auth_token = @model.get('authentication_token')
    App.navigate('/main', trigger: yes)
  attempts: 0
  ohNo: ->
    $('#go').text("#{++@attempts} failed login attempts. Try again.")
  authenticate: ->
    #Why do I need to enclose the callbacks like that? Oh, CoffeeScript.
    @model.save {email: $('#email').val(), password: $('#password').val()}, {success: ( => @proceed()) , error: ( => @ohNo())}

class window.Place extends Backbone.Model
  idAttribute: "_id"
  initialize: () ->
    @set('lat', compass.lat)
    @set('long', compass.long)
  validate: () ->
    if compass.error?
      return (alert compass.error)
    unless @has('lat')? or @has('long')?
      #How would this error ever fire?
      return (alert "Unable to fix GPS location.")
    unless @get('name')?
      return (alert "A name is required.")
  urlRoot: server_url + '/places'

class window.Places extends Backbone.Collection
  url: server_url + '/places'
  model: Place

class window.PlaceView extends Backbone.View
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


class window.PlacesView extends Backbone.View
  tagName: 'ul'
  initialize: ->
    @collection = new Places()
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
      view = new PlaceView(model: place)
      view.$el.appendTo(this.$el)
    @$el.appendTo('#content')

class CreatePlacesView extends Backbone.View
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
    model = new Place()
    model.set
      name : $('#new-place').val()
      lat  : compass.lat
      long : compass.long
    model.save({authentication_token: localStorage.auth_token})
    @collection.add(model)

class window.RadioCollarRouter extends Backbone.Router
  routes:
    ""      : "login"
    "main"  : "main"
    "logout": "logout"
  login: ->
    if localStorage.auth_token?
      return App.navigate('/main', trigger: yes)
    else
      window.sessionView = new SessionView
  main: ->
    unless localStorage.auth_token?
      return App.navigate('/', trigger: yes)
    $('#content').empty()
    window.placesView = new PlacesView
    new CreatePlacesView(collection: placesView.collection)
  logout: ->
    delete localStorage.auth_token
    App.navigate('/', trigger: yes)

$ ->
  window.App = new RadioCollarRouter()
  Backbone.history.start()

##REFACTOR:
# - Stop calling localStorage.auth_token. Use the model itself. Or store the model in local storage. Or everything in localstorage
# - Add the authtoken to the API URL
# - Get rid of all the global vars when you're done hacking. If I must has globals, put them into the App namespace
# - Add a refresh button
# - Put everything into an App namespace
# - We might have a memory leak or something. Why are parameters sent two times in the same request?
#   https://www.youtube.com/watch?v=hb8_IReoms8
# - Add a 'stop GPS'