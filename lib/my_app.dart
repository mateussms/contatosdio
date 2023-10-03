import 'package:contatosdio/pages/my_home_page.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Contato DIO.me',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 2, 32, 56)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Contato DIO'),
    );
  }
}