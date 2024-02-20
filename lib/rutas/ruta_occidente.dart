import 'package:latlong2/latlong.dart';

class MapMarkerR1 {
  const MapMarkerR1({
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

final _locationsR1 = [
  LatLng(4.650651, -74.107197),
  LatLng(4.661459, -74.097073),
  LatLng(4.680851, -74.082577),
  LatLng(4.687693, -74.074042),
  LatLng(4.688526, -74.064131),
  LatLng(4.683488, -74.042486),
];

const _path = 'assets/images/';

final mapMarkersR1 = [
  MapMarkerR1(
      image: '${_path}Marker.png',
      adress: 'Plaza Claro',
      time: '6:10 am',
      location: _locationsR1[0]),
  MapMarkerR1(
      image: '${_path}Marker.png',
      adress: 'Simón Bolívar',
      time: '6:15 am',
      location: _locationsR1[1]),
  MapMarkerR1(
      image: '${_path}Marker.png',
      adress: 'Metropolis',
      time: '6:25 am',
      location: _locationsR1[2]),
  MapMarkerR1(
      image: '${_path}Marker.png',
      adress: 'Cafam Floresta',
      time: '6:35 am',
      location: _locationsR1[3]),
  MapMarkerR1(
      image: '${_path}Marker.png',
      adress: 'Iserra 100',
      time: '6:40 am',
      location: _locationsR1[4]),
  MapMarkerR1(
      image: '${_path}UMNGMarker.png',
      adress: 'Universidad Militar',
      time: '6:50 am',
      location: _locationsR1[5])
];
