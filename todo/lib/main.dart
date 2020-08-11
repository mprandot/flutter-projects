import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';

void main() {

  runApp(
    MaterialApp(
      title: "Todo APP",
      home: Home()
    )
  );
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List todos = [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListView(
        children: [
          Card(
            child: ListTile(
              leading: ,
            ),
          ),
        ],
      ),
    );
  }

  Future<File> _getFile () async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(todos);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch(e) {
      return null;
    }
  }

}

