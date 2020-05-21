import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tienda_real_admin/providers/userprovider.dart';
import 'package:flutter_tienda_real_admin/screens/dashboard.dart';
import 'package:flutter_tienda_real_admin/screens/login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class UserManagement extends StatefulWidget {
  @override
  _UserManagementState createState() => _UserManagementState();
}


class _UserManagementState extends State<UserManagement> {
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);

    Firestore.instance.collection('Users').where('uid',isEqualTo: user.user.uid)
        .getDocuments()
        .then((docs){
      if(docs.documents[0].exists){
        if(docs.documents[0].data['role'] == 'admin'){

          Fluttertoast.showToast(msg: 'ADMIN');



          Navigator.push(context, MaterialPageRoute(builder: (_)=>Dashboard()));



//          Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Dashboard()));
        }
        else{
          Navigator.push(context, MaterialPageRoute(builder: (_)=>Login()));
          FirebaseAuth.instance.signOut();
          Fluttertoast.showToast(msg: 'NOT ADMIN');
        }
      }
    });
    return Container();
  }
}
