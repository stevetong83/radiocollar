class RadioCollar.Models.Place extends Backbone.Model
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
  urlRoot: RadioCollar.server_url + '/places'