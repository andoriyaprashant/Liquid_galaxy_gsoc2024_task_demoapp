// import 'dart:async';
// import 'dart:io';
// import 'package:ssh2/ssh2.dart';

// Future<void> printHTMLBubble() async {
//   final client = SSHClient(
//     host: 'hostname:22',
//     username: 'username',
//     passwordOrKey: 'password',
    
//   );

//   try {
//     await client.connect();
    
//     // HTML content
//     final content = '''
//       <div style="font-size: 36px;">
//         <p>Jaipur</p>
//         <p>Prashant</p>
//       </div>
//     ''';

//     // Execute commands remotely to create HTML file and write content
//     await client.execute('echo "$content" > /path/to/remote/bubble.html');

//     // Execute command to display HTML bubble
//     final execResult = await client.execute(
//       '/bin/bash /home/lg/bin/lg-run-command.sh --html /path/to/remote/bubble.html --screen right',
//     );

//     print('HTML bubble printed successfully.');
//   } catch (e) {
//     print('An error occurred while printing the HTML bubble: $e');
//   } finally {
//     await client.disconnect();
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter/services.dart' show rootBundle;

// class HtmlBubbleScreen extends StatefulWidget {
//   @override
//   _HtmlBubbleScreenState createState() => _HtmlBubbleScreenState();
// }

// class _HtmlBubbleScreenState extends State<HtmlBubbleScreen> {
//   late GoogleMapController mapController;
//   late String kmlData;
//   bool isConnected = false; // Track connection status

//   @override
//   void initState() {
//     super.initState();
//     // Simulate connecting to LG machines
//     simulateConnectingToLG();
//   }

//   // Simulate connecting to LG machines
//   Future<void> simulateConnectingToLG() async {
//     // Simulate connection delay
//     await Future.delayed(Duration(seconds: 2));
//     setState(() {
//       isConnected = true; // Set connection status to true
//     });
//     loadKmlData();
//   }

//   Future<void> loadKmlData() async {
//     final String data = await rootBundle.loadString('assets/html_bubble_right_screen.kml');
//     setState(() {
//       kmlData = data;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('HTML Bubble'),
//       ),
//       body: isConnected
//           ? GoogleMap(
//               onMapCreated: (controller) {
//                 mapController = controller;
//               },
//               initialCameraPosition: CameraPosition(
//                 target: LatLng(0, 0), // Set initial position to (0,0)
//                 zoom: 2,
//               ),
//               markers: Set<Marker>.of(
//                 [
//                   Marker(
//                     markerId: MarkerId('html_bubble_marker'),
//                     position: LatLng(0, 0), // Set marker position
//                     infoWindow: InfoWindow(
//                       snippet: kmlData, // Use KML data as snippet
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           : Center(
//               child: CircularProgressIndicator(), // Show loading indicator while connecting
//             ),
//     );
//   }
// }
