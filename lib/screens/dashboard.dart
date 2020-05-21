import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tienda_real_admin/db/brand.dart';
import 'package:flutter_tienda_real_admin/db/category.dart';
import 'package:flutter_tienda_real_admin/models/TotalListModel.dart';
import 'package:flutter_tienda_real_admin/models/firestore_service.dart';
import 'package:flutter_tienda_real_admin/providers/app_states.dart';
import 'package:flutter_tienda_real_admin/providers/userprovider.dart';
import 'package:flutter_tienda_real_admin/screens/admin.dart';
import 'package:flutter_tienda_real_admin/screens/brand_list.dart';
import 'package:flutter_tienda_real_admin/screens/category_list.dart';
import 'package:flutter_tienda_real_admin/screens/login.dart';
import 'package:flutter_tienda_real_admin/screens/orders.dart';
import 'package:flutter_tienda_real_admin/screens/productlist.dart';
import 'package:flutter_tienda_real_admin/screens/searchfilter.dart';
import 'package:flutter_tienda_real_admin/widgets/small_card.dart';
//import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'add_product.dart';

enum Departments { Crear_, Research, Purchasing, Marketing, Accounting }
class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
//  int TotalUsers = 0;
//  int TotalProducts = 0;
//  int OrdersPending = 0;
//  int OrdersAccepted = 0;
//  List<charts.Series<Task, String>> _seriesPieData;
//  var YesOrNot;
//
//  _getData(){
//    var piedata = [
//      new Task('Girls', 35.8, Color(0xff3366cc)),
//      new Task('Women', 8.3, Color(0xff990099)),
//      new Task('Pants', 10.8, Color(0xff109618)),
//      new Task('Formal', 15.6, Color(0xfffdbe19)),
//      new Task('Shoes', 19.2, Color(0xffff9900)),
//      new Task('Other', 10.3, Color(0xffdc3912)),
//    ];
//
//    _seriesPieData.add(
//      charts.Series(
//        domainFn: (Task task, _) => task.task,
//        measureFn: (Task task, _) => task.taskvalue,
//        colorFn: (Task task, _) =>
//            charts.ColorUtil.fromDartColor(task.colorval),
//        id: 'Air Pollution',
//        data: piedata,
//        labelAccessorFn: (Task row, _) => '${row.taskvalue}',
//      ),
//    );
//  }
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    _seriesPieData = List<charts.Series<Task, String>>();
//    _getData();

//    countDocuments();

//
//    final user = Provider.of<UserProvider>(context);
//
//    Firestore.instance.collection('Users').where('uid',isEqualTo: user.user.uid)
//        .getDocuments()
//        .then((docs){
//      if(docs.documents[0].exists){
//        if(docs.documents[0].data['role'] == 'admin'){
//
//          Fluttertoast.showToast(msg: 'ADMIN');
//
//
//        }
//        else{
//          Navigator.push(context, MaterialPageRoute(builder: (_)=>Login()));
//          FirebaseAuth.instance.signOut();
//          Fluttertoast.showToast(msg: 'NOT ADMIN');
//        }
//      }
//    });

