fs = require 'fs'
request = require 'request'
FoursquareClient = require './lib/client'


config = fs.readFileSync 'config.json', 'utf-8'
{clientId, clientSecret} = JSON.parse config

apiClient = new FoursquareClient {clientId, clientSecret}

apiClient.getCategories (err, data) ->
  console.log 'err', err
  console.log 'data', data
