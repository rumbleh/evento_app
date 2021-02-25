import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evento_app/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserController extends StatefulWidget {
  @override
  _UserControllerState createState() => _UserControllerState.instance;

  Future<ApiResponse> adicionarParticipante(
      User user, GlobalKey<FormState> formKey) {
    return createState()._cadastrar(user, formKey);
  }

  Future<ApiResponse> login(User user, GlobalKey<FormState> formKey) {
    return createState()._login(user, formKey);
  }

  Future<ApiResponse> logout() {
    return createState()._logout();
  }
}

class _UserControllerState extends State<UserController> {
  String firebaseUserUid;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseReference databaseReference = FirebaseDatabase.instance.reference();

  static _UserControllerState _instance;
  _UserControllerState._() {}

  static _UserControllerState get instance =>
      _instance = _instance ?? _UserControllerState._();

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Future<ApiResponse> _cadastrar(
      User user, GlobalKey<FormState> formKey) async {
    // Usuario do firebase
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);
      final FirebaseUser fUser = result.user;

      // Dados para atualizar o usuario
      final userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName = user.name;
      fUser.updateProfile(userUpdateInfo);

      // salvar dados no firebase
      if (fUser != null) {
        firebaseUserUid = fUser.uid;
        DocumentReference refUser =
            Firestore.instance.collection("user").document(firebaseUserUid);
        refUser.setData({
          "name": user.name,
          "email": user.email,
          "password": user.password
        });
      }

      formKey.currentState.save();
      formKey.currentState.reset();
      return ApiResponse.ok(msg: "Usuário cadastrado com sucesso");
    } catch (error) {
      print(error);
      if (error is PlatformException) {
        print("Error code: ${error.code}");
        return ApiResponse.ok(
            msg:
                "Erro ao criar o usuário.\n\n\Este e-mail já foi cadastrado em nosso sistema.");
      }
      return ApiResponse.error(msg: "Não foi possível criar um usuário.");
    }
    // resposta generica
    return null;
  }

  Future<ApiResponse> _login(User user, GlobalKey<FormState> formKey) async {
    // Usuario do firebase
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: user.email, password: user.password);
      final FirebaseUser fUser = result.user;

      formKey.currentState.save();
      formKey.currentState.reset();
      return ApiResponse.ok(msg: "Você realizou o login com sucesso.", user: fUser);
    } catch (error) {
      print(error);
      if (error is PlatformException) {
        print("Error code: ${error.code}");
        return ApiResponse.ok(msg: "Erro ao realizar o login.");
      }
      return ApiResponse.error(msg: "Usuário ou senha incorreta.");
    }
    // resposta generica
    return null;
  }

  Future<ApiResponse> _logout() async {
    await _auth.signOut();
  }
}

class ApiResponse<T> {
  bool ok;
  String msg;
  FirebaseUser user;
  T result;

  ApiResponse.ok({this.result, this.msg, this.user}) {
    ok = true;
  }

  ApiResponse.error({this.result, this.msg}) {
    ok = false;
  }
}
