import 'package:firebase_database/firebase_database.dart';

class User {
  String key;
  String name;
  String email;
  String password;

  User(this.name, this.email, this.password);

  User.fromSnapshot(DataSnapshot snapshot) :
      key = snapshot.key,
      name = snapshot.value['name'],
      email = snapshot.value['email'],
      password = snapshot.value['password'];

  toJson(){
    return {
      "name": name,
      "email": email,
      "password": password
    };
  }

  User.fromJson(Map<String, dynamic> json){
    print(json);
    name = json['name'];
    email = json['email'];
    password = json['password'];
  }
}