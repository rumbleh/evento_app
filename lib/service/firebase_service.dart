import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final FirebaseDatabase databaseRealTime = FirebaseDatabase.instance;
  DatabaseReference databaseReference;

  // Realtime database do Firebase

  DatabaseReference getDataRealTime(String databaseName) {
    return databaseReference = databaseRealTime.reference().child(databaseName);
  }

  void saveDataRealTime(String databaseName, dynamic model) {
    databaseReference = databaseRealTime.reference().child(databaseName);
    databaseReference.push().set(model.toJson());
  }

  void updateDataRealTime(String databaseName, dynamic model) {
    databaseReference = databaseRealTime.reference().child(databaseName);
    databaseReference.update(model.toJson());
  }

  void deleteDataRealTime(String databaseName, dynamic key) {
    databaseReference = databaseRealTime.reference().child(databaseName);
    databaseReference.child(key).remove();
  }
}
