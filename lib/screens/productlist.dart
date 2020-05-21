import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tienda_real_admin/models/firestore_service.dart';
import 'package:flutter_tienda_real_admin/models/productmodel.dart';
import 'package:flutter_tienda_real_admin/providers/search.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductList extends StatefulWidget {
  final category;
  ProductList({Key key,@required this.category,}) : super(key : key);

  @override
  _ProductListState createState() => _ProductListState(category);
}

class _ProductListState extends State<ProductList> {

  final category;
  _ProductListState(this.category);
  @override
  Widget build(BuildContext context) {
//    final user = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Categories"),
      ),
      body: StreamBuilder(
        stream: FirestoreService().getProductModel(category) ,
        builder: (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot){
          if(snapshot.hasError || !snapshot.hasData)
            return CircularProgressIndicator();
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              ProductModel note = snapshot.data[index];
             return ProductsUI(note);
            },
          );
        },
      ),
    );
  }




  Widget ProductsUI(ProductModel note)
  {
    return new Card
      (
      elevation: 10.0,
      margin: EdgeInsets.all(15.0),

      child: InkWell(
//        onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (context) => PostsDetails(id : note.id, name : note.pname, price : note.pprice, picture : note.ppicture, quantity : note.pquantity, brand : note.pbrand, category : note.pcategory)));},
        child: new Container(
          padding: new  EdgeInsets.all(14.0),

          child: new  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Row(
                children: <Widget>[

                  new Image.network(note.ppicture,height: 75,width: 75),

                  SizedBox(width: 13),
                  Column(
                    children: <Widget>[



                      new Text(note.pname,
                        style: Theme.of(context).textTheme.subtitle,
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 5),
                      new Text("\$${note.pprice}"

                      ),


                            IconButton(
                              color: Colors.red,
                              icon: Icon(Icons.delete),
                              onPressed: () => _deleteNote(context, note.id),
                            ),

                    ],

                  )




                ],
              ),


            ],
          ),
        ),
      ),
    );


  }

  void _deleteNote(BuildContext context,String id) async {
    if(await _showConfirmationDialog(context)) {
      try {
        await Firestore.instance.collection('Products').document(id).delete();

        DocumentReference documentReference =
        Firestore.instance.collection("TotalList").document('Total');
        documentReference.get().then((datasnapshot) {
          if (datasnapshot.exists) {
            int CantidadActual = datasnapshot.data['ProductTotal'];
            int CantidadTotal = CantidadActual - 1;
            Firestore.instance.collection("TotalList").document('Total').updateData({
              'ProductTotal':CantidadTotal,
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

