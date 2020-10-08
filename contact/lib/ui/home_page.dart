import 'package:contact/helpers/Contact.dart';
import 'package:contact/helpers/contact_dao.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  ContactDAO database = ContactDAO(); 


  @override
  void initState() {
    super.initState();
    // Contact c = Contact();

    // c.name = "marcio 2";
    // c.email = "mprandot@gmail.com";
    // c.phone = "987987";
    // c.img = "img/test.png";

    // database.saveContact(c);

    // database.getAllContacts().then((List data) {
    //   print(data);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}