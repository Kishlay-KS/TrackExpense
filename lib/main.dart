import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:track_expenses/pdf_service/app.dart';
import 'package:track_expenses/screens/Loginpage.dart';
import 'package:track_expenses/screens/SignUp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:track_expenses/screens/addTransaction.dart';
import 'package:track_expenses/screens/home.dart';
import 'package:track_expenses/screens/statistics.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var auth = FirebaseAuth.instance;
  var isLogin = false;
  String? email = '';
  checkifLogin() async {
    auth.authStateChanges().listen((User? user) {
      if (user != null && mounted) {
        setState(() {
          email = user.email;
          isLogin = true;
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    print(auth);
    checkifLogin();
    super.initState();
  }

  Widget build(BuildContext context) {
    final scrollbarTheme = ScrollbarThemeData(
      thumbVisibility: MaterialStateProperty.all(true),
    );
    return MaterialApp(
      // theme: ThemeData.light().copyWith(scrollbarTheme: scrollbarTheme),
      // darkTheme: ThemeData.dark().copyWith(scrollbarTheme: scrollbarTheme),
      routes: {
        '/home': (context) => Home(),
        '/Login': (context) => LoginPage(),
        '/SignUp': (context) => SignUp(),
        '/addTransaction': (context) => AddTransaction(),
        '/statistics': (context) => PieChart(),
        '/pdfScreen': (context) => PdfScreen(),
      },
      debugShowCheckedModeBanner: false,
      home: isLogin ? Home() : const LoginPage(),
    );
  }
}
