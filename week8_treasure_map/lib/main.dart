import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:week8_treasure_map/manage_places.dart';
import 'package:week8_treasure_map/new_place_dialog.dart';
import 'db_helper.dart';
import 'place.dart';

void main() {
  runApp(const TreasureMap());
}

class TreasureMap extends StatelessWidget {
  const TreasureMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Treasure Map',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainMap(),
    );
  }
}

class MainMap extends StatefulWidget {
  const MainMap({Key? key}) : super(key: key);

  @override
  State<MainMap> createState() => _MainMapState();
}

class _MainMapState extends State<MainMap> {
  CameraPosition position =
      const CameraPosition(target: LatLng(41.9028, 12.4961), zoom: 12);
  final DbHelper dbHelper = DbHelper();
  Set<Marker> markers = {};

  Position createPosition(double lat, double lon) {
    return Position(
        longitude: lon,
        latitude: lat,
        timestamp: DateTime.now(),
        accuracy: 0,
        heading: 0,
        altitude: 0,
        speed: 0,
        speedAccuracy: 0);
  }

  Future<Position> _getCurrentLocation() async {
    bool isGeolocatioAvailable = await Geolocator.isLocationServiceEnabled();

    Position pos =
        createPosition(position.target.latitude, position.target.longitude);

    if (isGeolocatioAvailable) {
      try {
        pos = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best);
      } catch (error) {
        return pos;
      }
    }
    return pos;
  }

  Future _getPlaces() async {
    List<Place> places = await dbHelper.getPlaces();
    places.forEach((element) {
      addMarker(createPosition(element.lat, element.lon), element.id.toString(),
          element.name.toString());
    });
  }

  void addMarker(Position position, String markerId, String markerTitle) {
    final marker = Marker(
        markerId: MarkerId(markerId),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(title: markerTitle),
        icon: (markerId == 'currpos')
            ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)
            : BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueOrange));

    markers.add(marker);
    setState(() {
      markers = markers;
    });
  }

  void refreshList() {
    markers = {};
    _getCurrentLocation()
        .then((pos) => addMarker(pos, 'currpos', 'You are here!'));
    _getPlaces();
  }

  @override
  void initState() {
    _getCurrentLocation()
        .then((pos) => addMarker(pos, 'currpos', 'You are here!'));
    dbHelper.insertMockData().then((_) => _getPlaces());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('The Treasure Map'),
          actions: [
            IconButton(
                onPressed: () {
                  MaterialPageRoute route = MaterialPageRoute(
                      builder: (context) => ManagePlaces(refreshList));
                  Navigator.push(context, route);
                },
                icon: const Icon(Icons.list))
          ],
        ),
        body: Container(
          child: GoogleMap(
            initialCameraPosition: position,
            markers: markers,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Place place = Place(
                0, '', position.target.latitude, position.target.longitude, '');

            showDialog(
                context: context,
                builder: (context) =>
                    PlaceDialog(place, true, (() => refreshList()))
                        .buildDialog(context));
          },
        ));
  }
}
