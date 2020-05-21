import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class CategoryService{
  Firestore _firestore = Firestore.instance;
  String  ref  = 'categories';

  void createCategory(String name){
    var id = Uuid();
    String categoryId = id.v1();
    var searchkey  = name.substring(0, 1);
    _firestore.collection(ref).document(categoryId).setData({'category': name,'searchKey':searchkey});

    DocumentReference documentReference =
    Firestore.instance.collection("TotalList").document('Total');
    documentReference.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        int CantidadActual = datasnapshot.data['CategoryTotal'];
        int CantidadTotal = CantidadActual + 1;
        Firestore.instance.collection("TotalList").document('Total').updateData({
          'CategoryTotal':CantidadTotal,
        });
      }
      else{
        Firestore.instance.collection("TotalList").document('Total').setData({
          'CategoryTotal': 1,
          'ProductTotal':0,
          'OrdersTotal':0,
          'UsersTotal':0,
        });
      }
    });
  }
  Future<List<DocumentSnapshot>> getCategories() =>
     _firestore.collection(ref).getDocuments().then((snaps){
      return snaps.documents;
    });


  Future getSuggestions(String suggestion) =>
      _firestore.collection(ref).where('category', isEqualTo: suggestion).getDocuments().then((snap){
        return snap.documents;
      });
}