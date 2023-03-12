import 'package:cloud_firestore/cloud_firestore.dart';
import 'exercise_model.dart';

class FirestoreTaskDataStore {
  final FirebaseFirestore _firestore;

  FirestoreTaskDataStore({
    FirebaseFirestore? firestore
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<Exercise>> getForUser() async {
    // get the user's inventory entries
    final exercises = await _firestore
        .collection('exercises')
        .get();

    return exercises.docs.map((doc) {
        final data = doc.data();
        _firestore.collection('exercises').doc();

        List<int> progressList = [];
        if (data["progress"] != null) {
          for (int i = 0; i < data["progress"].length; i++) {
            if (data["progress"][i].runtimeType != int) {
              progressList.add(int.parse(data["progress"][i]));
            } else {
              progressList.add(data["progress"][i]);
            }
          }
        }
        data["progress"] = progressList;
        return Exercise.fromJson(data);
    }).toList();
  }
}