import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:screen_shot/pages/home_page.dart';
import 'package:screen_shot/utils/servies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //off the screen shot and recording

  UseFullFunctions useFullFunctions = UseFullFunctions();

  await useFullFunctions.disableScreenshot();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
