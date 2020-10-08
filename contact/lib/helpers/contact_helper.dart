import 'package:contact/helpers/Contact.dart';
import 'package:contact/helpers/constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'constants.dart';
import 'dart:async';

class ContactHelper {
  static final ContactHelper _instance = ContactHelper.internal();
  ContactHelper.internal();
  factory ContactHelper() => _instance;

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }

    _db = await initDb();

    return _db;
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "contact.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $contactTable ( $idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $emailColumn TEXT, $phoneColumn TEXT, $imgColumn TEXT)");
    });
  }

  void main() {
    print(imgColumn);
  }
}
