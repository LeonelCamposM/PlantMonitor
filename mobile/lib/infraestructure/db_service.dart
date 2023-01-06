import 'package:firebase_database/firebase_database.dart';

void getData() {
  DatabaseReference starCountRef = FirebaseDatabase.instance.ref();
  starCountRef.onValue.listen((DatabaseEvent event) {
    final data = event.snapshot.value;
    print('new');
    print(data);
  });
}
