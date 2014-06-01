var map = heatmap = null;
var initMap = function(){
  var mapOptions = {
    center: new google.maps.LatLng(41.896596, -87.643159),
    zoom: 14
  };
  map = new google.maps.Map(document.querySelector('#map'), mapOptions);
  heatmap = new google.maps.visualization.HeatmapLayer();

  document.querySelector('#category-id').addEventListener('change', function(ev){
    fetchMapDataForCategory(ev.currentTarget.value);
  }, false);
  document.querySelector('#heatmap-radius').addEventListener('change', function(ev){
    updateHeatmapRadius(ev.currentTarget.value);
  }, false);
  fetchCategories();
  google.maps.event.addListener(map, 'bounds_changed', updateVenues);
};

var updateVenues = _.debounce(function(){
  var categoryId = document.querySelector('#category-id').value;
  if (categoryId === 'placeholder'){ return false; }
  fetchMapDataForCategory(categoryId);
}, 250);

google.maps.event.addDomListener(window, 'load', initMap);

var getMapBoundaries = function(){
  var bounds = map.getBounds();
  return {
    ne: '' + bounds.getNorthEast().lat() + ',' + bounds.getNorthEast().lng(),
    sw: '' + bounds.getSouthWest().lat() + ',' + bounds.getSouthWest().lng()
  };
};

var updateHeatmapRadius = function(radius){
  heatmap.set('radius', parseInt(radius, 10));
};

var generateHeatmap = function(venues){
  var pointData = new google.maps.MVCArray(venues.map(function(venue){
    return new google.maps.LatLng(venue.location.lat, venue.location.lng);
  }));
  // https://developers.google.com/maps/documentation/javascript/reference#HeatmapLayerOptions
  heatmap.setData(pointData);
  heatmap.setMap(map);
};

var showLoadingBar = function(){
  document.querySelector('.loading').style.opacity = 1;
};

var hideLoadingBar = function(){
  document.querySelector('.loading').style.opacity = 0;
};

var fetchCategories = function(){
  // TODO: Handle 3rd-level categories (optgroups can't be nested)
  showLoadingBar();
  fetch('/categories', function(){
    generateCategoryList(JSON.parse(this.responseText));
    hideLoadingBar();
  });
};

var generateCategoryList = function(categories){
  var fragment, optionList;
  fragment = document.createDocumentFragment();
  categories.forEach(function(category){
    var groupEl;
    groupEl = document.createElement('optgroup');
    groupEl.label = category.name;
    category.categories.forEach(function(subcategory){
      var optionEl;
      optionEl = document.createElement('option');
      optionEl.label = subcategory.name;
      optionEl.value = subcategory.id;
      groupEl.appendChild(optionEl);
    });
    fragment.appendChild(groupEl);
  });

  // remove placeholder
  optionList = document.querySelector('#category-id');
  optionList.removeChild(optionList.querySelector('.placeholder'));

  optionList.appendChild(fragment);
  optionList.disabled = null;
};

var fetchMapDataForCategory = function(categoryId){
  var boundaries, requestUrl;
  showLoadingBar();
  boundaries = getMapBoundaries();
  requestUrl = '/venues/' + categoryId + '/?ne=' + boundaries.ne + '&sw=' + boundaries.sw;
  fetch(requestUrl, function(){
    var mapData = JSON.parse(this.responseText);
    generateHeatmap(mapData);
    hideLoadingBar();
  });
};

var fetch = function(url, callback){
  var request;
  request = new XMLHttpRequest();
  request.onload = callback;
  request.open('get', url, true);
  request.send();
};