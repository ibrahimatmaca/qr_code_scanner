import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scan.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _title = "QR CODE SCAN";

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: BarcodeScan(title: _title),
      theme: ThemeData.dark(),
    );
  }
}
