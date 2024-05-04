
import 'package:flutter/material.dart';
import 'package:oyunn/controller/helper.dart';

import 'package:oyunn/views/FalLoadingPage.dart';



import 'package:oyunn/views/auth/LoginPage.dart';
import 'package:firebase_core/firebase_core.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  runApp(const MyApp());
}



class MyApp extends StatefulWidget {
  const MyApp({Key? key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    getuserLoggedInStatus();
  
  }

  getuserLoggedInStatus() async {
    await HelperFunctions.getuserLoggIdstate().then(
      (value) {
        if (value != null) {
          setState(() {
            _isSignedIn = value;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

    
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          primarySwatch: Colors.blue,
        ),
        home:  _isSignedIn ? const FalYuklemeEkrani() : const LoginPage()
        

       
        );
  }
}
