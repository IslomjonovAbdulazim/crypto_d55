import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String current = "btcusdt";
  final stream = WebSocketChannel.connect(
    Uri.parse("wss://stream.binance.com:9443/ws/btcusdt@trade"),
  );
  String price = "0";
  List<String> currencies = [
    'btcusdt',
    'ethusdt',
    'solusdt',
    'bnbusdt',
    'xrpusdt',
    'adausdt',
    'dogeusdt',
    'linkusdt',
    'ltcusdt',
    'dotusdt',
  ];

  @override
  void initState() {
    load();
    super.initState();
  }

  void load() {
    stream.stream.listen((value) {
      final res = jsonDecode(value);
      price = res['p'];
      setState(() {});
    });
  }

  @override
  void dispose() {
    stream.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "BTCUSDT",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              double.parse(price).toStringAsFixed(2),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
