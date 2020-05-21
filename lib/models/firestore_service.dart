import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tienda_real_admin/models/TotalListModel.dart';
import 'package:flutter_tienda_real_admin/models/note.dart';
import 'package:flutter_tienda_real_admin/models/productmodel.dart';

class FirestoreService {
  static final FirestoreService _firestoreService =
  FirestoreService._internal();
  Firestore _db = Firestore.instance;

  FirestoreService._internal();

  factory FirestoreService() {
    return _firestoreService;
  }

  Stream<List<Note>> getNotes() {
    return _db.collection('categories').snapshots().map(
          (snapshot) => snapshot.documents.map(
            (doc) => Note.fromMap(doc.data, doc.documentID),
      ).toList(),
    );
  }

  Future<void> addNote(Note note) {
    return _db.collection('categories').add(note.toMap());
  }

  Future<void> deleteNote(String id) {
    return _db.collection('categories').document(id).delete();
    

  }

  Future<void> updateNote(Note note) {
    return _db.collection('categories').document(note.id).updateData(note.toMap());
  }

  Stream<List<ProductModel>> getOrders(String difference) {
    return _db.collection('Orders').where('State',isEqualTo: difference).snapshots().map(
          (snapshot) => snapshot.documents.map(
            (doc) => ProductModel.fromMap(doc.data, doc.documentID),
      ).toList(),
    );
  }

  Stream<List<ProductModel>> getOrdersSeparated(String userid) {
    return _db.collection('Users').document(userid).collection('Cart').snapshots().map(
          (snapshot) => snapshot.documents.map(
            (doc) => ProductModel.fromMap(doc.data, doc.documentID),
      ).toList(),
    );
  }

  Stream<List<ProductModel>> getProductModel(String categorysort) {
    return _db.collection('Products').where('category',isEqualTo: categorysort).snapshots().map(
          (snapshot) => snapshot.documents.map(
            (doc) => ProductModel.fromMap(doc.data, doc.documentID),
      ).toList(),
    );
  }

  Stream<List<TotalModelList>> getTotalModel() {
    return _db.collection('TotalList').snapshots().map(
          (snapshot) => snapshot.documents.map(
            (doc) => TotalModelList.fromMap(doc.data, doc.documentID),
      ).toList(),
    );
  }

}


