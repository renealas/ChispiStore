import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/orders_screen.dart';
import '../screens/user_product_screen.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    final name = auth.userName;
    final userImage = auth.userImage;
    //final render = name=='Rene Alas' ? false : true; //Para deshabilitar en caso no se quiera una opcion.
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(   
            accountEmail: null,         
            accountName: Text(
              'Bienvenido $name!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            currentAccountPicture: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: GridTile(
                child: Image.network(
                  userImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Divider(),
         ListTile(        
            leading: Icon(Icons.shop),
            title: Text('Tienda'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Ordenes'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manejo de Productos'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Cerrar Session'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              //Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName);
              auth.logout();
            },
          ),
        ],
      ),
    );
  }
}
