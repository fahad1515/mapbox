import 'package:latlong2/latlong.dart';

class MapMarker {
  const MapMarker({this.image, this.title, this.address, this.location});
  final String image;
  final String title;
  final String address;
  final LatLng location;
}

final _locations = [
  LatLng(-12.0080041, -77.07782337),
  LatLng(-12.0080041, -77.07782337),
];

const _path = 'assets/animated_markers_map/';

final mapMarkers = [
  MapMarker(
      image: '${_path}logo_marcos.png',
      title: 'Marcos',
      address: 'Adress Marcos',
      location: _locations[0]),
  MapMarker(
      image: '${_path}logo_marcos.png',
      title: 'Marcos',
      address: 'Adress Marcos',
      location: _locations[1]),
  MapMarker(
      image: '${_path}logo_marcos.png',
      title: 'Marcos',
      address: 'Adress Marcos',
      location: _locations[2])
];
