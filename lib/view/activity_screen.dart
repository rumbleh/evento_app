import 'package:evento_app/controller/activity_controller.dart';
import 'package:evento_app/model/activity.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import 'menu.dart';

class ActivityScreen extends StatefulWidget {
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
                  ? _listagem(context)
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
      drawer: Menu(),
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

  Widget _listagem(BuildContext context) {
    return FirebaseAnimatedList(
        query: databaseReference,
        itemBuilder:
            (_, DataSnapshot snapshot, Animation<double> animation, int index) {
          return Card(
            child: ListTile(
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
          );
        });
  }

  void _deleteAtividade(BuildContext context, String key) {
    try {
      ActivityController().deleteActivity('activity', key);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => ActivityScreen()));
    } catch (error) {
      print(error);
      globalKey.currentState.showSnackBar(
          SnackBar(content: Text("Não foi possível remover a atividade")));
    }
  }

  Widget _cadastrarAtividade() {
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
            builder: (BuildContext context) => ActivityScreen()));
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
