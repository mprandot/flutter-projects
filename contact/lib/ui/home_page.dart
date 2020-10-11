import 'dart:io';
import 'package:contact/helpers/Contact.dart';
import 'package:contact/helpers/contact_dao.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  ContactDAO database = ContactDAO(); 
  List<Contact> contacts = List();

  @override
  void initState() {
    super.initState();
    database.getAllContacts()
    .then((list) => 
      setState(() {
        contacts = list;
      })
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts"),
        backgroundColor: Colors.red,
        centerTitle: true
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
        onPressed: (){},
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return _contactCard(context, index);
        },
      ),
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    
    Contact contact = contacts[index];

    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: contact.img != null ? 
                    FileImage(File(contact.img)) :
                    AssetImage("images/default.jpg")
                  )
                ),
              ),

              Padding(padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(contact.name ?? "", style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
                    Text(contact.email ?? "", style: TextStyle(fontSize: 18.0)),
                    Text(contact.phone ?? "", style: TextStyle(fontSize: 18.0)),
                  ])
              )        
            ],
          ),
        ),
      ),
    );
  }
}