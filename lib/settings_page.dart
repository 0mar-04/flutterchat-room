import 'package:flutter/material.dart';
import 'chat.dart';

class SettingsPage extends StatefulWidget {
  final bool darkMode;

  SettingsPage({required this.darkMode});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool _darkMode;
  double _textSize = 16.0; // Default text size

  @override
  void initState() {
    super.initState();
    _darkMode = widget.darkMode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(
            color: _darkMode ? Colors.black : Colors.white,
          ),
        ),
        backgroundColor: _darkMode ? Colors.white : Colors.indigo,
        elevation: 0,
      ),
      backgroundColor: _darkMode ? Colors.black : Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dark Mode Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Dark Mode',
                  style: TextStyle(fontSize: 22, color: _darkMode ? Colors.white : Colors.black),
                ),
                Switch(
                  value: _darkMode,
                  onChanged: (value) {
                    setState(() {
                      _darkMode = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),

            // Text Size Slider
            Text(
              'Text Size',
              style: TextStyle(fontSize: 22, color: _darkMode ? Colors.white : Colors.black),
            ),
            Slider(
              value: _textSize,
              min: 12.0,
              max: 30.0,
              divisions: 6,
              label: _textSize.round().toString(),
              onChanged: (value) {
                setState(() {
                  _textSize = value;
                });
              },
            ),
            SizedBox(height: 20),

            // Save Changes Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navigate back to the ChatPage with updated settings
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        darkMode: _darkMode,
                        textSize: _textSize,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _darkMode ? Colors.white : Colors.indigo, // Button color changes based on darkMode
                  foregroundColor: _darkMode ? Colors.black : Colors.white, // Text color for button changes based on darkMode
                ),
                child: Text(
                  'Save Changes',
                  style: TextStyle(
                    color: _darkMode ? Colors.black : Colors.white, // Button text color changes based on darkMode
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
