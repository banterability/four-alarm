fs = require 'fs'
express = require 'express'
morgan = require 'morgan'
FoursquareClient = require './lib/client'

app = express()
app.use morgan('dev')

config = fs.readFileSync 'config.json', 'utf-8'
{clientId, clientSecret} = JSON.parse config

apiClient = new FoursquareClient {clientId, clientSecret}

app.get '/categories', (req, res) ->
  apiClient.getCategories (err, categories) ->
    return respondWithError res, err if err?
    res.send categories

respondWithError = (res, err) ->
  res.send 500, {error: err.toString()}

app.listen 5678, ->
  console.log 'up on 5678...'

