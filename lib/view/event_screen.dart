import 'package:evento_app/controller/activity_controller.dart';
import 'package:evento_app/model/activity.dart';
import 'package:evento_app/model/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'menu.dart';

class EventScreen extends StatefulWidget {
  final User usuario;

  EventScreen({Key key, @required this.usuario}) : super(key: key);

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {

  List<dynamic> atividades = List();
  DatabaseReference databaseReference;

  @override
  void initState() {
    super.initState();
    databaseReference = ActivityController().getAllActivities("activity");
    databaseReference.onChildAdded.listen(_verificaNovaAtividade);
    databaseReference.onChildChanged.listen(_verificaAtividadeAtualizada);
  }

  void _verificaNovaAtividade(Event event) {
    setState(() {
      Activity atividade = Activity.fromSnapshot(event.snapshot);
      atividade.setKey(event.snapshot.key);
      atividades.add(atividade);
    });
  }

  void _verificaAtividadeAtualizada(Event event) {
    setState(() {
      Activity atividade = Activity.fromSnapshot(event.snapshot);
      int index =
          atividades.indexWhere((element) => element.key == atividade.key);
      atividades[index] = atividade;
    });
  }

  @override
  Widget build(BuildContext context) {
    User usuario = widget.usuario;

    return Scaffold(
      drawer: Menu(usuario: usuario),
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
    return FirebaseAnimatedList(
        query: databaseReference,
        itemBuilder:
            (_, DataSnapshot snapshot, Animation<double> animation, int index) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: atividades[index].confirmed
                        ? Colors.deepPurple
                        : Colors.black26,
                    radius: 25,
                    child: Text(
                      atividades[index].title.substring(0, 1),
                      style: TextStyle(fontSize: 30.0, color: Colors.white),
                    ),
                  ),
                  title: Text(atividades[index].title,
                      style: TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 16.0)),
                  subtitle: Text(atividades[index].speaker +
                      "\n" +
                      atividades[index].schedule),
                  trailing: atividades[index].confirmed
                      ? Icon(Icons.check)
                      : Icon(Icons.maximize)),
            ),
          );
        });
  }
}
