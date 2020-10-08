import 'package:contact/helpers/Contact.dart';
import 'package:contact/helpers/constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'constants.dart';
import 'dart:async';

class ContactDAO {
  static final ContactDAO _instance = ContactDAO.internal();
  ContactDAO.internal();
  factory ContactDAO() => _instance;

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
    final path = join(databasesPath, "contacts.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $contactTable ($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $emailColumn TEXT, $phoneColumn TEXT, $imgColumn TEXT)");
    });
  }

  Future<Contact> saveContact(Contact contact) async {
    Database database = await db;
    contact.id = await database.insert(contactTable, contact.toMap());
    return contact;
  }

  Future<Contact> getContact(int id) async {
    Database database = await db;

    List<Map> data = await database.query(contactTable,
      columns: [idColumn, nameColumn, emailColumn, phoneColumn, imgColumn],
      where: "$idColumn = ?",
      whereArgs: [id]
    );

    if(data.length > 0) {
      return Contact.fromMap(data.first);
    }

    return null;
  }

  Future<int> deleteContact(int id) async {
    Database database = await db;
    return await database.delete(
      contactTable, 
      where: "$idColumn = ?",
      whereArgs: [id]
    );
  }

  Future<int> updateContact(contact) async {
    Database database = await db;
    return await database.update(contactTable, contact.toMap(), 
      where: "$idColumn = ?",
      whereArgs: [contact.id]
    );
  }

  Future<List> getAllContacts() async {
    Database database = await db;
    List<Map> data = await database.rawQuery("SELECT * FROM $contactTable");
    List<Contact> contacts = List();
    for(Map _contact in data) {
      contacts.add(Contact.fromMap(_contact));
    }
    return contacts;
  }


  Future close() async {
    Database database = await db;
    database.close();
  }

  // Return number of contacts
  // Future<int> getNumber() async {
  //   Database database = await db;
  //   return Sqflite.firstIntValue(await database.rawQuery("SELECT COUNT(id) FROM $contactTable"));
  // }

  void main() {
    print(imgColumn);
  }
}
