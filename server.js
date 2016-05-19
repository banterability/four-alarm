const Dodge = require('dodge');
const express = require('express');
const fs = require('fs');
const morgan = require('morgan');

const {clientId, clientSecret} = require('./config.json');

const app = express();
app.use(express.static(`${__dirname}/public`));
app.use(morgan('dev'));

const apiClient = new Dodge({clientId, clientSecret});

app.get('/', (req, res) => {
  fs.createReadStream('views/index.html').pipe(res);
});

app.get('/categories', (req, res) => {
  apiClient.venues.categories((err, categories) => {
    if (err) return respondWithError(res, err);
    res.send(categories);
  });
});

app.get('/venues/:category', (req, res) => {
  // TODO: Handle other valid location parameter pairs (ll+radius, near+radius)
  const {ne, sw} = req.query;
  if (!ne || !sw){
    return respondWithError(res, new Error('Bounding box (ne + sw) required'))
  }

  const apiOptions = {
    categoryId: req.params.category,
    intent: 'browse',
    ne,
    sw
  }

  apiClient.venues.search(apiOptions, (err, venues) => {
    if (err) return respondWithError(res, err);
    res.send(venues);
  });
});

function respondWithError(res, err){
  res.send(500, {error: err.toString()});
}

const port = process.env.PORT || 5678;
app.listen(port, () => {
  console.log(`Server up on ${port}…`);
});
