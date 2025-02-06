import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kuri_application/Theme/theme_provider.dart';
import 'package:kuri_application/Views/AdminScreen/admin_dashboard.dart';
import 'package:kuri_application/Views/HomeScreen/homeScreen.dart';
import 'package:kuri_application/Views/UserScreen/user_dashboard.dart';
import 'package:kuri_application/Views/SplashScreen/splashScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kuri_application/Views/privacy&security/privacy&security.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  try {
    // await Firebase.initializeApp(
    //   options:  DefaultFirebaseOptions.currentPlatform, 
    // );
    runApp(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const MyApp(),
      ),
    );
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return GetMaterialApp(
      title: 'Kuri App',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.lightTheme,
      darkTheme: themeProvider.darkTheme,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen()
      // StreamBuilder<User?>(
      //   stream: FirebaseAuth.instance.authStateChanges(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Splashscreen();
      //     }

      //     if (!snapshot.hasData) {
      //       return const AdminDashboard();
      //     }

      //     return FutureBuilder<DocumentSnapshot>(
      //       future: FirebaseFirestore.instance
      //           .collection('users')
      //           .doc(snapshot.data!.uid)
      //           .get(),
      //       builder: (context, userSnapshot) {
      //         if (!userSnapshot.hasData) {
      //           return const Splashscreen();
      //         }

      //         final userData = userSnapshot.data!.data() as Map<String, dynamic>;
      //         final isAdmin = userData['isAdmin'] as bool? ?? false;

      //         return isAdmin ? const AdminDashboard() : const UserDashboard();
      //       },
      //     );
      //   },
      // ),
    );
  }
}
