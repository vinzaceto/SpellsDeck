import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'package:vote_app/services/authentication.dart';
import 'package:vote_app/root_page.dart';

void main() async {
  bool isInDebugMode = false;

  FlutterError.onError = (FlutterErrorDetails details) {
    if(isInDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  await FlutterCrashlytics().initialize();

  runZoned<Future<Null>>(() async {
    runApp(new MyApp());
  }, onError: (error, stackTrace) async {
    await FlutterCrashlytics().reportCrash(error, stackTrace, forceCrash: false);
  });

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Flutter login demo',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new RootPage(auth: new Auth()));
  }
}