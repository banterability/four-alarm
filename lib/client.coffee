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
      return callback err if err?
      return callback new Error body.meta.errorDetail unless body.meta.code == 200
      callback err, body

  getCategories: (callback) ->
    @fetch 'venues/categories', {}, (err, data) ->
      callback err, data?.response?.categories

  getVenues: (options = {}, callback) ->
    throw new Error "Location parameter ('ll' or 'near') required" unless @_hasRequiredParams options
    @fetch 'venues/search', options, (err, data) ->
      callback err, data?.response?.venues

  _hasRequiredParams: (options) ->
    options.ll? || options.near?

module.exports = FoursquareClient
