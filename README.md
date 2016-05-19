four-alarm
==========

Heat mapping against the Foursquare API

![Heatmap of Burger Joints in the Lakeview neighborhood of Chicago, IL](https://camo.githubusercontent.com/2afad9577ffa75d065138629cad9474392893930/687474703a2f2f662e636c2e6c792f6974656d732f324632563356317a336e33363166304e3379334a2f53637265656e25323053686f74253230323031342d30352d30382532306174253230342e30312e3539253230504d2e706e67)

Setup
=====

1) Use Node 6.2.x and install dependencies

```bash
nvm use
npm i
```

2) Request a [Foursquare API key](https://foursquare.com/developers/register)

3) Create a `config.json` file:

```bash
cp config.json.example config.json
```

4) Update `config.json` with your Foursquare Client ID & Client Secret.

Usage
=====

Start a server on port 5678:

```bash
npm start
```

Set `PORT` in your environment to start somewhere else:

```bash
PORT=8888 npm start
```
