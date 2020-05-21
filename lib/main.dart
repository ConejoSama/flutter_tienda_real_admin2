import 'package:flutter/material.dart';
import 'package:flutter_tienda_real_admin/providers/app_states.dart';
import 'package:flutter_tienda_real_admin/providers/products_provider.dart';
import 'package:flutter_tienda_real_admin/providers/userprovider.dart';
import 'package:flutter_tienda_real_admin/screens/admin.dart';
import 'package:flutter_tienda_real_admin/screens/dashboard.dart';
import 'package:flutter_tienda_real_admin/screens/login.dart';
import 'package:provider/provider.dart';


void main(){
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: UserProvider.initialize()),
      ChangeNotifierProvider.value(value: AppState()),
      ChangeNotifierProvider.value(value: ProductProvider()),

    ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
//        theme: ThemeData(
//            primaryColor: Colors.deepOrange
//        ),
        home: ScreensController(),
      )));
}


class ScreensController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    switch(user.status){
      case Status.Uninitialized:
        return Login();
      case Status.Unauthenticated:
      case Status.Authenticating:
        return Login();
      case Status.Authenticated:
        return Dashboard();
        
      default: return Login();
    }
  }
}