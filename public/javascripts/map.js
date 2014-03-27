var SOUNDMAP = {

  json_data: [],
  getData: function() {
    $.getJSON("/data.json", function( data ) {
        SOUNDMAP.json_data = data;
        SOUNDMAP.loadMap(data);
      });
  },
  loadMap: function(data) {

    var map = L.map('map').setView([51.5, -0.09], 7);

    L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(map);

      var array = data;

      for (var count in array) {
        SOUNDMAP.addMarker(L, map, array[count]);
      }
    },

    addMarker: function(L, map, m) {
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
      L.marker([m.lat, m.long], {icon: icon}).bindPopup(popUpText).addTo(map);
    }
}
window.onload = SOUNDMAP.getData();
