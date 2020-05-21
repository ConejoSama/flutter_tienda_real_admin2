import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tienda_real_admin/models/firestore_service.dart';
import 'package:flutter_tienda_real_admin/models/productmodel.dart';
import 'package:flutter_tienda_real_admin/screens/OrderDetails.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  var pending = 'Pending';
  var accepted = 'Accepted';
  List<Widget> containers = [
    Container(
      color: Colors.pink,
    ),
    Container(
      color: Colors.blue,
    ),
    Container(
      color: Colors.deepPurple,
    )
  ];

  TextEditingController categoryController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  GlobalKey<FormState> _categoryFormKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
                        length: 2,
                  child: Scaffold(
                    appBar: AppBar(
                      bottom: TabBar(
                        tabs: [
                          Tab(text: 'Pending'),
                          Tab(text: 'Accepted'),
                        ],
                      ),
                      title: Text('SHOP APP'),
                    ),
                    body: TabBarView(
                      children: [
                    SafeArea(
                    child: ListView(
                    children: <Widget>[
              //           Custom App bar


              //          Search Text field

                        StreamBuilder(
                        stream: FirestoreService().getOrders(pending) ,
                    builder: (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot){
                      if(snapshot.hasError || !snapshot.hasData)
                        return CircularProgressIndicator();
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          ProductModel note = snapshot.data[index];
                          return ProductsUI(note);
                        },
                      );
                    },
                  ),

                      ],
                    ),
                  ),

                          SafeArea(
                            child: ListView(
                          children: <Widget>[
                          //           Custom App bar


                          //          Search Text field

                          StreamBuilder(
                          stream: FirestoreService().getOrders(accepted) ,
                          builder: (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot){
                          if(snapshot.hasError || !snapshot.hasData)
                          return CircularProgressIndicator();
                          return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                          ProductModel note = snapshot.data[index];
                          return ProductsAcceptedUI(note);
                          },
                          );
                          },
                          ),

                          ],
                          ),
                          ),
        ],
      ),
    ),
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
        onTap: (){

          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              elevation: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: IntrinsicWidth(
                  child: IntrinsicHeight(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Options",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: "Roboto",
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Select one option below",
                          style: TextStyle(
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: FlatButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrdersDetails(id : note.id, name : note.pname, price : note.pprice)));
                                },
                                child: Text("Products order"),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: FlatButton(
                                onPressed: () {
                                  Firestore.instance.collection('Orders').document(note.id).updateData({
                                    "State":'Accepted',
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: Text("Accept Order"),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: FlatButton(
                                onPressed: () {

                                  var alert = new AlertDialog(
                                    content: Form(
                                      key: _categoryFormKey,
                                      child: TextFormField(
                                        controller: categoryController,
                                        validator: (value){
                                          if(value.isEmpty){
                                            return 'must be provided the reason';
                                          }
                                        },
                                        decoration: InputDecoration(
                                            hintText: "Reason"
                                        ),
                                      ),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(onPressed: (){
                                        if(categoryController.text != null){
                                          Firestore.instance.collection('Orders').document(note.id).delete();
                                          Firestore.instance.collection('Users').document(note.id).collection('Total').getDocuments().then((snapshot) {
                                            for (DocumentSnapshot doc2 in snapshot.documents) {
                                              doc2.reference.delete();
                                            }});
                                          Firestore.instance.collection('Users').document(note.id).collection('Cart').getDocuments().then((snapshot) {
                                          for (DocumentSnapshot doc in snapshot.documents) {
                                          doc.reference.delete();
                                          }});

                                          Firestore.instance.collection('Users').document(note.id).collection('Cart Denied').document(note.id).setData({
                                            "Cancelled":categoryController.text,
                                          });

                                          DocumentReference documentReference =
                                          Firestore.instance.collection("TotalList").document('Total');
                                          documentReference.get().then((datasnapshot) {
                                            if (datasnapshot.exists) {
                                              int CantidadActual = datasnapshot.data['OrdersTotal'];
                                              int CantidadTotal = CantidadActual - 1;
                                              Firestore.instance.collection("TotalList").document('Total').updateData({
                                                'OrdersTotal':CantidadTotal,
                                              });
                                            }
                                          });
                                          }
//          Fluttertoast.showToast(msg: 'category created');
                                        Navigator.pop(context);
                                      }, child: Text('Delete')),
                                      FlatButton(onPressed: (){
                                        Navigator.pop(context);
                                      }, child: Text('Cancel')),

                                    ],
                                  );
                                  showDialog(context: context, builder: (_) => alert);
                                },
                                child: Text("Cancel Order"),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: FlatButton(
                                onPressed: () {

                                  Navigator.of(context).pop();
                                },
                                child: Text("Cancel"),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          );
          },
        child: new Container(
          padding: new  EdgeInsets.all(14.0),

          child: new  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Row(
                children: <Widget>[

                  SizedBox(width: 13),
                  Column(
                    children: <Widget>[

                      new Text(note.email,
                        style: Theme.of(context).textTheme.subtitle,
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 5),
                      new Text("\$${note.id}",


                      ),
                      new Text("Address: "+note.address,
                        style: Theme.of(context).textTheme.subtitle,
                        textAlign: TextAlign.left,
                      ),
                      new Text("Date: "+note.date,
                        style: Theme.of(context).textTheme.subtitle,
                        textAlign: TextAlign.left,
                      ),
                      new Text("PaymentID: "+note.paymentid,
                        style: Theme.of(context).textTheme.subtitle,
                        textAlign: TextAlign.left,
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

  Widget ProductsAcceptedUI(ProductModel note)
  {
    return new Card
      (
      elevation: 10.0,
      margin: EdgeInsets.all(15.0),

      child: InkWell(
        onTap: (){

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                ),
                elevation: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: IntrinsicWidth(
                    child: IntrinsicHeight(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Options",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontFamily: "Roboto",
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Select one option below",
                            style: TextStyle(
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrdersDetails(id : note.id, name : note.pname, price : note.pprice)));
                                  },
                                  child: Text("Products order"),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: FlatButton(
                                  onPressed: () {
                                    Firestore.instance.collection('Orders').document(note.id).updateData({
                                      "State":'Accepted',
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Order Completed"),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: FlatButton(
                                  onPressed: () {

                                    var alert = new AlertDialog(
                                      content: Form(
                                        key: _categoryFormKey,
                                        child: TextFormField(
                                          controller: categoryController,
                                          validator: (value){
                                            if(value.isEmpty){
                                              return 'must be provided the reason';
                                            }
                                          },
                                          decoration: InputDecoration(
                                              hintText: "Reason"
                                          ),
                                        ),
                                      ),
                                      actions: <Widget>[
                                        FlatButton(onPressed: (){
                                          if(categoryController.text != null){
                                            Firestore.instance.collection('Orders').document(note.id).delete();
                                            Firestore.instance.collection('Users').document(note.id).collection('Cart').getDocuments().then((snapshot) {
                                              for (DocumentSnapshot doc in snapshot.documents) {
                                                doc.reference.delete();
                                              }});
                                            Firestore.instance.collection('Users').document(note.id).collection('Total').getDocuments().then((snapshot) {
                                              for (DocumentSnapshot doc2 in snapshot.documents) {
                                                doc2.reference.delete();
                                              }});

                                            Firestore.instance.collection('Users').document(note.id).collection('Cart Denied').document(note.id).setData({
                                              "Cancelled":categoryController.text,


                                            });

                                            DocumentReference documentReference =
                                            Firestore.instance.collection("TotalList").document('Total');
                                            documentReference.get().then((datasnapshot) {
                                              if (datasnapshot.exists) {
                                                int CantidadActual = datasnapshot.data['OrdersTotal'];
                                                int CantidadTotal = CantidadActual - 1;
                                                Firestore.instance.collection("TotalList").document('Total').updateData({
                                                  'OrdersTotal':CantidadTotal,
                                                });
                                              }
                                            });
                                            
                                          }
//          Fluttertoast.showToast(msg: 'category created');
                                          Navigator.pop(context);
                                        }, child: Text('Delete')),
                                        FlatButton(onPressed: (){
                                          Navigator.pop(context);
                                        }, child: Text('Cancel')),

                                      ],
                                    );
                                    showDialog(context: context, builder: (_) => alert);
                                  },
                                  child: Text("Cancel Order"),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: FlatButton(
                                  onPressed: () {

                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Cancel"),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: new Container(
          padding: new  EdgeInsets.all(14.0),

          child: new  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Row(
                children: <Widget>[

                  SizedBox(width: 13),
                  Column(
                    children: <Widget>[

                      new Text(note.email,
                        style: Theme.of(context).textTheme.subtitle,
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 5),
                      new Text("\$${note.id}"

                      ),
                      new Text("Address: "+note.address,
                        style: Theme.of(context).textTheme.subtitle,
                        textAlign: TextAlign.left,
                      ),
                      new Text("Date: "+note.date,
                        style: Theme.of(context).textTheme.subtitle,
                        textAlign: TextAlign.left,
                      ),
                      new Text("PaymentID: "+note.paymentid,
                        style: Theme.of(context).textTheme.subtitle,
                        textAlign: TextAlign.left,
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
}


