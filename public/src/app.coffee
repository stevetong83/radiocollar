@server_url  = '/api/v1'
console.log 'dont forget to change the @server_url to production.'
Backbone.Model.idAttribute = "_id"


class window.Session extends Backbone.Model
  url: server_url + '/sessions'
class window.SessionView extends Backbone.View
  el: $('#content')
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
    @model.save {email: $('#email').val(), password: $('#password').val()}, {success: ( => @proceed()) , error: ( => @ohNo())}





class window.Place extends Backbone.Model
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
  url: server_url + '/places'
class window.Places extends Backbone.Collection
  url: server_url + '/places'
  model: Place

class window.PlaceView extends Backbone.View
  tagName: 'li'
  el: 'ul#places'
  initialize: (place) =>
    @model = place
    _.bindAll this, "render", "remove"
    @model.bind "change", @render
    @model.bind "destroy", @remove
    @render()
  events: ->
    "click .destroy" : "removePlace"
  removePlace: ->
    @model.destroy()
  template: '<a href="{{location_url}}">{{name}}</a><span class="destroy">[X]</span>'
  render: =>
    $(@el).append templayed(@template)(@model.attributes)

class window.PlacesView extends Backbone.View
  el:      $('#content')
  initialize: ->
    @collection = new Places()
    $(@el).html """
      <div><a href="/#logout">[Logout]</a></div>
      <input id="new-place" placeholder="Name you waypoint">
      <ul id='places'></ul>
      """
    @collection.on('add remove reset sort', (=> @render()))
    @collection.fetch
      data: {authentication_token: localStorage.auth_token}
      success: ( => @render())
    _.bindAll this, "render"
  @template = _.template($("#ideas-template").html())
  @collection.bind "reset", @render
  @collection.bind "change", @render
  events: ->
    "keypress #new-place" : "createOnEnter"
  render: =>
    $('#places').html('')
    for place in @collection.models
      new PlaceView(place)
  makePlace: () ->
    model = new Place()
    model.set
      name : $('#new-place').val()
      lat  : compass.lat
      long : compass.long
    model.save({authentication_token: localStorage.auth_token})
    @collection.add(model)
  createOnEnter: (event) =>
    if event.keyCode is 13
      @makePlace()
      #probably a better way of doing this...
      $('#new-place').val('')










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
  logout: ->
    delete localStorage.auth_token
    return App.navigate('/', trigger: yes)

$ ->
  window.App = new RadioCollarRouter()
  Backbone.history.start()

##REFACTOR:
# - Take as much stuff out of the $ -> as possible.
# - Stop calling localStorage.auth_token. Use the model itself. Or store the model in local storage. Or everything in localstorage
# - Asign relevant DOM attributes to view attributes. Stop calling DOM directly so much.
# - Get rid of all the global vars when you're done hacking. If I must has globals, put them into the App namespace
# - A lot of views are using @el but they should actually be using @$el()
# - Add a refresh button