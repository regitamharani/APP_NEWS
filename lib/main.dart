import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/news_provider.dart';
import 'views/home_view.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => NewsProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News App',
      home: const HomeView(),
    );
  }
}