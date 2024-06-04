import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:location_app/controllers/Controller.dart';

import '../CustomUser.dart';
import '../FriendsList.dart';


class MapPage extends StatefulWidget {
  const MapPage({super.key});


  @override
  State<StatefulWidget> createState() => _MapPage();
}

class _MapPage extends State<MapPage>{

  final Completer<GoogleMapController> _googleMapController = Completer();
  CameraPosition? _cameraPosition;
  Location? _location;
  LocationData? _currentLocation;
  String? name;
  Set<Marker> markers = {};
  List<CustomUser> users = [];

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() {
    _location = Location();
    _cameraPosition = const CameraPosition(
        target: LatLng(0, 0), // this is just the example lat and lng for initializing
        zoom: 15
    );
    _initLocation();
    _initFriendsMarkers();
  }


  //function to listen when we move position
  void _initFriendsMarkers() {
    getFriendsList().then((value) {
      for (int i = 0; i < value!.documents.length; i++) {

        Map<String, dynamic>? map = value.documents[i].data;
        FriendsList list = FriendsList.fromMap(map);

        for (int j = 0; j < list.arrayOfFriendsId.length; j++) {
          getAddedFriend(list.arrayOfFriendsId).then((onValue){

            Map<String, dynamic>? map = onValue!.documents[j].data;
            CustomUser user = CustomUser.fromMap(map);
            setState(() {
              users.add(user);
            });
          });
        }
      }
    });

    _initMarkers();
  }

  //function to listen when we move position
  void _initMarkers() {

    var myMarker = Marker(
        markerId: const MarkerId("I"),
        position: LatLng(_currentLocation?.latitude ?? 0, _currentLocation?.longitude ?? 0),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
        infoWindow:  InfoWindow(title: name)
    );
    markers.add(myMarker);

    for(int i=0; i<users.length; i++){
      var m = Marker(
          markerId: MarkerId(users[i].name),
          position: LatLng(users[i].latitude ?? 0, users[i].longitude ?? 0),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
          infoWindow:  InfoWindow(title: users[i].name)
      );
      markers.add(m);
    }

  }

  //function to listen when we move position
  void _initLocation() {
    _location?.getLocation().then((location) {
      setState(() {
        _currentLocation = location;
        _updateMarkerPosition(location);
        _initFriendsMarkers();
      });

      getUser().then((onValue){
        setState(() {
          name = onValue?.name;
        });

        moveToPosition(LatLng(location.latitude ?? 0, location.longitude ?? 0));

      });
    });

    _location?.onLocationChanged.listen((newLocation) {
      setState(() {
        _currentLocation = newLocation;
        updateUserLocation(LatLng(newLocation.latitude ?? 0, newLocation.longitude ?? 0));
        _updateMarkerPosition(newLocation);
        _initFriendsMarkers();
      });
    });
  }

  void _updateMarkerPosition(LocationData latLng) {
    setState(() {
      _currentLocation = latLng;
    });
  }

  moveToPosition(LatLng latLng) async {
    GoogleMapController mapController = await _googleMapController.future;
    mapController.animateCamera(
        CameraUpdate.newCameraPosition(
            CameraPosition(
                target: latLng,
                zoom: 15
            )
        )
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return _getMap();
  }

  Widget _getMarker() {
    return Container(
      width: 20,
      height: 20,
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
          color: Colors.greenAccent,
          borderRadius: BorderRadius.circular(50),
          boxShadow: const [
            BoxShadow(
                color: Colors.grey,
                offset: Offset(0,3),
                spreadRadius: 2,
                blurRadius: 6
            )
          ]
      ),
    );
  }

  Widget _getMap() {
    return (_location == null && _currentLocation == null && _cameraPosition == null)  // If user location has not been found
        ? const Center(
            // Display Progress Indicator
            child: CircularProgressIndicator(),
          )
        :  Stack(
      children: [
        GoogleMap(
          initialCameraPosition: _cameraPosition!,
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {
            // now we need a variable to get the controller of google map
            if (!_googleMapController.isCompleted) {
              _googleMapController.complete(controller);
            }
          },
          markers: markers
        ),
        Container(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.location_searching),
              color: Colors.lightBlueAccent,
              onPressed: () {
                moveToPosition(LatLng(_currentLocation?.latitude ?? 0,
                    _currentLocation?.longitude ?? 0));
              },
            )
        )
      ],
    );

  }
}

