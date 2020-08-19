import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     //Variable del Año para Footer en apps. 
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy');
    String formattedDate = formatter.format(now);
    //--------------
     //Esto es para poner el footer en las apps. 
    return Container(
        color: Theme.of(context).primaryColor,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Rene Alas © - $formattedDate',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: Theme.of(context).primaryTextTheme.title.fontFamily,
              ),
            ),
          ],
        ),
      );
  }
}