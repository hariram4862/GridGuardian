import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:intl/intl.dart'; // For formatting time
import 'package:connectivity_plus/connectivity_plus.dart'; // For checking internet connection
import 'package:fluttertoast/fluttertoast.dart'; // For showing toast messages

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grid Guardian',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  String _voltageA = '0';
  String _defectA = 'FALSE';
  String _voltageB = '0';
  String _defectB = 'FALSE';
  String _voltageC = '0';
  String _defectC = 'FALSE';
  String _lastUpdated = '';
  bool _isConnected = true; // Flag for internet connection status

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _loadSavedData(); // Load data from SharedPreferences first
    _retrieveData(); // Then try fetching from Firebase
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _isConnected = false;
      });
      Fluttertoast.showToast(
        msg: "No internet connection!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      setState(() {
        _isConnected = true;
      });
    }
  }

  Future<void> _loadSavedData() async {
    // Load stored values from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _voltageA = prefs.getString('voltageA') ?? '0';
      _defectA = prefs.getString('defectA') ?? 'FALSE';
      _voltageB = prefs.getString('voltageB') ?? '0';
      _defectB = prefs.getString('defectB') ?? 'FALSE';
      _voltageC = prefs.getString('voltageC') ?? '0';
      _defectC = prefs.getString('defectC') ?? 'FALSE';
      _lastUpdated = prefs.getString('lastUpdated') ?? 'Never';
    });
  }

  Future<void> _saveData(String voltageA, String defectA, String voltageB,
      String defectB, String voltageC, String defectC) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('voltageA', voltageA);
    await prefs.setString('defectA', defectA);
    await prefs.setString('voltageB', voltageB);
    await prefs.setString('defectB', defectB);
    await prefs.setString('voltageC', voltageC);
    await prefs.setString('defectC', defectC);

    String currentTime =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    await prefs.setString('lastUpdated', currentTime);

    setState(() {
      _lastUpdated = currentTime;
    });
  }

  Future<void> _retrieveData() async {
    await _checkConnectivity();
    if (!_isConnected) return; // Exit if no internet connection

    // Listening for changes in Firebase database
    _databaseRef.child('Pole A').onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        _voltageA = data['voltage'].toString();
        _defectA = data['defect'] == 'true' ? 'TRUE' : 'FALSE';
      });
      _saveData(_voltageA, _defectA, _voltageB, _defectB, _voltageC, _defectC);
    });

    _databaseRef.child('Pole B').onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        _voltageB = data['voltage'].toString();
        _defectB = data['defect'] == 'true' ? 'TRUE' : 'FALSE';
      });
      _saveData(_voltageA, _defectA, _voltageB, _defectB, _voltageC, _defectC);
    });

    _databaseRef.child('Pole C').onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        _voltageC = data['voltage'].toString();
        _defectC = data['defect'] == 'true' ? 'TRUE' : 'FALSE';
      });
      _saveData(_voltageA, _defectA, _voltageB, _defectB, _voltageC, _defectC);
    });
  }

  Future<void> _resolveDefect(String pole) async {
    await _databaseRef.child('$pole/defect').set('false');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$pole defect resolved')),
    );
  }

  Future<void> _refreshData() async {
    await _retrieveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grid Guardian Data'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData, // Trigger the refresh action
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Text('Last Updated: $_lastUpdated',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              _buildPoleData('Pole A', _voltageA, _defectA),
              _buildResolveButton('Pole A', _defectA),
              _buildPoleData('Pole B', _voltageB, _defectB),
              _buildResolveButton('Pole B', _defectB),
              _buildPoleData('Pole C', _voltageC, _defectC),
              _buildResolveButton('Pole C', _defectC),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPoleData(String pole, String voltage, String defect) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$pole Voltage: $voltage V',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              '$pole Defect Status: $defect',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResolveButton(String pole, String defect) {
    return Visibility(
      visible: defect == 'TRUE', // Show button only if there's a defect
      child: ElevatedButton(
        onPressed: () => _resolveDefect(pole),
        child: Text('Resoelv $pole Defect'),
      ),
    );
  }
}
