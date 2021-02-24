import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'menu.dart';

class EventScreen extends StatefulWidget {
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  List<dynamic> atividades = List();
  Map<String, String> atividade = {
    "palestrante": "Thiago",
    "titulo": "Conhecendo Flutter",
    "horario": "08:00"
  };

  DatabaseReference databaseReference;

  @override
  Widget build(BuildContext context) {
    atividades.add(atividade);

    return Scaffold(
      drawer: Menu(),
      appBar: AppBar(
        title: Text(
          "Nosso evento",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Scaffold(
        body: Column(
          children: [
            Flexible(
                flex: 0,
                child: Container(
                  width: 0.0,
                  height: 0.0,
                )),
            Flexible(
                flex: 1,
                child: atividades.isNotEmpty
                    ? _listagem(context)
                    : Container(
                        child: Center(
                            child: Text("Não há atividades cadastradas")),
                      ))
          ],
        ),
      ),
    );
  }

  Widget _listagem(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.black26,
                  radius: 25,
                  child: Text(
                    "P",
                    style: TextStyle(fontSize: 30.0, color: Colors.white),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${atividades[0]["titulo"]}",
                      style: TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 16.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 2.0, 2.0, 8.0),
                    child: Text("${atividades[0]["palestrante"]}"),
                  ),
                ],
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  "${atividades[0]["horario"]}",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16.0),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
