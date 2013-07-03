# @token             = if localStorage.token then localStorage.token else whereverTheTokenCameFrom
# localStorage.token = @token if @remember_me
@server_url  = '/api/v1'
console.log 'dont forget to change the @server_url to production.'
$ ->
  class window.Session extends Backbone.Model
    idAttribute: "_id"
    initialize: (options = {}) ->
    # validate: (attrs, optns) ->
    #   unless @authentication_token
    #     "Unable to authenticate. Check your email and password."
    url: server_url + '/sessions'

  class window.SessionView extends Backbone.View
    el: $('#content')
    initialize: ->
      @template = """<form id='sessionCreate'><div><input type="text" id="email" placeholder="User ID" tabindex="2" name="userID" maxlength="255"></div><div><input type="password" placeholder="Password" tabindex="3" class="password hide" id="password" name="password" maxlength="32"></div><input type="hidden" name="secretField" value="probablyAnId"><div><input type="checkbox" id="login-remember" tabindex="6" name="rememberOption">Remember User ID</div><div><a href="#" id= 'go'>Login now.</a></div></form>"""
      @model = new Session()
      @render()
    events:
      "click #go" : "authenticate"
    render: ->
      $(@el).html(@template)
    authenticate: ->
      @model.save {email: $('#email').val(), password: $('#password').val()}, {success: (-> App.navigate('/main', trigger: yes)) , error: (one, two, three) -> alert 'Failed to login. Check your email, password and internet connection.'}

  class window.RadioCollarRouter extends Backbone.Router
    routes:
      ""      : "home"
      "main" : "main"
    initialize: ->
      #All the initialization stuff goes here.
      #RICK: Change this.
      # pl    = new Place {title: 'placeholder. Rendered with backbone. yay!'}
      # @plvw = new PlaceNewView {model: pl}
    home: ->
      #construct the home view here...
      window.sessionView = new SessionView
    main: ->
      $('#content').empty()
      alert 'Welcome. Now put something useful into the main() route.'

  window.App = new RadioCollarRouter()
  Backbone.history.start()