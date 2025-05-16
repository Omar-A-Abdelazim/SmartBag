import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'settings_page.dart'; // استيراد ملف الـ Settings

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // إعدادات الإشعارات
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.requestNotificationsPermission();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false; // التحكم في الثيم داخل الـ State

  void toggleTheme(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Luggage',
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: SplashScreen(),
    );
  }
}

// صفحة Splash Screen
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/smart.png', width: 200, height: 200),
      ),
    );
  }
}

// صفحة Sign In
class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFFFA1D1), Color(0xFF6B2A73)],
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Hello',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Sign in to your account',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {},
                  child: Text('Forgot your password?'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ControlPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFA1D1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Sign In',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward, color: Colors.white),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Don't have an account? Create",
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(icon: Icon(Icons.facebook), onPressed: () {}),
                    IconButton(icon: Icon(Icons.email), onPressed: () {}),
                    IconButton(
                      icon: Icon(Icons.account_circle),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// صفحة التحكم (Switch Control)
class ControlPage extends StatefulWidget {
  @override
  _ControlPageState createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isAlertActive = false;
  String ipAddress = "192.168.243.34";
  String status = "Checking status...";
  bool notificationShown = false;

  @override
  void initState() {
    super.initState();
    checkStatusPeriodically();
  }

  Future<void> checkStatus() async {
    try {
      final response = await http.get(Uri.parse('http://$ipAddress/STATUS'));
      if (response.statusCode == 200) {
        setState(() {
          status = response.body;
          if (status.contains("ALERT: Light Detected!") ||
              status.contains("Alert Active!")) {
            if (!isAlertActive) {
              isAlertActive = true;
              if (!notificationShown) {
                showNotification();
                notificationShown = true;
              }
            }
          }
        });
      }
    } catch (e) {
      setState(() {
        status = "ESP32 not connected: $e";
      });
    }
  }

  Future<void> turnOffAlert() async {
    try {
      final response = await http.get(Uri.parse('http://$ipAddress/TURN_OFF'));
      if (response.statusCode == 200) {
        setState(() {
          isAlertActive = false;
          notificationShown = false;
          status = "Alert Turned Off";
        });
      } else {
        setState(() {
          status = "Failed to turn off alert: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        status = "ESP32 not connected: $e";
      });
    }
  }

  void checkStatusPeriodically() async {
    while (true) {
      await checkStatus();
      await Future.delayed(Duration(seconds: 2));
    }
  }

  Future<void> showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'theft_alert_channel',
          'Theft Alerts',
          channelDescription: 'Notifications for theft detection',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'Theft Alert',
          playSound: true,
          enableVibration: false, // شيلنا الاهتزاز
        );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      'Theft Alert!',
      'WARNING: Your bag is being opened! Open the app to stop the alarm.',
      platformChannelSpecifics,
    );
  }

  @override
  Widget build(BuildContext context) {
    final myAppState = context.findAncestorStateOfType<_MyAppState>();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Smart Luggage Control'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.grey[200]),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            SettingsPage(toggleTheme: myAppState!.toggleTheme),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.support),
              title: Text('Support'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Location'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {}, // زرار مش شغال، شكل فقط
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Alert Status',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Switch(
              value: isAlertActive,
              onChanged: (value) {
                if (!value) {
                  turnOffAlert();
                }
              },
            ),
            SizedBox(height: 20),
            Text('Status: $status', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

// CustomClipper لعمل الأمواج
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 100);
    var firstControlPoint = Offset(size.width / 4, 120);
    var firstEndPoint = Offset(size.width / 2, 100);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );
    var secondControlPoint = Offset(3 * size.width / 4, 80);
    var secondEndPoint = Offset(size.width, 100);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
