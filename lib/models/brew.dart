import 'package:cloud_firestore/cloud_firestore.dart';

class Brew {
  String uid;
  String sugars;
  String name;
  int strength;

  Brew({
    required this.uid,
    required this.name,
    required this.sugars,
    required this.strength,
  });

  factory Brew.fromSnapshotQuery(QueryDocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;

    return Brew(
      uid: snap.id,
      name: data['name'] ?? "",
      sugars: data['sugars'] ?? "0",
      strength: data['strength'] ?? 100,
    );
  }

  factory Brew.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;

    return Brew(
      uid: snap.id,
      name: data['name'] ?? "",
      sugars: data['sugars'] ?? "0",
      strength: data['strength'] ?? 100,
    );
  }
}
