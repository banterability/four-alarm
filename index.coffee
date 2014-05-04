fs = require 'fs'
{map} = require 'underscore'
FoursquareClient = require './lib/client'

config = fs.readFileSync 'config.json', 'utf-8'
{clientId, clientSecret} = JSON.parse config

apiClient = new FoursquareClient {clientId, clientSecret}

searchOptions =
  categoryId: '4bf58dd8d48988d16c941735' # Burger Joint
  intent: 'browse'
  near: 'Chicago, IL'

apiClient.getVenues searchOptions, (err, venues) ->
  console.log map venues, (venue) -> venue.name
