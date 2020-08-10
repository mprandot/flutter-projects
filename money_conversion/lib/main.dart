import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  
  await DotEnv().load('.env');

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

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  

  void realChange(String text) {
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);   
    euroController.text = (real/euro).toStringAsFixed(2);
  }

  void dolarChange(String text) {
    double _dolar  = double.parse(text);
    realController.text = (_dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (_dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void euroChange(String text) {
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);   
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

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
                
                return SingleChildScrollView(
                  padding: EdgeInsets.all(20.0),
                  child: Column( 
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Icon(Icons.monetization_on, size: 150.0, color: Colors.amber),
                      ),
                      buildTextField("Reais", "R\$", realController, realChange),
                      Divider(),
                      buildTextField("Dólar", "US\$", dolarController, dolarChange),
                      Divider(),
                      buildTextField("Euro", "€", euroController, euroChange)
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

Widget buildTextField(String label, String prefix, TextEditingController _controller, Function onChange) {
  return TextField(
    keyboardType: TextInputType.number,
    controller: _controller,
    style: TextStyle(
      color: Colors.amber,
      fontSize: 25.0
    ),
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(),
      prefixText: prefix,
      labelStyle: TextStyle(
        color: Colors.amber
      )
    ),
    onChanged: onChange,
  );
}

Future<Map> getData() async {
  String apiKey = DotEnv().env['API_KEY'];
  String request = "https://api.hgbrasil.com/finance?format=json&key=$apiKey";
  http.Response response = await http.get(request);
  return json.decode(response.body);
}
