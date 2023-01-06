import 'package:firebase_database/firebase_database.dart';

void getData() {
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  ref.set({
    "name": "John",
    "age": 18,
    "address": {"line1": "100 Mountain View"}
  });
}
