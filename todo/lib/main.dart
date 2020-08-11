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
  Map<String, dynamic> lastRemoved;
  int lastRemovedIndex;

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
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                  padding: EdgeInsets.only(top: 10.0),
                  itemCount: todos.length,
                  itemBuilder: buildItem
              ),
            ),
          )
        ],
      ),
    );
  }


  Future<Null> _refresh () async {

    await Future.delayed(Duration(seconds: 1));

    setState(() {
      todos.sort((current, next){
        if(current["ok"] && !next["ok"]) {
          return 1;
        } else if(!current["ok"] && next["ok"]) {
          return -1;
        } else return 0;
      });
      _saveData();
    });

  }

  Widget buildItem (BuildContext context, int index) {
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
      ),
      onDismissed: (direction) {
        setState(() {
          lastRemoved = Map.from(todos[index]);
          lastRemovedIndex = index;
          todos.removeAt(index);
          _saveData();
          final snack = SnackBar(
            duration: Duration(seconds: 3),
            content: Text("Success! Item removed"),
            action: SnackBarAction(
              label: "Cancel",
              onPressed: () {
                setState(() {
                  todos.insert(lastRemovedIndex, lastRemoved);
                  _saveData();
                });
              },
            ),
          );

          Scaffold.of(context).removeCurrentSnackBar();
          Scaffold.of(context).showSnackBar(snack);

        });
      },
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

