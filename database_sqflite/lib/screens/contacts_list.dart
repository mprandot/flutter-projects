import 'package:bytebank/database/dao/contact_dao.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/screens/contact_form.dart';
import 'package:flutter/material.dart';

class ContactsList extends StatefulWidget {
  @override
  _ContactsListState createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  final ContactDao _dao = ContactDao();


  @override
  Widget build(BuildContext context) {

    Function updateParent = () {
      setState(() {});
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: FutureBuilder<List<Contact>>(
        initialData: List(),
        future: _dao.findAll(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Text('Loading')
                  ],
                ),
              );
              break;
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              final List<Contact> contacts = snapshot.data;
              return ListView.builder(
                itemBuilder: (context, index) {
                  return _GenerateListItem(contacts[index], updateParent);
                },
                itemCount: contacts.length,
              );
              break;
          }
          return Text('Unknown error');
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (context) => ContactForm(contact: null),
                ),
              )
              .then(
                (value) => setState(() {}),
              );
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}

class _GenerateListItem extends StatelessWidget {
  final Contact contact;
  final Function updateParent;

  _GenerateListItem(this.contact, this.updateParent);

  @override
  Widget build(BuildContext context) {
    return 
    GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ContactForm(contact: contact)),
        ).then((value) => updateParent());
      },
      child: Card(
        child: ListTile(
          title: Text(
            contact.name,
            style: TextStyle(
              fontSize: 24.0,
            ),
          ),
          subtitle: Text(
            contact.accountNumber.toString(),
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }
}
