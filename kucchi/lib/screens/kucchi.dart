import 'package:flutter/material.dart';
import 'package:kucchi/screens/insert.dart';

class Kucchi extends StatefulWidget {
  const Kucchi({super.key});

  @override
  State<Kucchi> createState() => _KucchiState();
}

class _KucchiState extends State<Kucchi> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text("hello Welcome"),
          
        ],
      ),
    );
  }
}