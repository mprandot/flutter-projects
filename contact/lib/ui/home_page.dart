import 'dart:io';
import 'package:contact/helpers/Contact.dart';
import 'package:contact/helpers/contact_dao.dart';
import 'package:contact/ui/contact_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  ContactDAO database = ContactDAO(); 
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    _getAllContacts();
  }

  _getAllContacts() {
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
        onPressed: (){
          _showContactPage();
        },
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
      onTap: () {
        _showContactPage(contact: contact);
      },
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

  void _showContactPage ({Contact contact}) async {
    final newContact = await Navigator.push(context,
      MaterialPageRoute(builder: (context) => ContactPage(contact: contact))
    );

    if(newContact != null ) {
      if(contact != null) {
        await database.updateContact(newContact);
      } else {
        await database.saveContact(newContact);
      }
      _getAllContacts();
    }
  }
}