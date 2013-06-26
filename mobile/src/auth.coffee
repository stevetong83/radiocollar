$ ->
  $('#go').on 'click', ->
    $.ajax
      type: 'POST'
      url: "http://radiocollarapp.herokuapp.com/api/v1/sessions"
      data: {"email": $('#email').val(), "password": $('#password').val()}
      dataType: "json"
      success: (data) ->
        #grab the token
        window.token = $.parseJSON(responseData.responseText).token
        #Add the token to AJAX HTTP headers
        $.ajaxSetup({ headers : { "auth_token" : window.token } });
        #Clear the screen
        $('#content').empty()
        #Hit backbone's 'home' route. Not yet implemented.
        window.location = '#home'
      error: (responseData) ->
        #Popup an alert with the server response.
        alert $.parseJSON(responseData.responseText).errors

# Sample for testing locally
# function () {
#     return $.ajax({
#       type: 'POST',
#       url: "https://radiocollarapp.herokuapp.com/api/v1/sessions",
#       data: {
#         "email": "test@test.com",
#         "password": "password"
#       },
#       dataType: "json",
#       success: function(data) {
#         return data;
#       },
#       error: function(responseData, textStatus, errorThrown) {
#         return console.error('error!');
#       }
#     });
#   }