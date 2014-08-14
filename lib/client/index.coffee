{extend} = require 'underscore'
request = require 'request'

class FoursquareClient
  constructor: (options) ->
    @baseUrl = 'https://api.foursquare.com/v2'
    @clientId = options.clientId
    @clientSecret = options.clientSecret
    @registerEndpoints 'venues'

  registerEndpoints: (namespace) ->
    endpoint = require("./endpoints/#{namespace}")(this)
    extend this, endpoint

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
      return callback err if err?
      return callback new Error body.meta.errorDetail unless body.meta.code == 200
      callback err, body

module.exports = FoursquareClient
