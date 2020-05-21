import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tienda_real_admin/db/brandcategory.dart';
import 'package:flutter_tienda_real_admin/models/FirestoreService2.dart';
import 'package:flutter_tienda_real_admin/models/firestore_service.dart';
import 'package:flutter_tienda_real_admin/models/note.dart';
import 'package:flutter_tienda_real_admin/models/notebrand.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BrandList extends StatefulWidget {
  @override
  _BrandListState createState() => _BrandListState();
}


class _BrandListState extends State<BrandList> {
  Firestore db = Firestore.instance;
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  final DBRef = FirebaseDatabase.instance.reference();

  List<BrandL>brandList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DatabaseReference postsRef = FirebaseDatabase.instance.reference().child("Brands");
    postsRef.once().then((DataSnapshot snap)
    {
      var KEYS = snap.value.keys;
      var DATA = snap.value;

      brandList.clear();

      for(var individualKey in KEYS)
      {
        BrandL posts = new BrandL
          (


          DATA[individualKey]['brand'],
          DATA[individualKey]['id'],


        );

        brandList.add(posts);

      }

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Brands"),
        ),
        body: Container(

            child:  ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: brandList.length,
                itemBuilder: (_, index){

                  return ListTile(
                    title: Text(brandList[index].brand),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
//                    IconButton(
//                      color: Colors.blue,
//                      icon: Icon(Icons.edit),
//                      onPressed: () => Navigator.push(context, MaterialPageRoute(
//                        builder: (_) => AddNotePage(note: note),
//                      )),
//                    ),
                        IconButton(
                          color: Colors.red,
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteNote(context, brandList[index].id),
                        ),
                      ],
                    ),

                  );


                })

        )
    );
  }


  void _deleteNote(BuildContext context,String id) async {
    if(await _showConfirmationDialog(context)) {
      try {
        await FirestoreService2().deleteNote(id);
        DBRef.child("Brands").child(id).remove();
      }catch(e) {
        print(e);
      }
    }
  }

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) =>
            AlertDialog(
              content: Text("Are you sure you want to delete?"),
              actions: <Widget>[
                FlatButton(
                  textColor: Colors.red,
                  child: Text("Delete"),
                  onPressed: () => Navigator.pop(context, true),
                ),
                FlatButton(
                  textColor: Colors.black,
                  child: Text("No"),
                  onPressed: () => Navigator.pop(context, false),
                ),
              ],
            ));
  }
}
