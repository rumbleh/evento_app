import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final TextEditingController _nome = new TextEditingController();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _senha = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      ), Flexible(
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
                              child: Text("Cadastrar", style: TextStyle(color: Colors.white),),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SignupScreen()));
                              }))
                    ],
                  )),
            ),
          )),
    );
  }
}