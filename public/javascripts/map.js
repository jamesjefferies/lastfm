var SOUNDMAP = {

  map: null,
  getData: function() {

    SOUNDMAP.map = SOUNDMAP.loadMap();

    $.getJSON("/data.json", function( data ) {
        SOUNDMAP.addMarkers(data);
      });
  },
  loadMap: function() {

    var map = L.map('map');
    map.setView([51.5, -0.09], 7);

    L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(map);

    return map;

  },
  addMarkers: function(data) {
    for (var count in data) {
      SOUNDMAP.addMarker(L, data[count]);
    }
  },

  addMarker: function(L, m) {
      var LeafIcon = L.Icon.extend({
        options: {
          // iconSize:     [38, 95],
          // shadowSize:   [50, 64],
      //     iconAnchor:   [22, 94],
          // shadowAnchor: [4, 62],
      //    popupAnchor:  [-3, -76]
        }
      });

      var popUpText = m.top_artist + " is the favourite in: " + m.metro;

      var icon = new LeafIcon({iconUrl: m.image_url});
      L.marker([m.lat, m.long], {icon: icon}).bindPopup(popUpText).addTo(SOUNDMAP.map);
    }
}
window.onload = SOUNDMAP.getData();
