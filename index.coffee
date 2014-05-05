fs = require 'fs'
express = require 'express'
morgan = require 'morgan'
FoursquareClient = require './lib/client'

app = express()
app.use morgan('dev')

config = fs.readFileSync 'config.json', 'utf-8'
{clientId, clientSecret} = JSON.parse config

apiClient = new FoursquareClient {clientId, clientSecret}

app.get '/', (req, res) ->
  pageStream = fs.createReadStream('views/index.html')
  pageStream.on 'open', ->
    pageStream.pipe(res)
  pageStream.on 'error', (err) ->
    res.send 500, err

app.get '/categories', (req, res) ->
  apiClient.getCategories (err, categories) ->
    return respondWithError res, err if err?
    res.send categories

app.get '/venues/:category', (req, res) ->
  # TODO: Handle other valid location parameter pairs (ll+radius, near+radius)
  {ne, sw} = req.query
  console.log "ne", ne
  console.log "sw", sw
  unless ne? && sw?
    return respondWithError res, new Error 'Bounding box (ne + sw) required'

  apiOptions =
    categoryId: req.params.category
    intent: 'browse'
    ne: ne
    sw: sw

  apiClient.getVenues apiOptions, (err, venues) ->
    return respondWithError res, err if err?
    res.send venues

respondWithError = (res, err) ->
  res.send 500, {error: err.toString()}

app.listen 5678, ->
  console.log 'up on 5678...'

