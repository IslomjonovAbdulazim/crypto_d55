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
  var stream = WebSocketChannel.connect(
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
    current = currencies.first;
    load();
    super.initState();
  }

  void change(String crypto) {
    stream.sink.close();
    current = crypto;
    final uri = Uri.parse("wss://stream.binance.com:9443/ws/$current@trade");
    stream = WebSocketChannel.connect(uri);
    load();
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
            DropdownButton<String>(
              value: current,
              onChanged: (value) {
                change(value!);
              },
              items: currencies
                  .map(
                    (value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  )
                  .toList(),
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
