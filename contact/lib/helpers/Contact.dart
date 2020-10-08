import 'constants.dart';

class Contact {
  int id;
  String name;
  String email;
  String phone;
  String img;

  Contact.fromMap(Map data) {
    id = data[idColumn];
    name = data[nameColumn];
    email = data[emailColumn];
    phone = data[phoneColumn];
    img = data[imgColumn];
  }

  Map toMap() {
    Map<String, dynamic> data = {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img
    };

    if (id != null) {
      data[idColumn] = id;
    }

    return data;
  }

  @override
  String toString() {
    return "Contact(id: $id, name: $name, email: $email, phone: $phone, image: $img)";
  }
}
