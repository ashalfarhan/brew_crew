import 'package:brew_crew/models/brew.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final _brewCollection = FirebaseFirestore.instance.collection('brews');

  Future<void> createNewBrew(String uid) async {
    await _brewCollection.doc(uid).set({
      "sugars": "0",
      "name": "New crew member",
      "strength": 100,
    });
  }

  Future<void> updateBrewByUid(
    String uid, {
    required String sugars,
    required String name,
    required int strength,
  }) async {
    await _brewCollection.doc(uid).set({
      "sugars": sugars,
      "name": name,
      "strength": strength,
    });
  }

  List<Brew> _brewListFromSnapshots(QuerySnapshot snap) {
    return snap.docs.map(Brew.fromSnapshotQuery).toList();
  }

  Stream<List<Brew>> get brews {
    return _brewCollection.snapshots().map(_brewListFromSnapshots);
  }

  Stream<Brew> getByUid(String uid) {
    return _brewCollection.doc(uid).snapshots().map(Brew.fromSnapshot);
  }
}
