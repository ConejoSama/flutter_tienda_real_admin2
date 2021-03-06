import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tienda_real_admin/providers/search.dart';
import 'package:flutter_tienda_real_admin/screens/productlist.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SearchFilter extends StatefulWidget {
  @override
  _SearchFilterState createState() => _SearchFilterState();
}

class _SearchFilterState extends State<SearchFilter> {
  var category;
  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.length == 0 && value.length == 1) {
      SearchService().searchByName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          queryResultSet.add(docs.documents[i].data);
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['category'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(

      body: SafeArea(
        child: ListView(
          children: <Widget>[
//           Custom App bar


//          Search Text field
            ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: <Widget>[

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (val) {
                        initiateSearch(val);
                      },
                      decoration: InputDecoration(
                          prefixIcon: IconButton(
                            color: Colors.black,
                            icon: Icon(Icons.arrow_back),
                            iconSize: 20.0,
//                            onPressed: () {},
                          ),
                          contentPadding: EdgeInsets.only(left: 25.0),
                          hintText: 'Search by name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0))),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  GridView.count(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      crossAxisCount: 2,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                      primary: false,
                      shrinkWrap: true,
                      children: tempSearchStore.map((element) {
                        return buildResultCard(element);
                      }).toList())
                ]),

          ],
        ),
      ),
    );
  }

  Widget buildResultCard(data) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 2.0,
        child: InkWell(
            onTap: (){
              Fluttertoast.showToast(msg: data['category'].toString());
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductList(category : data['category'].toString())));},
            child: Container(
                child: Center(
                    child: Text(data['category'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                      ),
                    )
                )
            )
        )

    );
  }
}
