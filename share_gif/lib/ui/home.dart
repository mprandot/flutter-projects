import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _search;
  int _offset = 0;
  Future<Map> _getGifs() async {
    http.Response response;

    String apikey = DotEnv().env['API_KEY'];

    print(apikey);
    if (_search == null) {
      response = await http.get(
          'https://api.giphy.com/v1/gifs/trending?api_key=$apikey&limit=25&rating=g');
    } else {
      response = await http.get(
          'https://api.giphy.com/v1/gifs/search?api_key=$apikey&q=$_search&limit=25&offset=$_offset&rating=g&lang=pt');
    }

    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();

    _getGifs().then((response) {
      print(response);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
