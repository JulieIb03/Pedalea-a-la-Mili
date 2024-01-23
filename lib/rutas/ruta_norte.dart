import 'package:latlong2/latlong.dart';

class MapMarker {
  const MapMarker({
    required this.image,
    required this.adress,
    required this.time,
    required this.location,
  });
  final String image;
  final String adress;
  final String time;
  final LatLng location;
}

final _locations = [
  LatLng(4.759670, -74.042400),
  LatLng(4.748036, -74.031591),
  LatLng(4.731263, -74.032037),
  LatLng(4.713344, -74.034823),
  LatLng(4.706050, -74.036324),
  LatLng(4.683488, -74.042486),
];

const _path = 'assets/images/';

final mapMarkers = [
  MapMarker(
      image: '${_path}Marker.png',
      adress: 'Carrera 20 #182-35',
      time: '6:10 am',
      location: _locations[0]),
  MapMarker(
      image: '${_path}Marker.png',
      adress: 'Calle 170 con caño',
      time: '6:15 am',
      location: _locations[1]),
  MapMarker(
      image: '${_path}Marker.png',
      adress: 'Carrera 9 con Calle 153',
      time: '6:25 am',
      location: _locations[2]),
  MapMarker(
      image: '${_path}Marker.png',
      adress: 'Carrera 9 con Calle 134',
      time: '6:35 am',
      location: _locations[3]),
  MapMarker(
      image: '${_path}Marker.png',
      adress: 'Carrera 127 con Carrera 11',
      time: '6:40 am',
      location: _locations[4]),
  MapMarker(
      image: '${_path}UMNGMarker.png',
      adress: 'Universidad Militar',
      time: '6:50 am',
      location: _locations[5])
];
