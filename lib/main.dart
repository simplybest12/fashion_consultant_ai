import 'package:ai_fashion_consultant/src/presentation/view/home.dart';
import 'package:ai_fashion_consultant/src/utils/api_keys.dart';
import 'package:ai_fashion_consultant/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

void main() {
  Gemini.init(apiKey: ApiKeys.gemini_api_key);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColor.platinumWhite),
          useMaterial3: true,
        ),
        home: HomeScreen());
  }
}
