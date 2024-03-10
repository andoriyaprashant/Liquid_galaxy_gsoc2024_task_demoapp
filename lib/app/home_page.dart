import 'package:flutter/material.dart';
import 'package:liquid_galaxy_demo_app/app/card.dart';
import 'package:liquid_galaxy_demo_app/app/connection.dart';
import 'package:liquid_galaxy_demo_app/app/ssh.dart';
import 'package:liquid_galaxy_demo_app/app/kml_helper.dart';

bool connectionStatus = false;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required SSH ssh});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late SSH ssh;

  @override
  void initState() {
    super.initState();
    ssh = SSH();
    _connectToLG();
  }

  Future<void> _connectToLG() async {
    bool? result = await ssh.connectToLG();
    setState(() {
      connectionStatus = result!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LG Connection'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              await Navigator.pushNamed(context, '/settings');
              _connectToLG();
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10),
            child: ConnectionFlag(
              status: connectionStatus,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              width: 200, // Adjust the width as needed
              height: 200, // Adjust the height as needed
              child: Image.asset('assets/logo.png'), // Adjust the path accordingly
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: 
                  Container(
                    height: 100,
                    child: ReusableCard(
                      colour: Colors.blue,
                      onPress: () async {
                        await ssh.relaunchLG();
                      },
                      cardChild: const Center(
                        child: Text(
                          'Relaunch Lg',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 100,
                    child: ReusableCard(
                      colour: Colors.blue,
                      onPress: () async {
                        await ssh.rebootLG();
                      },
                      cardChild: const Center(
                        child: Text(
                          'Reboot LG',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Add the button to create an orbit around Jaipur
          //           Expanded(
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: 
          //         Container(
          //           height: 100,
          //           child: ReusableCard(
          //             colour: Colors.blue,
          //             onPress: () async {
          //               ssh.printImage('/home/lg/Pictures/image.png');
          //             },
          //             cardChild: const Center(
          //               child: Text(
          //                 'print html',
          //                 style: TextStyle(
          //                   color: Colors.white,
          //                   fontSize: 40,
          //                   fontWeight: FontWeight.w700,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
Expanded(
  child: Row(
    children: [
      Expanded(
        child: GestureDetector(
          onTap: () async {
            if (ssh.client != null) {
              try {
                await ssh.dispatchKml(
                  KmlHelper.screenOverlayImage(
                    "https://imgur.com/a/ORdfkHy",
                    9 / 16,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to dispatch KML query'),
                  ),
                );
              }
            }
          },
          child: Container(
            height: 100,
            color: Colors.blue,
            child: Center(
              child: Text(
                'Print bubble',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  ),
),


          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 100,
                    child: ReusableCard(
                      colour: Colors.blue,
                      onPress: () async {
                        await ssh.createOrbit("Vit bhopal");
                      },
                      cardChild: const Center(
                        child: Text(
                          'Create Orbit around Vit Bhopal',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Add another Expanded widget for the next Row
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 100,
                    child: ReusableCard(
                      colour: Colors.blue,
                      onPress: () async {
                        await ssh.homecity();
                      },
                      cardChild: const Center(
                        child: Text(
                          'SEARCH = Jaipur',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
