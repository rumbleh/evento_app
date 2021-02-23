import 'package:evento_app/view/event_screen.dart';
import 'package:flutter/material.dart';
import 'activity_screen.dart';
import 'login_screen.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Drawer(
            child: ListView(
      children: [
        _header("Thiago de Queiroz", "rumbleh@gmail.com"),
        ListTile(
          leading: Icon(Icons.today),
          title: Text("Agenda"),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => EventScreen()));
          },
        ),
        ListTile(
          leading: Icon(Icons.today),
          title: Text("Atividades"),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => ActivityScreen()));
          },
        ),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text("Sair"),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen()));
          },
        ),
      ],
    )));
  }

  _header(String nome, email) {
    return UserAccountsDrawerHeader(
        currentAccountPicture: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 80,
          child: Text(
            "T",
            style: TextStyle(fontSize: 40.0, color: Colors.black54),
          ),
        ),
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment(-1, -1), colors: [
          Colors.blue,
          Colors.deepPurple,
        ])),
        accountName: Text(nome),
        accountEmail: Text(email));
  }
}
