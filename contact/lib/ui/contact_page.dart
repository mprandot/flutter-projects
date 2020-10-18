import 'dart:io';

import 'package:contact/helpers/Contact.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {

  final Contact contact;
  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Contact _editedContact;
  bool formChanged = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    if(widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());
      _nameController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(_editedContact.name ?? 'New contact'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          if(_editedContact.name != null && _editedContact.name.isNotEmpty) {
            return Navigator.pop(context, _editedContact);
          }
          FocusScope.of(context).requestFocus(_nameFocus);
        },
        child: Icon(Icons.save),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            GestureDetector(
              child: Container(
                width: 140.0,
                height: 140.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: _editedContact.img != null ?
                        FileImage(File(_editedContact.img)) :
                        AssetImage("images/default.jpg")
                    )
                ),
              ),
            ),
            TextField(
              decoration: InputDecoration(labelText: "Name"),
              focusNode: _nameFocus,
              controller: _nameController,
              onChanged: (text) {
                formChanged = true;
                setState(() {
                  _editedContact.name = text;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: "Email"),
              controller: _emailController,
              onChanged: (text) {
                formChanged = true;
                _editedContact.email = text;
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: "Phone"),
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              onChanged: (text) {
                formChanged = true;
                _editedContact.phone = text;
              },
            )
          ],
        ),

      )
    );
  }

}
