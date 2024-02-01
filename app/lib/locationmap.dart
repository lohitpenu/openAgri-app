import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pest_app/home.dart';
import 'package:pest_app/url.dart';

class LocationMap extends StatefulWidget {
  LocationMap(
      {super.key,
      required String this.crop_data,
      required String this.crop_type,
      required String this.description});

  String crop_data;
  String crop_type;
  String description;

  @override
  State<LocationMap> createState() => _LocationMapState();
}

double latitude = 0.0;
double longitude = 0.0;
bool locationDetected = false;

class _LocationMapState extends State<LocationMap> {
  MapController controller = MapController.customLayer(
    initMapWithUserPosition: UserTrackingOption(enableTracking: true),
    // initPosition: GeoPoint(latitude: latitude, longitude: longitude),
    customTile: CustomTile(
      sourceName: "opentopomap",
      tileExtension: ".png",
      maxZoomLevel: 25,
      urlsServers: [
        TileURLs(
          url: "https://tile.opentopomap.org/",
          subdomains: [],
        )
      ],
      tileSize: 256,
    ),
  );

  void getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // await Geolocator.checkPermission();
    await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position.latitude + position.longitude);

    setState(() {
      latitude = position.latitude.toDouble();
      longitude = position.longitude.toDouble();
      locationDetected = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
  }

  postData(crop_data, description, crop_type, latitude, longitude) async {
    final dio = Dio();

    final formData = FormData.fromMap({
      "crop_name": crop_data,
      "crop_description": description,
      "crop_type": crop_type,
      "latitude": latitude,
      "longitude": longitude
    });
    print("FORM DATA IS XxXXXXXXXXXX");
    print(formData);
    final response = await dio.post(url + '/api/addcategory/', data: formData);

    return response;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Your Location",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 56, 193, 113),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: OSMFlutter(
                  mapIsLoading: Center(child: CircularProgressIndicator()),
                  markerOption: MarkerOption(
                    defaultMarker: MarkerIcon(
                      assetMarker: AssetMarker(
                          image: AssetImage("images/farmer.png"),
                          scaleAssetImage: 5),
                    ),
                  ),
                  userLocationMarker: UserLocationMaker(
                    personMarker: MarkerIcon(
                      assetMarker: AssetMarker(
                          image: AssetImage("images/farmer.png"),
                          scaleAssetImage: 5),
                    ),
                    directionArrowMarker: MarkerIcon(
                      assetMarker: AssetMarker(
                          image: AssetImage("images/farmer.png"),
                          scaleAssetImage: 5),
                    ),
                  ),
                  stepZoom: 20,
                  minZoomLevel: 16,
                  controller: controller,
                  enableRotationByGesture: false,
                  showZoomController: true,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
              child: ElevatedButton(
                onPressed: () {
                  postData(widget.crop_data, widget.description,
                      widget.crop_type, latitude, longitude);

                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                      (Route<dynamic> route) => route is Home);
                },
                child: Text(
                  'Upload',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 56, 193, 113),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // <-- Radius
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
