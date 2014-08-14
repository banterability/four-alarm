hasRequiredParamsForVenueSearch = (options) ->
  if options.intent == 'browse'
    (options.ll? && options.radius?) || (options.ne? && options.sw?) || (options.near? && options.radius?)
  else
    options.ll? || options.near?

module.exports = (client) ->
  return {
    venues:
      categories: (callback) ->
        client.fetch 'venues/categories', {}, (err, data) ->
          callback err, data?.response?.categories

      search: (options = {}, callback) ->
        throw new Error "Missing location parameter(s)" unless hasRequiredParamsForVenueSearch options
        client.fetch 'venues/search', options, (err, data) ->
          callback err, data?.response?.venues
  }