request = require 'request'
{extend} = require 'underscore'

class FoursquareClient
  constructor: (options) ->
    @baseUrl = 'https://api.foursquare.com/v2'
    @clientId = options.clientId
    @clientSecret = options.clientSecret

  fetch: (endpoint, queryParams, callback) ->
    defaultQueryParams =
      v: '20140429'
      client_id: @clientId
      client_secret: @clientSecret

    apiOptions =
      uri: "#{@baseUrl}/#{endpoint}"
      json: true
      qs: extend {}, queryParams, defaultQueryParams

    request apiOptions, (err, res, body) ->
      callback err, body

  getCategories: (callback) ->
    @fetch 'venues/categories', {}, (err, data) ->
      callback err, categories: data.response.categories


module.exports = FoursquareClient