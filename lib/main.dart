import 'package:document_scanner/Scanner/Scan_document.dart';
import 'package:flutter/material.dart';
import 'package:motion/motion.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Motion.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ScanDocumentScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
