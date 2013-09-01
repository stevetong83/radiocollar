class RadioCollar.Views.SessionView extends Backbone.View
  el: '#content'
  initialize: ->
    @template = """
    <form id='sessionCreate'>
    <div><input type="text" id="email" placeholder="User ID" tabindex="2" name="userID" maxlength="255"></div>
    <div><input type="password" placeholder="Password" tabindex="3" class="password hide" id="password" name="password" maxlength="32"></div>
    <div><a href="#" id="go" class="btn-wide">Login now.</a></div></form>
    """
    @model = new RadioCollar.Models.Session()
    @render()
  events:
    "click #go" : "authenticate"
  render: ->
    $(@el).html(@template)
  proceed: =>
    #Override backbone.sync to attach the token.
    localStorage.auth_token = @model.get('authentication_token')
    RadioCollar.App.navigate('/main', trigger: yes)
  attempts: 0
  ohNo: ->
    $('#go').text("#{++@attempts} failed login attempts. Try again.")
  authenticate: ->
    #Why do I need to enclose the callbacks like that? Oh, CoffeeScript.
    @model.save {email: $('#email').val(), password: $('#password').val()}, {success: ( => @proceed()) , error: ( => @ohNo())}