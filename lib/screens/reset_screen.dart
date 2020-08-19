import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class ResetScreen extends StatelessWidget {
  static const routeName = '/reset';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    String correoReset = null;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'ChispiStore',
                        style: TextStyle(
                          color: Theme.of(context).accentTextTheme.title.color,
                          fontSize: 35,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 8.0,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                        height: 800,
                        //height: _heightAnimation.value.height,
                        constraints: BoxConstraints(minHeight: 800),
                        width: deviceSize.width * 0.75,
                        padding: EdgeInsets.all(16.0),
                        child: Form(
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  decoration:
                                      InputDecoration(labelText: 'Correo'),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value.isEmpty || !value.contains('@')) {
                                      return 'Email no Valido!';
                                    }
                                  },
                                  onChanged: (value) {
                                    correoReset = value;
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                RaisedButton(
                                  child: Text('CAMBIAR DE CONTRASEÑA',textAlign: TextAlign.center,),
                                  onPressed: () {
                                    Provider.of<Auth>(context, listen: false)
                                        .resetPassword(
                                      correoReset,
                                    );
                                    Navigator.of(context)
                                        .pushReplacementNamed('/');
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30.0, vertical: 8.0),
                                  color: Theme.of(context).primaryColor,
                                  textColor: Theme.of(context)
                                      .primaryTextTheme
                                      .button
                                      .color,
                                ),
                                FlatButton(
                                  child: Text('REGRESAR A ACCEDER'),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushReplacementNamed('/');
                                  },
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30.0, vertical: 4),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  textColor: Theme.of(context).primaryColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
