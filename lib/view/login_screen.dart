import 'package:evento_app/view/event_screen.dart';
import 'package:evento_app/view/signup_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _senha = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Nosso evento",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Container(
          child: Form(
              child: Column(
            children: [
              Flexible(
                flex: 1,
                child: Image.asset(
                  "assets/images/logo.png",
                  width: 150.0,
                  height: 150.0,
                ),
              ),
              Flexible(
                child: TextFormField(
                  maxLength: 100,
                  decoration: InputDecoration(hintText: "E-mail"),
                  validator: (val) => val == "" ? val : null,
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              Flexible(
                child: TextFormField(
                  maxLength: 20,
                  obscureText: true,
                  decoration: InputDecoration(hintText: "Senha"),
                  validator: (val) => val == "" ? val : null,
                  controller: _senha,
                  keyboardType: TextInputType.text,
                ),
              ),
              Flexible(
                  child: FlatButton(
                color: Colors.deepPurple,
                onPressed: (){
                  _login(context);
                },
                child: Text(
                  "Entrar",
                  style: TextStyle(color: Colors.white),
                ),
              )),
              Flexible(
                  child: FlatButton(
                      child: Text("Cadastrar"),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => SignupScreen()));
                      }))
            ],
          )),
        ),
      )),
    );
  }

  void _login(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => EventScreen()));
  }
}
