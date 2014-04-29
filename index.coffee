fs = require 'fs'
venues = require 'foursquarevenues'

config = fs.readFileSync 'config.json', 'utf-8'

apiClient = venues(config.clientId, config.clientSecret)

console.log apiClient.getCategories (err, categories) ->
  console.log 'err', err
  console.log 'categories', categories