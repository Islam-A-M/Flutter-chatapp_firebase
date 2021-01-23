import 'package:firebase_core/firebase_core.dart';

import './screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import './screens/auth_screen.dart';

import './screens/chat_screen.dart';
import 'package:flutter/material.dart';

import 'helpers/cache_userData_InMemory.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();

    return MaterialApp(
        title: 'Flutter Chat',
        theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blueGrey,
            backgroundColor: Colors.blueAccent,
            accentColor: Colors.cyan,
            accentColorBrightness: Brightness.dark,
            buttonTheme: ButtonTheme.of(context).copyWith(
              buttonColor: Colors.blueAccent,
              textTheme: ButtonTextTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            )),
        home: FutureBuilder(
          // Initialize FlutterFire:
          future: _initialization,
          builder: (context, snapshot) {
            // Check for errors
            if (snapshot.hasError) {
              return Container(
                child: Text('Something wont wrong'),
              );
            }

            // Once complete, show your application
            if (snapshot.connectionState == ConnectionState.done) {
              return ChangeNotifierProvider(
                  create: (ctx) => CasheduserData(),
                  child: StreamBuilder(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (ctx, asyncSnapshot) {
                      if (asyncSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        print('waiting');
                        return SplashScreen();
                      }

                      if (asyncSnapshot.hasData) {
                        print('Has Data');
                        return ChatScreen();
                      }
                      print('AuthScreen-------');
                      return AuthScreen();
                    },
                  ));
            }

            // Otherwise, show something whilst waiting for initialization to complete
            return SplashScreen();
          },
        ));
    //
  }
}
