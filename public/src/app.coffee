@server_url  = '/api/v1'
console.log 'dont forget to change the @server_url to production.'
Backbone.Model.idAttribute = "_id"
$ ->
  class window.Session extends Backbone.Model
    initialize: () ->
    url: server_url + '/sessions'

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
      #Override backbone.sync to attach the token.
      localStorage.auth_token = @model.get('authentication_token')
      App.navigate('/main', trigger: yes)
    ohNo: () ->
      alert 'Failed to login. Check your email, password and internet connection.'
    authenticate: ->
      #Why do I need to call the callbacks like that?
      @model.save {email: $('#email').val(), password: $('#password').val()}, {success: ( => @proceed()) , error: ( => @ohNo())}
  class window.Place extends Backbone.Model
    initialize: () ->
      @set('lat', compass.lat)
      @set('long', compass.long)
    validate: () ->
      if compass.error?
        return (alert compass.error)
      unless @get('lat')? or @get('long')?
        #How would this error ever fire?
        return (alert "Unable to fix GPS location.")
      unless @get('name')?
        return (alert "A name is required.")
    url: server_url + '/places'
  class window.CreatePlacesView extends Backbone.View
    el: $('#content')
    initialize: ->
      @template = """
      <input id="new-place" placeholder="Name you waypoint">
      """
      @model = new Place()
      @render()
    events: ->
      "keypress #new-place" : "createOnEnter"
    createOnEnter: (event) =>
      if event.keyCode is 13
        @setFields()
        #probably a better way of doing this...
        $('#new-place').val('')
    render: ->
      $(@el).html(@template)
    setFields: () ->
      @model.set('name', $('#new-place').val())
      @model.set('lat',  compass.lat)
      @model.set('long', compass.long)
      @model.save({authentication_token: localStorage.auth_token})

  class window.RadioCollarRouter extends Backbone.Router
    routes:
      ""      : "home"
      "main" : "main"
    initialize: ->
      #Just stubbing this for now.
      ''
    home: ->
      if localStorage.auth_token?
        return App.navigate('/main', trigger: yes)
      else
        window.sessionView = new SessionView
    main: ->
      unless localStorage.auth_token?
        return App.navigate('/', trigger: yes)
      $('#content').empty()
      window.createPlaces = new CreatePlacesView
  window.App = new RadioCollarRouter()
  Backbone.history.start()