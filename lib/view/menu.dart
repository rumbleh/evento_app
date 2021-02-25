import 'package:evento_app/controller/user_controller.dart';
import 'package:evento_app/model/user.dart';
import 'package:evento_app/view/event_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'activity_screen.dart';
import 'login_screen.dart';

class Menu extends StatelessWidget {
  final User usuario;

  Menu({Key key, this.usuario}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Drawer(
            child: ListView(
      children: [
        _header(usuario.name, usuario.email),
        ListTile(
          leading: Icon(Icons.today),
          title: Text("Agenda"),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => EventScreen(usuario: usuario)));
          },
        ),
        usuario.email == 'rumbleh@gmail.com' ?
        ListTile(
          leading: Icon(Icons.today),
          title: Text("Atividades"),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => ActivityScreen(usuario: usuario)));
          },
        ) : Spacer(),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text("Sair"),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            UserController().logout();
            Navigator.of(context).popUntil((route) => false);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen()));
          },
        ),
      ],
    )));
  }

  _header(String name, String email) {
    return UserAccountsDrawerHeader(
        currentAccountPicture: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 80,
          child: Text(
            name.substring(0,1).toUpperCase(),
            style: TextStyle(fontSize: 40.0, color: Colors.black54),
          ),
        ),
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment(-1, -1), colors: [
          Colors.deepPurpleAccent,
          Colors.deepPurple,
        ])),
        accountName: Text(name),
        accountEmail: Text(email));
  }
}
