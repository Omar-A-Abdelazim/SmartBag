import 'package:flutter/material.dart';
import 'dart:ui'; // لاستخدام ImageFilter.blur
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // استيراد مكتبة FontAwesome

class SettingsPage extends StatefulWidget {
  final Function(bool) toggleTheme; // دالة لتغيير الثيم

  SettingsPage({required this.toggleTheme});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false; // متغير محلي لتتبع حالة الثيم

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // تحديد حالة الثيم بناءً على الـ Theme الحالي
    _isDarkMode = Theme.of(context).brightness == Brightness.dark;
  }

  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
    });
    widget.toggleTheme(value); // استدعاء الدالة الممررة من MyApp
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // رجوع لصفحة التحكم
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Solo Reader',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20),
              Stack(
                children: [
                  ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: Container(
                        width: double.infinity,
                        height: 100,
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 0.5,
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ),
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Upgrade to Premium',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Enjoy an Ad-Free Experience',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  overflow: TextOverflow.ellipsis,
                                ),
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: FaIcon(
                            FontAwesomeIcons.crown,
                            size: 30,
                            color: Colors.yellow[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.star_border),
                      title: Text('Rate Us'),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {},
                    ),
                    Divider(height: 0),
                    ListTile(
                      leading: Icon(Icons.share),
                      title: Text('Share with Friends'),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {},
                    ),
                    Divider(height: 0),
                    ListTile(
                      leading: Icon(Icons.apps),
                      title: Text('More Apps'),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {},
                    ),
                    Divider(height: 0),
                    ListTile(
                      leading: Icon(Icons.brightness_2),
                      title: Text('Dark Mode'),
                      trailing: Switch(
                        value: _isDarkMode,
                        onChanged: _toggleDarkMode,
                      ),
                      onTap: () {
                        _toggleDarkMode(!_isDarkMode);
                      },
                    ),
                    Divider(height: 0),
                    ListTile(
                      leading: Icon(Icons.language),
                      title: Text('Language'),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {},
                    ),
                    Divider(height: 0),
                    ListTile(
                      leading: Icon(Icons.shield),
                      title: Text('Privacy Policy'),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {},
                    ),
                    Divider(height: 0),
                    ListTile(
                      leading: Icon(Icons.description),
                      title: Text('Terms of Services'),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {},
                    ),
                    Divider(height: 0),
                    ListTile(
                      leading: Icon(Icons.info_outline),
                      title: Text('About App'),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Restore Purchase',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
