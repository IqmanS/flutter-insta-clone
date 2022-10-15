import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project_alpha/responsives/mobile_screen_layout.dart';
import 'package:project_alpha/responsives/responsive_layout_screen.dart';
import 'package:project_alpha/responsives/web_screen_layout.dart';
import 'package:project_alpha/screens/login_screen.dart';
import 'package:project_alpha/screens/signup_screen.dart';
import 'package:project_alpha/utils/colors.dart';
import 'package:project_alpha/utils/dimensions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAOq_ofaDDBbUre4NxhrInvu209yRpwmoY",
        appId: "1:82224879857:web:af2a2cc5ec45ebc29b3150",
        messagingSenderId: "82224879857",
        projectId: "instagram-clone-4d5ef",
        storageBucket: "instagram-clone-4d5ef.appspot.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram Clone',
      debugShowCheckedModeBanner: false,
      // home: ResponsiveLayout(
      //   mobileScreenLayout: MobileScreenLayout(),
      //   webScreenLayout: WebScreenLayout(),
      // ),
      home: SignUpScreen(),
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),
    );
  }
}
