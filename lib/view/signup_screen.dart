import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:evento_app/controller/user_controller.dart';
import 'package:evento_app/model/user.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nome = new TextEditingController();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _senha = new TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: Text(
          "Cadastro de usuário",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Container(
          child: Form(
              key: formKey,
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
                      decoration: InputDecoration(hintText: "Nome"),
                      validator: (val) => val == "" ? val : null,
                      controller: _nome,
                      keyboardType: TextInputType.text,
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
                          child: Text(
                            "Cadastrar",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            _cadastraUsuario(globalKey);
                          }))
                ],
              )),
        ),
      )),
    );
  }

  void _cadastraUsuario(GlobalKey<ScaffoldState> globalKey) async {
    User user = User(_nome.text, _email.text, _convertToSha1(_senha.text));
    if (formKey.currentState.validate()) {
      ApiResponse response =
          await UserController().adicionarParticipante(user, formKey);
      if (response != null) {
        globalKey.currentState
            .showSnackBar(SnackBar(content: Text(response.msg)));
      } else {
        globalKey.currentState.showSnackBar(
            SnackBar(content: Text("Não foi possível cadastrar o usuário.")));
      }
    } else {
      globalKey.currentState.showSnackBar(
          SnackBar(content: Text("Preencha todos os campos em branco.")));
    }
  }

  String _convertToSha1(String text) {
    return sha1.convert(utf8.encode("eVeNtApP" + text)).toString();
  }
}
