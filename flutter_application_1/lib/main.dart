import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/emergency.dart';
import 'package:flutter_application_1/loginscreen.dart';
import 'package:flutter_application_1/registerscreen.dart';
import 'package:flutter_application_1/showcontacts.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:audioplayers/audioplayers.dart'; // Import the audioplayers package

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/location': (context) => const LocationScreen(id: 0),
      },
    );
  }
}

class LocationScreen extends StatefulWidget {
  final int id; // The ID that will be passed to the LocationScreen.

  const LocationScreen({super.key, required this.id});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  double? _latitude;
  double? _longitude;
  String _status = "Press the button to fetch location";

  // AudioPlayer instance for playing siren sound
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Function to get the real location (latitude and longitude)
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _status = "Location services are disabled.";
      });
      return;
    }

    // Check if location permissions are granted
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _status = "Location permission denied";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _status = "Location permissions are permanently denied";
      });
      return;
    }

    // Fetch the current location
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _status = "Location fetched!";
      });

      // Send the location data to the backend (if required)
      if (_latitude != null && _longitude != null) {
        await _sendLocationToServer(_latitude!, _longitude!);
      } else {
        setState(() {
          _status = "Location is null";
        });
      }

      // Play police siren sound after fetching location and sending data
      _playSiren();
    } catch (e) {
      setState(() {
        _status = "Failed to get location: $e";
      });
    }
  }

  // Send the location data to the server
  Future<void> _sendLocationToServer(double latitude, double longitude) async {
    final String backendUrl = 'http://localhost:8080/${widget.id}/location'; // Replace with your backend URL

    Map<String, dynamic> locationData = {
      'latitude': latitude,
      'longitude': longitude,
    };

    try {
      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(locationData),
      );

      if (response.statusCode == 200) {
        setState(() {
          _status = "Location sent to backend!";
        });
      } else {
        setState(() {
          _status = "Failed to send location: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _status = "Error sending location: $e";
      });
    }
  }

  // Play the police siren sound
  void _playSiren() async {
    await _audioPlayer.play(AssetSource('police_siren.mp3'));
  }

  @override
  void dispose() {
    // Dispose the audio player when the widget is disposed
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Women Safety App"),
        backgroundColor: Colors.deepPurple, // AppBar Color
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.pinkAccent, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  // Image at the top below the heading
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      'https://media.assettype.com/TNIE%2Fimport%2Fuploads%2Fuser%2Fckeditor_images%2Farticle%2F2019%2F8%2F22%2FTelangana_has.jpg',
                      width: 350,
                      height: 400,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Location info
                  Text(
                    'Latitude: ${_latitude ?? 'Not fetched yet'}',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  Text(
                    'Longitude: ${_longitude ?? 'Not fetched yet'}',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 20),

                  // Status
                  AnimatedSwitcher(
                    duration: Duration(seconds: 1),
                    child: Text(
                      _status,
                      key: ValueKey<String>(_status),
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Fetch Location Button with Animation and Icon
                  ElevatedButton.icon(
                    onPressed: _getCurrentLocation,
                    icon: Icon(Icons.location_on),
                    label: Text('Fetch and Send Location'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.deepPurple,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Add Emergency Contacts Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEmergencyContactsScreen(
                            userId: widget.id,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Add Emergency Contacts'),
                  ),
                  const SizedBox(height: 20),

                  // Show Emergency Contacts Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShowEmergencyContactsScreen(
                            userId: widget.id,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Show Emergency Contacts'),
                  ),
                  const SizedBox(height: 20),

                  // Floating Action Button
                  FloatingActionButton(
                    onPressed: () {
                      // Trigger an important action here
                    },
                    backgroundColor: Colors.deepPurple,
                    child: Icon(Icons.add),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
