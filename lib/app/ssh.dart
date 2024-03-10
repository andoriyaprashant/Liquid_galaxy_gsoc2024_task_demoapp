import 'dart:async';
import 'dart:io';

import 'package:dartssh2/dartssh2.dart';
import 'package:liquid_galaxy_demo_app/app/kml_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SSH {
  late String _host;
  late String _port;
  late String _username;
  late String _passwordOrKey;
  late String _numberOfRigs;
  SSHClient? _client;


  Future<void> initConnectionDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _host = prefs.getString('ipAddress') ?? 'default_host';
    _port = prefs.getString('sshPort') ?? '22';
    _username = prefs.getString('username') ?? 'lg';
    _passwordOrKey = prefs.getString('password') ?? 'lg';
    _numberOfRigs = prefs.getString('numberOfRigs') ?? '3';
  }

  Future<bool?> connectToLG() async {
    await initConnectionDetails();

    try {
    final socket = await SSHSocket.connect(_host, int.parse(_port));

   _client = SSHClient(
    socket,
    username: _username,
    onPasswordRequest: () => _passwordOrKey,
  );
  print('IP: $_host, port: $_port');

      return true;
    } on SocketException catch (e) {
      print('Failed to connect: $e');
      return false;
    }
  }

// Future<void> attemptSSHConnection() async {
//   try {
//     if (_client == null) {
//       print('SSH client is not initialized.');
//       return;
//     }

//     // Attempt to execute a dummy command to check SSH connection
//     final execResult = await _client!.execute('ls');

//     if (execResult.exitCode == 0) {
//       print('SSH connection established successfully.');
//     } else {
//       print('Failed to establish SSH connection.');
//     }
//   } catch (e) {
//     print('An error occurred while attempting to establish SSH connection: $e');
//   }
// }

  Future<SSHSession?> homecity() async {
    try {
      if (_client == null) {
        print('SSH client is not initialized.');
        return null;
      }

      final execResult = await _client!.execute('echo "search=jaipur" >/tmp/query.txt');
      print('executed');

      return execResult;
    } catch (e) {
      print('An error occurred while executing the command: $e');
      return null;
    }
  }


  
Future<void> relaunchLG() async {
  try {
    if (_client == null) {
      print('SSH client is not initialized.');
      return;
    }
    
    // Execute the command to relaunch LG for each screen
    for (int i = 1; i <= 3; i++) { // Assuming you have 3 LG screens
      final execResult = await _client!.execute("""
        relaunch="\\
        if [-f /etc/init/lxdm.conf ]; then 
        export SERVICE=lxdm
        elif [ -f /etc/init/lightdm.conf ]; then 
        export SERVICE=lightdm
        else 
        exit 1
        fi
        if [[ \\\$(service\\\$SERVICE status) =~ 'stop' ]]; then 
        echo $_passwordOrKey | sudo -S service \\\${SERVICE} start 
        else 
        echo $_passwordOrKey | sudo -S service \\\${SERVICE} restart
        fi
        ";
        sshpass -p $_passwordOrKey ssh -x -t lg@lg$i "\$relaunch\"
      """);

      // Check if the command executed successfully
      if (execResult.exitCode != null && execResult.exitCode == 0) {
        print('Relaunch command sent to LG$i');
      } else {
        if (execResult.exitCode == null) {
          print('Failed to send relaunch command to LG$i. Exit code: null');
        } else {
          print('Failed to send relaunch command to LG$i. Exit code: ${execResult.exitCode}');
        }
      }
    }
  } catch (e) {
    print('An error occurred while relaunching the Liquid Galaxy system: $e');
  }
}

// Future<void> createOrbit(String cityName) async {
//   try {
//     if (_client == null) {
//       print('SSH client is not initialized.');
//       return;
//     }

//     // Set the search query to the desired city
//     await _client!.execute('echo "search=jaipur" >/tmp/query.txt');

//     // Execute the orbit command
//     await _client!.execute('echo "orbit" >/tmp/query.txt');

//     print('Orbit created around jaipur');
//   } catch (e) {
//     print('An error occurred while executing the command: $e');
//   }
// }
Future<void> createOrbit(String cityName) async {
  try {
    if (_client == null) {
      print('SSH client is not initialized.');
      return;
    }

    // Set the search query to the desired city
    await _client!.execute('echo "search=$cityName" >/tmp/query.txt');

    // Wait for a short duration to ensure the search command is processed
    await Future.delayed(Duration(seconds: 2));

    // Execute the orbit command
    await _client!.execute('echo "start_orbit" >/tmp/query.txt');

    print('Orbit created around $cityName');
  } catch (e) {
    print('An error occurred while executing the command: $e');
  }
}


Future<void> rebootLG() async {
  try {
    print('Warning: Rebooting LG machines.');
    for (var i = 1; i <= int.parse(_numberOfRigs); i++) {
      await _client!.execute('sshpass -p $_passwordOrKey ssh -t lg$i "echo $_passwordOrKey | sudo -S reboot"');
    }
  } catch (error) {
     print('an error');
      return null;
  }
}

  Future<void> dispatchKml(String kmlContent) async {
    try {
      if (_client == null) {
        print('SSH client is not initialized.');
        return;
      }

      // Send the KML content to the Liquid Galaxy machine
      final execResult = await _client!.execute('''
        echo '$kmlContent' > /tmp/kml.kml
        /bin/bash /home/lg/bin/textt.sh --kml /tmp/kml.kml
      ''');

      print('KML query dispatched successfully.');
    } catch (e) {
      print('An error occurred while dispatching the KML query: $e');
    }
  }

  

  SSHClient? get client => _client;
