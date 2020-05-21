import 'package:flutter/material.dart';
import 'package:flutter_tienda_real_admin/models/firestore_service.dart';
import 'package:flutter_tienda_real_admin/models/productmodel.dart';

class OrdersDetails extends StatefulWidget {
  final id,name,price;
  OrdersDetails({Key key,@required this.id,this.name,this.price}) : super(key : key);
  @override
  _OrdersDetailsState createState() => _OrdersDetailsState(id,name,price);
}

class _OrdersDetailsState extends State<OrdersDetails> {
  final id,name,price;
  _OrdersDetailsState(this.id,this.name,this.price);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SHOP APP'),
      ),

      body: SafeArea(
        child: ListView(
          children: <Widget>[
//
            StreamBuilder(
              stream: FirestoreService().getOrdersSeparated(id) ,
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
//                    return ListTile(
//                      title: Text(note.pname),
//                      trailing: Row(
//                        mainAxisSize: MainAxisSize.min,
//
//                      ),
//                    );
                  },
                );
              },
            ),

          ],
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
        onTap: (){},
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
