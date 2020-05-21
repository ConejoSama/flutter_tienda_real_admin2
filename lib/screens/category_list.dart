import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tienda_real_admin/db/brandcategory.dart';
import 'package:flutter_tienda_real_admin/models/FirestoreService2.dart';
import 'package:flutter_tienda_real_admin/models/firestore_service.dart';
import 'package:flutter_tienda_real_admin/models/note.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}


class _CategoryListState extends State<CategoryList> {
  final DBRef = FirebaseDatabase.instance.reference();
  Firestore db = Firestore.instance;
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categories"),
      ),
      body: StreamBuilder(
        stream: FirestoreService().getNotes() ,
        builder: (BuildContext context, AsyncSnapshot<List<Note>> snapshot){
          if(snapshot.hasError || !snapshot.hasData)
            return CircularProgressIndicator();
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              Note note = snapshot.data[index];
              return ListTile(
                title: Text(note.title),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      color: Colors.red,
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteNote(context, note.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }



  void _deleteNote(BuildContext context,String id) async {
    if(await _showConfirmationDialog(context)) {
      try {
        await FirestoreService().deleteNote(id);

        DocumentReference documentReference =
        Firestore.instance.collection("TotalList").document('Total');
        documentReference.get().then((datasnapshot) {
          if (datasnapshot.exists) {
            int CantidadActual = datasnapshot.data['CategoryTotal'];
            int CantidadTotal = CantidadActual - 1;
            Firestore.instance.collection("TotalList").document('Total').updateData({
              'CategoryTotal':CantidadTotal,
            });
          }
        });
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