// Future<void> printText(String text) async {
//   try {
//     if (_client == null) {
//       print('SSH client is not initialized.');
//       return;
//     }

//     // Escape special characters in the text
//     final escapedText = text.replaceAll(RegExp(r'(["\$])'), r'\\\$1');

//     final execResult = await _client!.execute('''
//       /bin/bash /home/lg/scripts/display_text.sh "$escapedText"
//     ''');

//     print('Text displayed successfully.');
//   } catch (e) {
//     print('An error occurred while displaying the text: $e');
//   }
// }

// Future<void> printHTMLBubble() async {
//   try {
//     if (_client == null) {
//       print('SSH client is not initialized.');
//       return;
//     }

//     // HTML content
//     final String htmlContent = '''
//       <div style="font-size: 36px;">
//         <p>Jaipur</p>
//         <p>Prashant</p>
//       </div>
//     ''';

//     // Write HTML content to a local file
//     final File htmlFile = File('/path/to/local/bubble.html');
//     await htmlFile.writeAsString(htmlContent);

//     // Copy HTML file to remote server
//     final execResult1 = await Process.run('scp', [
//       '/path/to/local/bubble.html',
//       'user@hostname:/path/to/remote/bubble.html',
//     ]);

//     if (execResult1.exitCode != 0) {
//       print('Failed to copy HTML file to remote server: ${execResult1.stderr}');
//       return;
//     }

//     // Execute command to display HTML bubble
//     final execResult2 = await _client!.execute('/bin/bash /home/lg/bin/lg-run-command.sh --html /path/to/remote/bubble.html --screen right');

//     print('HTML bubble printed successfully.');

//   } catch (e) {
//     print('An error occurred while printing the HTML bubble: $e');
//   }
// }

//   Future<void> transferFileToLG(String localFilePath, String remoteFilePath) async {
//     try {
//       if (_client == null) {
//         print('SSH client is not initialized.');
//         return;
//       }

//       // Open the local file for reading
//       final file = File(localFilePath);
//       final content = await file.readAsString();

//       // Write the content to a temporary file on the LG machine
//       final execResult = await _client!.execute('echo "$content" > $remoteFilePath');

//       print('File transferred successfully to $remoteFilePath');
//     } catch (e) {
//       print('An error occurred while transferring the file: $e');
//     }
//   }


    // // Execute the command to reboot LG
    // final execResult = await _client!.execute(command);
    
    // return execResult;
//   } catch (e) {
//     print('An error occurred while rebooting the Liquid Galaxy system: $e');
//     return null;
//   }
// }



  // Future<SSHSession?> rerebootLG() async {
  //   try {
  //     if (_client == null) {
  //       print('SSH client is not initialized.');
  //       return null;
  //     }
      
  //     // Execute the command to reboot LG
  //     final execResult = await _client!.execute("""reboot="\\
  //     if [-f /etc/init/lxdm.conf ]; then 
  //     export SERVICE=lxdm
  //     elif [ -f /etc/init/lightdm.conf ]; then 
  //     export SERVICE=lightdm
  //     else 
  //     exit 1
  //     fi
  //     if [[ \\\$(service\\\$SERVICE status) =~ 'stop' ]]; then 
  //     echo $_passwordOrKey | sudo -S service \\\${SERVICE} start 
  //     else 
  //       echo $_passwordOrKey | sudo -S service \\\${SERVICE} restart
  //       fi 
  //       "&& sshpass -p $_passwordOrKey ssh -x -t lg@lg1 "\$reboot\"""");
  //       return execResult;
  //   } catch (e) {
  //     print('an error ');
  //     return null;

  //   }  
  // }

//   Future<SSHSession?> relaunchLG() async {
//   try {
//     if (_client == null) {
//       print('SSH client is not initialized.');
//       return null;
//     }
    
//     // Execute the command to reboot LG
//     final execResult = await _client!.execute('sudo re');
    
//     return execResult;
//   } catch (e) {
//     print('An error occurred while rebooting the Liquid Galaxy system: $e');
//     return null;
//   }
// }

// Future<void> openBalloon(String custom, String date, String description, String source, String appname) async {
//   try {
//     // Fetch SSH credentials
//     Map<String, dynamic> credentials = await _getCredentials();

//     // Establish SSH connection
//     SSHClient client = SSHClient(
//       host: credentials['ip'],
//       port: int.parse(credentials['port']),
//       username: credentials['username'],
//       passwordOrKey: credentials['pass'],
//     );

//     // Calculate number of rigs
//     int rigs = (int.parse(credentials['numberofrigs']) / 2).floor() + 1;

//     // Generate KML content
//     String openBalloonKML = '''
//       <?xml version="1.0" encoding="UTF-8"?>
//       <kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
//       <Document>
//         <name>$custom.kml</name>
//         <!-- KML content here -->
//       </Document>
//       </kml>
//     ''';

//     // Connect to SSH and write KML content to file
//     await client.connect();
//     await client.execute("echo '$openBalloonKML' > /var/www/html/kml/slave_$rigs.kml");
//   } catch (e) {
//     print('An error occurred while opening the balloon: $e');
//     // Handle error
//   }
// }

}