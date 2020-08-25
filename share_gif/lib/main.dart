import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:share_gif/ui/home.dart';

Future main() async {
  await DotEnv().load('.env');

  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(hintColor: Colors.white),
  ));
}
