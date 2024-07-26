import 'package:flutter/material.dart';

class ByAlphabet extends StatefulWidget {
  @override
  _ByAlphabetState createState() => _ByAlphabetState();
}

class _ByAlphabetState extends State<ByAlphabet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("By Alphabet"),
      ),
      body: Center(
        child: Column(
          children: [
            Text("Search by"),
            Text("Alphabet"),
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.blue,
                  width: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}