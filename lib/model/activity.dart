import 'package:firebase_database/firebase_database.dart';

class Activity {
  String key;
  String title;
  String speaker;
  String schedule;
  bool confirmed;

  Activity(this.title, this.speaker, this.schedule, this.confirmed,
      [this.key = ""]);

  Activity.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        title = snapshot.value['title'],
        speaker = snapshot.value['speaker'],
        schedule = snapshot.value['schedule'],
        confirmed = snapshot.value['confirmed'];

  toJson() {
    return {
      "title": title,
      "speaker": speaker,
      "schedule": schedule,
      "confirmed": confirmed,
    };
  }

  fromJson(Map<String, dynamic> json) {
    key = json['key'];
    title = json['title'];
    speaker = json['speaker'];
    schedule = json['schedule'];
    confirmed = json['confirmed'];
  }

  void setKey(String value) {
    key = value;
  }
}
