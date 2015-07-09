React = require 'react'
{div, p, a, button, span, input, label, h1} = React.DOM
L = require 'leaflet'
L.Icon.Default.imagePath = '/styles/images'
# {homegeojsonDir} = '/cozymap-leaflet/leaflet.homegeojson.js'
# onMapClick = '/cozymap-leaflet/PeaceMarker.js'




map = L.map 'map',
    center: [38, 0]
    zoom: 2
    doubleClickZoom: false
    # homegeojsonDir: '/geojsondata/home.geojson'


# coffeelint: disable=max_line_length
Esri_WorldImagery =
    L.tileLayer('http://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
    attribution: 'Tiles &copy; Esri &mdash; Source: Esri, i-cubed, USDA, USGS, AEX, GeoEye, Getmapping, Aerogrid, IGN, IGP, UPR-EGP, and the GIS User Community')

MapQuestOpen_Aerial =
  L.tileLayer('http://otile{s}.mqcdn.com/tiles/1.0.0/{type}/{z}/{x}/{y}.{ext}',
  type: 'sat'
  ext: 'jpg'
  attribution: 'Tiles Courtesy of <a href="http://www.mapquest.com/">MapQuest</a> &mdash; Portions Courtesy NASA/JPL-Caltech and U.S. Depart. of Agriculture, Farm Service Agency'
  subdomains: '1234')

OpenStreetMap_France =
  L.tileLayer('http://{s}.tile.openstreetmap.fr/osmfr/{z}/{x}/{y}.png',
  maxZoom: 19
  attribution: '&copy; Openstreetmap France | &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>')
# coffeelint: enable=max_line_length



Layers = OpenStreetMap_France
.addTo map


markerPosition = [42, 0]
popupContent = 'Are you a Mapper?'

MarkerDefault = L.marker markerPosition
.addTo map
.bindPopup popupContent
.openPopup map




redIcon = L.icon(
    iconUrl: '/styles/images/marker2-icon.png'
    shadowUrl: '/styles/images/marker-shadow.png'
    iconSize: [25, 41]
    iconAnchor: [12, 41]
    popupAnchor: [1, -34]
    shadowSize: [41, 41])


onMapClick = (e) ->
    marker = new L.marker(e.latlng,
      icon: redIcon
      draggable: 'true'
      opacity: '0.65')
    marker.on 'dragend', (event) ->
        marker = event.target
        markerzoom = map.getZoom()
        position = marker.getLatLng()
        popupContent = L.popup()
        # coffeelint: disable=max_line_length
            .setContent('<form class="placemarker-form">' +
            '<div class="input-group"><input type="text" name="bookmark-name" ' +
            'placeholder="Bookmark name" class="placemarker-form-input" value="">' +
            '<input type="hidden" class="placemarker-form-id" value="id">' +
            '<button type="submit" class="placemarker-form-submit">' +
            '+</button></div>' +
            '<div class="placemarker-form-coords">
            [Lat; Lng](zoom) = [' + position.lat.toFixed(4) + '; ' +
            position.lng.toFixed(4) + '](' + markerzoom + ')</div></form>' +
            '<form class="placemarker-form">' +
            '<div class="input-group">
            <input type="text" name="past-position" ' +
            'placeholder="[Lat; Lng](zoom)" class="placemarker-form-input" value="">' +
            '<input type="hidden" class="placemarker-form-id" value="goto">' +
            '<button type="submit" class="placemarker-form-submit">' +
            '@</button></div></form>')
      marker.setLatLng new L.LatLng(position.lat, position.lng), draggable: 'true'
      # coffeelint: enable=max_line_length
      marker.bindPopup(popupContent).openPopup()
      map.panTo new L.LatLng(position.lat, position.lng)
    return
    map.addLayer marker
    return
map.on 'dblclick', onMapClick
