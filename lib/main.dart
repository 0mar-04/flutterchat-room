import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutterproject/auth_provider.dart';
import 'chat.dart';
import 'signup_page.dart';
import 'viewInfo.dart';
import 'SignIn.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'auth_selection_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ChangeNotifierProvider(
    create: (context) => AuthProvider(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => AuthSelectionPage(), // Start with the Auth Selection Page
        '/signup': (context) => SignUpPage(),
        '/view': (context) => EmployeeListPage(),

        // Modify the '/chat' route to pass both darkMode and textSize
        '/chat': (context) {
          bool darkMode = false;  // Example: Default darkMode set to false
          double textSize = 16.0;  // Example: Default textSize set to 16.0

          return ChatPage(
            darkMode: darkMode,
            textSize: textSize,
          );
        },
      },
      title: "My App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
