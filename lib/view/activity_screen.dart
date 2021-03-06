import 'package:evento_app/controller/activity_controller.dart';
import 'package:evento_app/model/activity.dart';
import 'package:evento_app/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import 'menu.dart';

class ActivityScreen extends StatefulWidget {
  final User usuario;

  ActivityScreen({Key key, @required this.usuario}) : super(key: key);

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  bool _confirmada = false;
  final TextEditingController _palestra = TextEditingController();
  final TextEditingController _palestrante = TextEditingController();
  final TextEditingController _horario = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final globalKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormFieldState> formState = GlobalKey<FormFieldState>();

  List<Activity> atividades = List<Activity>();
  DatabaseReference databaseReference;
  FirebaseAuth _firebaseAuth;

  @override
  void initState() {
    print(_firebaseAuth);
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
      key: globalKey,
      appBar: AppBar(
        title: Text(
          "Atividades",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Flexible(
              child: Container(
            width: 0,
            height: 0,
          )),
          Flexible(
              child: atividades.isNotEmpty
                  ? listagem(context)
                  : Center(
                      child: Container(
                        child: Text("Não existem atividades cadastradas"),
                      ),
                    ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          _cadastrarAtividade();
        },
      ),
      drawer: Menu(usuario: usuario),
    );
  }

  Widget _alertaDelete(BuildContext context, Activity atividade) {
    return AlertDialog(
      actions: [
        FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Cancelar")),
        FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteAtividade(context, atividade.key);
            },
            child: Text("Excluir",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
      ],
      title: Text("Remover atividade"),
      content: Text("Você deseja remover a atividade \"${atividade.title}\"?"),
    );
  }

  Widget listagem(BuildContext context) {
    return FirebaseAnimatedList(
        query: databaseReference,
        itemBuilder:
            (_, DataSnapshot snapshot, Animation<double> animation, int index) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: ListTile(
                onLongPress: () {
                  _editarAtividade(context, atividades[index]);
                },
                leading: atividades[index].confirmed
                    ? Icon(Icons.check)
                    : Icon(Icons.maximize),
                title: Text(atividades[index].title),
                subtitle: Text(
                    "${atividades[index].speaker}\n${atividades[index].schedule}"),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return _alertaDelete(context, atividades[index]);
                        });
                  },
                ),
              ),
            ),
          );
        });
  }

  void _deleteAtividade(BuildContext context, String key) {
    try {
      ActivityController().deleteActivity('activity', key);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => ActivityScreen(usuario: widget.usuario,)));
    } catch (error) {
      print(error);
      globalKey.currentState.showSnackBar(
          SnackBar(content: Text("Não foi possível remover a atividade")));
    }
  }

  Widget _editarAtividade(BuildContext context, Activity atividade) {
    _palestra.text = atividade.title;
    _horario.text = atividade.schedule;
    _palestrante.text = atividade.speaker;
    _confirmada = atividade.confirmed;
    atividade.setKey(atividade.key);

    showDialog(
        context: context,
        builder: (BuildContext context) => Form(
              key: formKey,
              child: SimpleDialog(
                title: Text("Atividade"),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: TextFormField(
                      validator: (val) => val == "" ? val : null,
                      controller: _palestra,
                      decoration: InputDecoration(
                        hintText: "Título da palestra",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: TextFormField(
                      validator: (val) => val == "" ? val : null,
                      controller: _palestrante,
                      decoration: InputDecoration(
                        hintText: "Palestrante",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: TextFormField(
                      validator: (val) => val == "" ? val : null,
                      controller: _horario,
                      decoration: InputDecoration(
                        hintText: "Horário",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: FormField<bool>(
                        key: formState,
                        initialValue: _confirmada,
                        builder: (FormFieldState<bool> state) {
                          return CheckboxListTile(
                              value: state.value,
                              title: Text("Confirmada?"),
                              selected: _confirmada,
                              onChanged: state.didChange);
                        }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Cancelar")),
                      FlatButton(
                          onPressed: () {
                            _confirmada = formState.currentState.value;
                            _atualizarAtividade(
                                globalKey, context, _confirmada, atividade.key);
                          },
                          child: Text(
                            "OK",
                            style: TextStyle(color: Colors.deepPurple),
                          )),
                    ],
                  )
                ],
              ),
            ));
  }

  void _cadastrarAtividade() {
    showDialog(
        context: context,
        builder: (BuildContext context) => Form(
              key: formKey,
              child: SimpleDialog(
                title: Text("Atividade"),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: TextFormField(
                      validator: (val) => val == "" ? val : null,
                      controller: _palestra,
                      decoration: InputDecoration(
                        hintText: "Título da palestra",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: TextFormField(
                      validator: (val) => val == "" ? val : null,
                      controller: _palestrante,
                      decoration: InputDecoration(
                        hintText: "Palestrante",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: TextFormField(
                      validator: (val) => val == "" ? val : null,
                      controller: _horario,
                      decoration: InputDecoration(
                        hintText: "Horário",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: FormField<bool>(
                        key: formState,
                        initialValue: _confirmada,
                        builder: (FormFieldState<bool> state) {
                          return CheckboxListTile(
                              value: state.value,
                              title: Text("Confirmada?"),
                              selected: _confirmada,
                              onChanged: state.didChange);
                        }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Cancelar")),
                      FlatButton(
                          onPressed: () {
                            _confirmada = formState.currentState.value;
                            _cadastraAtividade(globalKey, context, _confirmada);
                          },
                          child: Text(
                            "OK",
                            style: TextStyle(color: Colors.deepPurple),
                          )),
                    ],
                  )
                ],
              ),
            ));
  }

  void _atualizarAtividade(GlobalKey<ScaffoldState> globalKey,
      BuildContext context, bool confirmada, String key) {
    try {
      if (formKey.currentState.validate()) {
        Activity activity = Activity(
            _palestra.text, _palestrante.text, _horario.text, _confirmada, key);
        ActivityController().updateActivity("activity", activity);
        globalKey.currentState.showSnackBar(
            SnackBar(content: Text("Atividade atualizada com sucesso")));
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => ActivityScreen(usuario: widget.usuario,)));
      } else {
        globalKey.currentState
            .showSnackBar(SnackBar(content: Text("Preencha todos os campos")));
      }
    } catch (error) {
      print(error);
      globalKey.currentState.showSnackBar(
          SnackBar(content: Text("Não foi possível atualizar a atividade.")));
    }
  }

  void _cadastraAtividade(GlobalKey<ScaffoldState> globalKey,
      BuildContext context, bool confirmada) {
    try {
      if (formKey.currentState.validate()) {
        Activity activity = Activity(
            _palestra.text, _palestrante.text, _horario.text, _confirmada);
        ActivityController().addActivity("activity", activity);
        globalKey.currentState.showSnackBar(
            SnackBar(content: Text("Atividade cadastrada com sucesso")));
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => ActivityScreen(usuario: widget.usuario)));
      } else {
        globalKey.currentState
            .showSnackBar(SnackBar(content: Text("Preencha todos os campos")));
      }
    } catch (error) {
      print(error);
      globalKey.currentState.showSnackBar(
          SnackBar(content: Text("Não foi possível cadastrar a atividade.")));
    }
  }
}