//  }
  final DBRef = FirebaseDatabase.instance.reference();
  TextEditingController categoryController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  GlobalKey<FormState> _categoryFormKey = GlobalKey();
  GlobalKey<FormState> _brandFormKey = GlobalKey();
  BrandService _brandService = BrandService();
  CategoryService _categoryService = CategoryService();

  @override
  Widget build(BuildContext context) {

    var querydata = MediaQuery.of(context);
    var screen_height = querydata.size.height;
    var container_height = screen_height/6;

    final appState = Provider.of<AppState>(context);
  
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(child: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[400],
                      offset: Offset(1.0, 1.0),
                      blurRadius: 4
                  )
                ]
            ),
            width: 50,
            child: Column(
              children: <Widget>[
                IconButton(icon: Icon(Icons.menu, color: Colors.black,), onPressed: (){}),
                InkWell(
                  onTap: (){
                    appState.changeScreen(Screen.DASH);
                  },
                  child: Wrap(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      RotatedBox(
                        quarterTurns: -1,
                        child: Text('Dashboard',),
                      ),

                      Visibility(
                        visible: appState.selectedScreen == Screen.DASH,
                        child: Wrap(
                          children: <Widget>[
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 68,
                              width: 5,
                              color: Colors.black,
                            )

                          ],
                        ),
                      ),

                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: (){
                   _asyncSimpleDialog2(context);
                  },
                  child: Wrap(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      RotatedBox(
                        quarterTurns: -1,
                        child: Text('Products',),

                      ),

                      Visibility(
                        visible: appState.selectedScreen == Screen.PRODUCTS,
                        child: Wrap(
                          children: <Widget>[
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 58,
                              width: 5,
                              color: Colors.black,
                            )

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: (){
                    _asyncSimpleDialog(context);
                  },
                  child: Wrap(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      RotatedBox(
                        quarterTurns: -1,
                        child: Text('Categories',),
                      ),
                      Visibility(
                        visible: appState.selectedScreen == Screen.CATEGORIES,
                        child: Wrap(
                          children: <Widget>[
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 68,
                              width: 5,
                              color: Colors.black,
                            )

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),

//                InkWell(
//                  onTap: (){
//                    _asyncSimpleDialog2(context);
//                  },
//                  child: Wrap(
//                    direction: Axis.horizontal,
//                    children: <Widget>[
//                      RotatedBox(
//                        quarterTurns: -1,
//                        child: Text('Brands',),
//                      ),
//
//                      Visibility(
//                        visible: appState.selectedScreen == Screen.BRANDS,
//                        child: Wrap(
//                          children: <Widget>[
//                            SizedBox(
//                              width: 10,
//                            ),
//                            Container(
//                              height: 48,
//                              width: 5,
//                              color: Colors.black,
//                            )
//
//                          ],
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//                SizedBox(
//                  height: 15,
//                ),
                Expanded(
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>Orders()));
                    },
                    child: Wrap(
                      direction: Axis.horizontal,
                      children: <Widget>[
                        RotatedBox(
                          quarterTurns: -1,
                          child: Text('Orders',),
                        ),
                        Visibility(
                          visible: appState.selectedScreen == Screen.ORDERS,
                          child: Wrap(
                            children: <Widget>[
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                height: 48,
                                width: 5,
                                color: Colors.black,
                              )

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                IconButton(icon: Icon(Icons.open_in_new), onPressed: (){})

              ],
            ),
          ),
          
          
//              Padding(
//                padding: const EdgeInsets.all(10),
//                child: RichText(
//                  text: TextSpan(children: [
//                    TextSpan(text: 'Revenue\n', style: TextStyle(fontSize: 35, color: Colors.grey)),
//                    TextSpan(text: '\$1287.99', style: TextStyle(fontSize: 55, color: Colors.black, fontWeight: FontWeight.w300)),
//
//                  ]),
//                ),
//              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    StreamBuilder(
                      stream: FirestoreService().getTotalModel() ,
                      builder: (BuildContext context, AsyncSnapshot<List<TotalModelList>> snapshot){
                        if(snapshot.hasError || !snapshot.hasData)
                          return CircularProgressIndicator();
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            TotalModelList note = snapshot.data[index];
                           return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[

                                Row(
//                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    SmallCard(color2: Colors.indigo,color1: Colors.blue, icon: Icons.person_outline, value: note.usersTotal, title: 'Users'),
                                    SmallCard(color2: Colors.indigo,color1: Colors.blue, icon: Icons.shopping_cart, value: note.productTotal, title: 'Products',),
                                  ],
                                ),
                                Row(
//                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    SmallCard(color2: Colors.black87,color1: Colors.black87, icon: Icons.attach_money, value: note.ordersTotal,title: 'Orders',),
                                    SmallCard(color2: Colors.black,color1: Colors.black87, icon: Icons.category, value: note.categoryTotal, title: 'Categories',),
                                  ],
                                ),

                            ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
          

//              Padding(
//                padding: const EdgeInsets.only(left: 10),
//                child: Text('Sales per category', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey),),
//              ),
//
//              Expanded(
//                child: Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: Container(
//                    decoration: BoxDecoration(
//                        borderRadius: BorderRadius.circular(15),
//                        color: Colors.white,
//                        boxShadow: [
//                          BoxShadow(
//                              color: Colors.grey[400],
//                              offset: Offset(1.0, 1.0),
//                              blurRadius: 4
//                          )
//                        ]
//                    ),
//                    width: MediaQuery.of(context).size.width / 1.2,
//                    child: ListTile(
//                      title: charts.PieChart(
//                          _seriesPieData,
//                          animate: true,
//                          animationDuration: Duration(seconds: 3),
//                          behaviors: [
//                            new charts.DatumLegend(
//                              outsideJustification: charts.OutsideJustification.endDrawArea,
//                              horizontalFirst: false,
//                              desiredMaxRows: 2,
//                              cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
//                            )
//                          ],
//                          defaultRenderer: new charts.ArcRendererConfig(
//                              arcWidth: 30,
//                              arcRendererDecorators: [
//                                new charts.ArcLabelDecorator(
//                                    labelPosition: charts.ArcLabelPosition.inside)
//                              ])),
//                    ),
//                  ),
//                ),
//              )

            
        ],
      )),
    );
  }

  void _categoryAlert() {
    var id = Uuid();
    String categoryId = id.v1();
    var alert = new AlertDialog(
      content: Form(
        key: _categoryFormKey,
        child: TextFormField(
          controller: categoryController,
          validator: (value){
            if(value.isEmpty){
              return 'category cannot be empty';
            }
          },
          decoration: InputDecoration(
              hintText: "add category"
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(onPressed: (){
          if(categoryController.text != null){
            var capitalizedValue = categoryController.text.toUpperCase();

            _categoryService.createCategory(capitalizedValue);
            Fluttertoast.showToast(msg: 'Category Created');
          }

          Navigator.pop(context);
        }, child: Text('ADD')),
        FlatButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text('CANCEL')),

      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }


  Future<Departments> _asyncSimpleDialog(BuildContext context) async {
  return await showDialog<Departments>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Options'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                _categoryAlert();
              },
              child: const Text('Create Category'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_)=>CategoryList()));
              },
              child: const Text('Category List'),
            ),
          ],
        );
      });
}

  Future<Departments> _asyncSimpleDialog2(BuildContext context) async {
    return await showDialog<Departments>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Options'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {

                  Navigator.push(context, MaterialPageRoute(builder: (_)=>AddProduct()));
                },
                child: const Text('New Product'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>SearchFilter()));
                },
                child: const Text('Product List'),
              ),
            ],
          );
        });
  }

//  void countDocuments() async {
//    QuerySnapshot _myDoc = await Firestore.instance.collection('Users').getDocuments();
//    List<DocumentSnapshot> _myDocCount = _myDoc.documents;
//    TotalUsers = _myDocCount.length;
//
//    QuerySnapshot _myDoc2 = await Firestore.instance.collection('Products').getDocuments();
//    List<DocumentSnapshot> _myDocCount2 = _myDoc2.documents;
//    TotalProducts = _myDocCount2.length;
//
//    QuerySnapshot _myDoc3 = await Firestore.instance.collection('Orders').where('State',isEqualTo: 'Pending').getDocuments();
//    List<DocumentSnapshot> _myDocCount3 = _myDoc3.documents;
//    OrdersPending = _myDocCount3.length;
//
//    QuerySnapshot _myDoc4 = await Firestore.instance.collection('categories').getDocuments();
//    List<DocumentSnapshot> _myDocCount4 = _myDoc4.documents;
//    OrdersAccepted = _myDocCount4.length;
//
//  }

  }

class Task {
  String task;
  double taskvalue;
  Color colorval;

  Task(this.task, this.taskvalue, this.colorval);



}


