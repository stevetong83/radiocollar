## RadioCollar
#Set the server path. We need to change this when we deploy...
@server_url  = '/api/v1'
#... so I set a reminder to avoid any headaches
console.log 'dont forget to change the @server_url to production.'
#Set the ID attribute to the mongodb  style _id for all models
Backbone.Model.idAttribute = "_id"
$ ->
  class window.Session extends Backbone.Model
    url: server_url + '/sessions'
#session view is the login screen.
  class window.SessionView extends Backbone.View
    el: $('#content')
    initialize: ->
      @template = """
      <form id='sessionCreate'>
      <div><input type="text" id="email" placeholder="User ID" tabindex="2" name="userID" maxlength="255"></div>
      <div><input type="password" placeholder="Password" tabindex="3" class="password hide" id="password" name="password" maxlength="32"></div>
      <div><a href="#" id= 'go'>Login now.</a></div></form>
      """
      @model = new Session()
      @render()
    events:
      "click #go" : "authenticate"
    render: ->
      $(@el).html(@template)
    proceed: () =>
#proceed() sets the auth_token globally and sends the browser to the main content
#Right now, I stored the token as a string in localStorage. Probably should just put the whole model in localstorage.
      localStorage.auth_token = @model.get('authentication_token')
      App.navigate('/main', trigger: yes)
    ohNo: () ->
#le error handler
      alert 'Failed to login. Check your email, password and internet connection.'
    authenticate: ->
#Isn't it gross the way you have to make callbacks in coffeescript in order to preserve context?
      @model.save {email: $('#email').val(), password: $('#password').val()}, {success: ( => @proceed()) , error: ( => @ohNo())}

  class window.Place extends Backbone.Model
    initialize: () ->
#Compass is our HTML5 Geodata API that we made a long time ago.
      @set('lat', compass.lat)
      @set('long', compass.long)
    validate: () ->
#When things go right, validate() returns null.
      if compass.error?
        return (alert compass.error)
      unless @has('lat')? or @has('long')?
#How would this error ever fire? Need to see if its redundant.
        return (alert "Unable to fix GPS location.")
      unless @get('name')?
        return (alert "A name is required.")
#May need to change this one to @server_url + "/places/#{@_id}" when we add edit functionality.
    url: server_url + '/places'
  class window.Places extends Backbone.Collection
    url: server_url + '/places'
    model: Place
  class window.PlacesView extends Backbone.View
#The places view is a widget for creating Places, placed ontop of a \<ul> tag that lists the collection
    el: $('#content')
    initialize: ->
      @collection = new Places()
      @template = """<li><a href="{{location_url}}">{{name}}</a></li>"""
#We only need to add the creation widget once.
      $(@el).html """
        <div><a href="/#logout">[Logout]</a></div>
        <input id="new-place" placeholder="Name you waypoint">
        <ul id='places'></ul>
        """
#If any of these events happen, it repaints the list of items
      @collection.on('add remove reset sort change sync', (=> @render()))
      @collection.fetch
        data: {authentication_token: localStorage.auth_token}
        success: ( => @render())
#Press enter to make a new Place
    events: ->
      "keypress #new-place" : "createOnEnter"
    render: =>
#Erase the old list
      $('#places').html('')
#iterate over the collection and re-append to current list
      for place in @collection.models
        $('#places').append(templayed(@template)(place.attributes))
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
#Clears text box after success. Maybe I should put this in makePlace() and only clear on success.
        $('#new-place').val('')
  class window.RadioCollarRouter extends Backbone.Router
    routes:
      ""      : "home"
      "main"  : "main"
      "logout": "logout"
    home: ->
#Redirect to main if theyre already logged in
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
  window.App = new RadioCollarRouter()
  Backbone.history.start()

##STUFF TO REFACTOR:
# - Stop calling localStorage.auth_token. Use the model itself. Or store the model in local storage. Or everything in localstorage
# - Asign relevant DOM attributes to view attributes. Stop calling DOM directly so much.
# - Get rid of all the global vars when you're done hacking. If I must has globals, put them into the App namespace
# - A lot of views are using @el but they should actually be using @$el()
# - Add a refresh button