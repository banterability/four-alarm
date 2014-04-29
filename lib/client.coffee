request = require 'request'


class FoursquareClient
  constructor: (options) ->
    @baseUrl = 'https://api.foursquare.com/v2'
    @clientId = options.clientId
    @clientSecret = options.clientSecret

  fetch: (endpoint, params, callback) ->
    requestOptions =
      uri: "#{@baseUrl}/#{endpoint}"
      qs:
        v: '20140429'
        client_id: @clientId
        client_secret: @clientSecret
      json: true

    request requestOptions, (err, res, body) ->
      callback err, body

  getCategories: (callback) ->
    @fetch 'venues/categories', {}, callback
    # categories: data.response.categories


module.exports = FoursquareClient