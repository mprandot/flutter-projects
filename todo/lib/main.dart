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

  final inputController = TextEditingController();

  void addTodo () {
    setState(() {
      Map<String, dynamic> newTodo = Map();
      newTodo["title"] = inputController.text;
      newTodo["ok"] = false;
      inputController.text = "";
      todos.add(newTodo);
    });
  }

  @override
  void initState() {
    super.initState();
    _readData().then((value) {
     setState(() {
       todos = json.decode(value);
     });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TODO"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: [

                Expanded(
                  child: TextField(
                    controller: inputController,
                    decoration: InputDecoration(
                        labelText: "Insert todo",
                        labelStyle: TextStyle(color: Colors.blueAccent)
                    ),
                  ),
                ),

                RaisedButton(
                  color: Colors.blueAccent,
                  child: Text("ADD"),
                  textColor: Colors.white,
                  onPressed: addTodo,
                )
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 10.0),
              itemCount: todos.length,
              itemBuilder: buildItem
            ),
          )
        ],
      ),
    );
  }

  Widget buildItem (context, index) {
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.redAccent,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(Icons.delete, color: Colors.white),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(todos[index]["title"]),
        value: todos[index]["ok"],
        secondary: CircleAvatar(
          child: Icon(todos[index]["ok"] ? Icons.check : Icons.error),
        ),
        onChanged: (checked) {
          setState(() {
            todos[index]["ok"] = checked;
            _saveData();
          });
        },
      )
    );
  }

  Future<File> _getFile () async {
    final directory = await getApplicationDocumentsDirectory();
    print(directory);
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

