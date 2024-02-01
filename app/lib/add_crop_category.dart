import 'package:flutter/material.dart';
// import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:pest_app/locationmap.dart';
// import 'package:pest_app/model.dart';
// import 'package:latlong2/latlong.dart' as latLng;
// import 'home.dart';

class AddCropCategory extends StatefulWidget {
  const AddCropCategory({super.key});

  @override
  State<AddCropCategory> createState() => _AddCropCategoryState();
}

// double latitude = 0.0;
// double longitude = 0.0;
// bool locationDetected = false;
// MapController controller = MapController.customLayer(
//   initMapWithUserPosition: UserTrackingOption(enableTracking: true),
//   // initPosition: GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
//   customTile: CustomTile(
//     sourceName: "opentopomap",
//     tileExtension: ".png",
//     maxZoomLevel: 25,
//     urlsServers: [
//       TileURLs(
//         url: "https://tile.opentopomap.org/",
//         subdomains: [],
//       )
//     ],
//     tileSize: 256,
//   ),
// );

class _AddCropCategoryState extends State<AddCropCategory> {
  final crop_data = TextEditingController();
  final crop_type = TextEditingController();
  final description = TextEditingController();

  @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   getLocation();
  // }

  // void getLocation() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     // Location services are not enabled don't continue
  //     // accessing the position and request users of the
  //     // App to enable the location services.
  //     return Future.error('Location services are disabled.');
  //   }

  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       // Permissions are denied, next time you could try
  //       // requesting permissions again (this is also where
  //       // Android's shouldShowRequestPermissionRationale
  //       // returned true. According to Android guidelines
  //       // your App should show an explanatory UI now.
  //       return Future.error('Location permissions are denied');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     // Permissions are denied forever, handle appropriately.
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }

  //   // await Geolocator.checkPermission();
  //   await Geolocator.requestPermission();

  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   print(position.latitude + position.longitude);

  //   setState(() {
  //     latitude = position.latitude.toDouble();
  //     longitude = position.longitude.toDouble();
  //     locationDetected = true;
  //   });
  // }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add New Category",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 56, 193, 113),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Crop Data",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: crop_data,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 3.0,
                      ),
                    ),
                    // border: OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(25),
                    // ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // Text(
                //   "Location",
                //   style: TextStyle(
                //       fontSize: 22, fontWeight: FontWeight.w500),
                // ),
                // SizedBox(
                //   height: 10,
                // ),
                // Container(
                //   height: 200,
                //   child: OSMFlutter(
                //     mapIsLoading:
                //         Center(child: CircularProgressIndicator()),
                //     markerOption: MarkerOption(
                //       defaultMarker: MarkerIcon(
                //         assetMarker: AssetMarker(
                //             image: AssetImage("images/farmer.png"),
                //             scaleAssetImage: 5),
                //       ),
                //     ),
                //     userLocationMarker: UserLocationMaker(
                //       personMarker: MarkerIcon(
                //         assetMarker: AssetMarker(
                //             image: AssetImage("images/farmer.png"),
                //             scaleAssetImage: 5),
                //       ),
                //       directionArrowMarker: MarkerIcon(
                //         assetMarker: AssetMarker(
                //             image: AssetImage("images/farmer.png"),
                //             scaleAssetImage: 5),
                //       ),
                //     ),
                //     stepZoom: 20,
                //     minZoomLevel: 16,
                //     controller: controller,
                //     enableRotationByGesture: false,
                //     showZoomController: true,
                //   ),
                // ),
                Text(
                  "Crop Type",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: crop_type,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 3.0,
                      ),
                    ),
                    // border: OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(25),
                    // ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Description",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: description,
                  cursorColor: Colors.black,
                  maxLines: 5,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 3.0,
                      ),
                    ),

                    // border: OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(25),
                    // ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LocationMap(
                                crop_data: crop_data.text.toString(),
                                crop_type: crop_type.text.toString(),
                                description: description.text.toString())),
                      );
                    },
                    child: Text(
                      'Continue',
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
        ),
      ),
    );
  }
}
