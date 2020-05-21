import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tienda_real_admin/models/notebrand.dart';

class FirestoreService2 {
  static final FirestoreService2 _firestoreService =
  FirestoreService2._internal();
  Firestore _db = Firestore.instance;

  FirestoreService2._internal();

  factory FirestoreService2() {
    return _firestoreService;
  }

  Stream<List<NoteBrand>> getNotes() {
    return _db.collection('brands').snapshots().map(
          (snapshot) => snapshot.documents.map(
            (doc) => NoteBrand.fromMap(doc.data, doc.documentID),
      ).toList(),
    );
  }

  Future<void> addNote(NoteBrand note) {
    return _db.collection('brands').add(note.toMap());
  }

  Future<void> deleteNote(String id) {
    return _db.collection('brands').document(id).delete();
  }

  Future<void> updateNote(NoteBrand note) {
    return _db.collection('brands').document(note.id).updateData(note.toMap());
  }

}


