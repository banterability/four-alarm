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
      client_id: @clientId
      client_secret: @clientSecret
      v: '20140429'

    apiOptions =
      json: true
      qs: extend {}, queryParams, defaultQueryParams
      uri: "#{@baseUrl}/#{endpoint}"

    request apiOptions, (err, res, body) ->
      return callback err if err?
      return callback new Error body.meta.errorDetail unless body.meta.code == 200
      callback err, body

module.exports = FoursquareClient
