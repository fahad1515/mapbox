import 'dart:html';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mapbox/model/MapMarker.dart';
import 'package:latlong2/latlong.dart';

const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1IjoiZmFoYWQxNTE1IiwiYSI6ImNrZWV6OWZzZDE3ZTMyc3A3cGw4anRvY20ifQ.WqiePBffH7k0M-00000';

const MAPBOX_STYLE = 'mapbox/dark-v10';
const MARKER_COLOR = Color(0xFF3DC5A7);
const MARKER_SIZE_EXPANDED = 55.0;
const MARKER_SEZE_SHRINK =38.0;
final _myLocation = LatLng(-12.0362176, -77.0296812);

class AnimatedMarkersMap extends StatefulWidget {
  const AnimatedMarkersMap({Key key}) : super(key: key);

  @override
  _AnimatedMarkersMapState createState() => _AnimatedMarkersMapState();
}

class _AnimatedMarkersMapState extends State<AnimatedMarkersMap> with SingleTickerProviderStateMixin {

  final _pageController = PageController();
  late final AnimationController  _animationController;
  int _selectedIndex = 0;

  List<Marker> _buildMarkers() {
    final _markerList = <Marker>[];
    for (int i = 0; i < mapMarkers.length; i++) {
      final mapItem = mapMarkers[i];
      _markerList.add(
        Marker(
          height: MARKER_SIZE_EXPANDED,
          width: MARKER_SIZE_EXPANDED,
          point: mapItem.location,
          builder: (_) {
            return GestureDetector(
              onTap: () {
               _selectedIndex = i;
                setState(() {
                        _pageController.animateToPage(i,
                    duration: const Duration(microseconds: 500),
                    curve: Curves.elasticInOut); //bounceInOut);
                print('selected : ${mapItem.title}');           
                                });
              },
              child: _MyLocationMarker(
                 selected:_selectedIndex == i,
              ),
               
            );
          }));
    }
    return _markerList;
  }

  @override
    void initState() {
      // TODO: implement initState
      super.initState();
    }
   @override
     void dispose() {
       _animationController.dispose();
       super.dispose();
     }

  @override
  Widget build(BuildContext context) {
    final _markers = _buildMarkers();
    return Scaffold(
      appBar: AppBar(
        title: Text('Animated Markers'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt_outlined),
            onPressed: () => null,
          )
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              minZoom: 5,
              maxZoom: 18,
              zoom: 13,
              center: _myLocation,
            ),
            nonRotatedLayers: [
              TileLayerOptions(
                urlTemplate:
                    'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                additionalOptions: {
                  'accessToken': MAPBOX_ACCESS_TOKEN,
                  'id': MAPBOX_STYLE,
                },
              ),
              MarkerLayerOptions(
                markers: _markers,
              ),
              MarkerLayerOptions(markers: [
                Marker(
                    point: _myLocation,
                    builder: (_) {
                      return _MyLocationMarker();
                    }),
              ])
            ],
          ),
          //add a pageview
          Positioned(
            left: 0,
            right: 0,
            bottom: 50,
            height: MediaQuery.of(context).size.height * 0.3,
            child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: mapMarkers.length,
                itemBuilder: (context, index) {
                  final item = mapMarkers[index];
                  return _MapItemDetails(
                    mapMarker: item,
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class _LocationMarker extends StatelessWidget {
  const _LocationMarker({Key? key, this.selected = false}) : super(key: key);

final bool selected;
  @override
  Widget build(BuildContext context) {
    final size = selected ? MARKER_SIZE_EXPANDED : MARKER_SEZE_SHRINK;
    return Center(
      child: AnimatedContainer(
        height: size,
        width: size,
        duration: const Duration(milliseconds: 400),
        child:Image.asset('assets/animated.png'), 
      ) ,
    );
  }
}

class _MyLocationMarker extends StatelessWidget {
  const _MyLocationMarker({Key key, bool selected}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: MARKER_COLOR,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _MapItemDetails extends StatelessWidget {
  const _MapItemDetails({
    Key key,
    required this.mapMarker,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _style = TextStyle(color: Colors.grey[800], fontSize: 20);
    final _styleTitle = TextStyle(
        color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold);
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        margin: EdgeInsets.zero,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(child: Image.asset(mapMarker.image)),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          mapMarker.title,
                          style: _styleTitle,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          mapMarker.address,
                          style: _styleTitle,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            MaterialButton(
              padding: EdgeInsets.zero,
              onPressed: () => null,
              color: MARKER_COLOR,
              elevation: 6,
              child: Text(
                'call',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
