import 'package:latlong2/latlong.dart';

class MapMarkerR3 {
  const MapMarkerR3({
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
  LatLng(4.617198, -74.086963),
  LatLng(4.634395, -74.079346),
  LatLng(4.649128, -74.078265),
  LatLng(4.669480, -74.071542),
  LatLng(4.679349, -74.057278),
  LatLng(4.683488, -74.042486),
];

const _path = 'assets/images/';

final mapMarkersR3 = [
  MapMarkerR3(
      image: '${_path}Marker.png',
      adress: 'CC Mall Plaza',
      time: '6:10 am',
      location: _locations[0]),
  MapMarkerR3(
      image: '${_path}Marker.png',
      adress: 'Cl. 45 #28-100',
      time: '6:15 am',
      location: _locations[1]),
  MapMarkerR3(
      image: '${_path}Marker.png',
      adress: 'Movistar Arena',
      time: '6:25 am',
      location: _locations[2]),
  MapMarkerR3(
      image: '${_path}Marker.png',
      adress: 'Av NQS #74-98',
      time: '6:35 am',
      location: _locations[3]),
  MapMarkerR3(
      image: '${_path}Marker.png',
      adress: 'Cl. 92 #23-2',
      time: '6:40 am',
      location: _locations[4]),
  MapMarkerR3(
      image: '${_path}UMNGMarker.png',
      adress: 'Universidad Militar',
      time: '6:50 am',
      location: _locations[5])
];
