import 'package:latlong2/latlong.dart';

class MapMarkerR2 {
  const MapMarkerR2({
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

final mapMarkersR2 = [
  MapMarkerR2(
      image: '${_path}Marker.png',
      adress: 'Cra 20 #182-35',
      time: '6:10 am',
      location: _locations[0]),
  MapMarkerR2(
      image: '${_path}Marker.png',
      adress: 'Cl 170 con caño',
      time: '6:15 am',
      location: _locations[1]),
  MapMarkerR2(
      image: '${_path}Marker.png',
      adress: 'Cra 9 con Cl 153',
      time: '6:25 am',
      location: _locations[2]),
  MapMarkerR2(
      image: '${_path}Marker.png',
      adress: 'Cra 9 con Cl 134',
      time: '6:35 am',
      location: _locations[3]),
  MapMarkerR2(
      image: '${_path}Marker.png',
      adress: 'Cra 127 con Cra 11',
      time: '6:40 am',
      location: _locations[4]),
  MapMarkerR2(
      image: '${_path}UMNGMarker.png',
      adress: 'Universidad Militar',
      time: '6:50 am',
      location: _locations[5])
];
