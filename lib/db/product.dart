import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class ProductService {
  Firestore _firestore = Firestore.instance;
  String ref = 'Products';

  void uploadProduct(Map<String, dynamic> data) {
    var id = Uuid();
    String productId;
    String category;
    data['id'] = productId;
    data['category'] = category;
    
    Fluttertoast.showToast(msg: category);
  }
}