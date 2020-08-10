import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=e65cf9c8";

void main() async {
  runApp(MaterialApp(
      theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          hintStyle: TextStyle(color: Colors.amber),
        )),
      home: Home()));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  double dolar = 0.0;
  double euro = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Money conversion"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                  child: Text("Carregando dados...",
                      style: TextStyle(color: Colors.amber, fontSize: 25.0),
                      textAlign: TextAlign.center));
            default:
              if (snapshot.hasError) {
                return Center(
                    child: Text("Error...",
                      style: TextStyle(color: Colors.amber, fontSize: 25.0),
                      textAlign: TextAlign.center));
              } else {
                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                
                return 
                SingleChildScrollView(
                  padding: EdgeInsets.all(20.0),
                  child: Column( 
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(Icons.monetization_on, size: 150.0, color: Colors.amber),
                      TextField(
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 25.0
                        ),
                        decoration: InputDecoration(
                          labelText: "Reais",
                          border: OutlineInputBorder(),
                          prefixText: "R\$",
                          labelStyle: TextStyle(
                            color: Colors.amber
                          )
                        ),
                      ),

                      Divider(),
                      
                      TextField(
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 25.0
                        ),
                        decoration: InputDecoration(
                          labelText: "Dólar",
                          border: OutlineInputBorder(),
                          prefixText: "US\$",
                          labelStyle: TextStyle(
                            color: Colors.amber
                          )
                        ),
                      ),
                      
                      Divider(),

                      TextField(
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 25.0
                        ),
                        decoration: InputDecoration(
                          labelText: "Euro",
                          border: OutlineInputBorder(),
                          prefixText: "€",
                          labelStyle: TextStyle(
                            color: Colors.amber
                          )
                        ),
                      )
                    ]
                  )
                );
              }
          }
        },
      )
    );
  }
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}
