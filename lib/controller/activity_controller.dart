import 'package:evento_app/service/firebase_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ActivityController extends StatefulWidget {
  @override
  _ActivityControllerState createState() => _ActivityControllerState.instance;

  void addActivity(String table, Object data) {
    createState()._addActivity(table, data);
  }

  void deleteActivity(String table, Object data) {
    createState()._deleteActivity(table, data);
  }

  void updateActivity(String table, Object data) {
    createState()._updateActivity(table, data);
  }

  DatabaseReference getAllActivities(String table) {
    return createState()._getAllActivities(table);
  }
}

class _ActivityControllerState extends State<ActivityController> {
  FirebaseService firebaseService = FirebaseService();
  _ActivityControllerState._() {}

  static _ActivityControllerState _instance;
  static _ActivityControllerState get instance =>
      _instance = _instance ?? _ActivityControllerState._();

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void _addActivity(String table, Object data) {
    firebaseService.saveDataRealTime(table, data);
  }

  void _updateActivity(String table, Object data) {
    firebaseService.updateDataRealTime(table, data);
  }

  DatabaseReference _getAllActivities(String table) {
    return firebaseService.getDataRealTime(table);
  }

  void _deleteActivity(String table, Object data) {
    firebaseService.deleteDataRealTime(table, data);
  }
}
