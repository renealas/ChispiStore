// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shop/screens/user_product_screen.dart';

// import '../widgets/app_drawer.dart';
// import '../providers/product.dart';
// import '../providers/products.dart';

// //Este import es para el footer como widget.
// import '../widgets/footer.dart';

// class EditProductScreen extends StatefulWidget {
//   static const routeName = '/edit-product';
//   @override
//   _EditProductScreenState createState() => _EditProductScreenState();
// }

// class _EditProductScreenState extends State<EditProductScreen> {
//   final _priceFocusNode = FocusNode();
//   final _descriptionFocusNode = FocusNode();
//   final _imageUrlController = TextEditingController();
//   final _imageUrlFocusNode = FocusNode();
//   final _form = GlobalKey<FormState>();
//   var _editedProduct = Product(
//     id: null,
//     title: '',
//     price: 0,
//     description: '',
//     imageUrl: '',
//   );

//   var _initValues = {
//     'title': '',
//     'description': '',
//     'price': '',
//     'imageUrl': '',
//   };

//   var _isInit = true;
//   var _isLoading = false;

//   @override
//   void initState() {
//     _imageUrlFocusNode.addListener(_updateImageUrl);
//     super.initState();
//   }

//   void didChangeDependencies() {
//     if (_isInit) {
//       final productId = ModalRoute.of(context).settings.arguments as String;
//       if (productId != null) {
//         _editedProduct =
//             Provider.of<Products>(context, listen: false).findbyId(productId);
//         _initValues = {
//           'title': _editedProduct.title,
//           'description': _editedProduct.description,
//           'price': _editedProduct.price.toString(),
//           //'imageUrl': _editedProduct.imageUrl,
//           'imageUrl': '',
//         };
//         _imageUrlController.text = _editedProduct.imageUrl;
//       }
//     }
//     _isInit = false;
//     super.didChangeDependencies();
//   }

//   @override
//   void dispose() {
//     _imageUrlFocusNode.removeListener(_updateImageUrl);
//     _priceFocusNode.dispose();
//     _descriptionFocusNode.dispose();
//     _imageUrlController.dispose();
//     _imageUrlFocusNode.dispose();
//     super.dispose();
//   }

//   void _updateImageUrl() {
//     if (!_imageUrlFocusNode.hasFocus) {
//       if ((!_imageUrlController.text.startsWith('http') &&
//               !_imageUrlController.text.startsWith('https')) ||
//           (!_imageUrlController.text.endsWith('.png') &&
//               !_imageUrlController.text.endsWith('.jpg') &&
//               !_imageUrlController.text.endsWith('.jpeg'))) {
//         return;
//       }
//       setState(() {});
//     }
//   }

//   Future<void> _saveForm() async {
//     final isValid = _form.currentState.validate();
//     if (!isValid) {
//       return;
//     }
//     _form.currentState.save();
//     setState(() {
//       _isLoading = true;
//     });

//     if (_editedProduct.id != null) {
//       Provider.of<Products>(context, listen: false)
//           .updateProduct(_editedProduct.id, _editedProduct);
//     } else {
//       try{
//         await Provider.of<Products>(context, listen: false)
//           .addProduct(_editedProduct);
//       } catch (error){
//         return  await showDialog(
//           context: context,
//           builder: (ctx) => AlertDialog(
//             title: Text('Un Error Occurrio!'),
//             content: Text('Hubo un Fallo'),
//             actions: <Widget>[
//               FlatButton(child: Text('Okay'), onPressed: () {
//                 Navigator.of(ctx).pop();
//               },)
//             ],
//           ),
//           );
//       }
//     //   finally {
//     //     setState(() {
//     //       _isLoading = false;
//     //     });
//     //     Navigator.of(context).pushNamed(UserProductsScreen.routeName);
//     //   }
//     // }
//     setState(() {
//         _isLoading = false;
//       });
//       Navigator.of(context).pushNamed(UserProductsScreen.routeName);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edite el Producto'),
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(Icons.save),
//             onPressed: _saveForm,
//           )
//         ],
//       ),
//       body: _isLoading
//           ? Center(
//               child: CircularProgressIndicator(),
//             )
//           : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Form(
//                 key: _form,
//                 child: ListView(
//                   children: <Widget>[
//                     TextFormField(
//                       initialValue: _initValues['title'],
//                       decoration: InputDecoration(labelText: 'Titulo'),
//                       textInputAction: TextInputAction.next,
//                       onFieldSubmitted: (_) {
//                         FocusScope.of(context).requestFocus(_priceFocusNode);
//                       },
//                       validator: (value) {
//                         if (value.isEmpty) {
//                           return 'Porfavor provea un Titulo para el Producto';
//                         }
//                         return null;
//                       },
//                       onSaved: (value) {
//                         _editedProduct = Product(
//                           title: value,
//                           price: _editedProduct.price,
//                           description: _editedProduct.description,
//                           imageUrl: _editedProduct.imageUrl,
//                           id: _editedProduct.id,
//                           isFavorite: _editedProduct.isFavorite,
//                         );
//                       },
//                     ),
//                     TextFormField(
//                       initialValue: _initValues['price'],
//                       decoration: InputDecoration(labelText: 'Precio'),
//                       textInputAction: TextInputAction.next,
//                       keyboardType: TextInputType.number,
//                       focusNode: _priceFocusNode,
//                       onFieldSubmitted: (_) {
//                         FocusScope.of(context)
//                             .requestFocus(_descriptionFocusNode);
//                       },
//                       validator: (value) {
//                         if (value.isEmpty) {
//                           return 'Porfavor provea el precio del Producto';
//                         }
//                         if (double.tryParse(value) == null) {
//                           return 'Porfavor provea numero valido';
//                         }
//                         if (double.parse(value) <= 0) {
//                           return 'Porfavor provea numero mayor a 0';
//                         }
//                         return null;
//                       },
//                       onSaved: (value) {
//                         _editedProduct = Product(
//                           title: _editedProduct.title,
//                           price: double.parse(value),
//                           description: _editedProduct.description,
//                           imageUrl: _editedProduct.imageUrl,
//                           id: _editedProduct.id,
//                           isFavorite: _editedProduct.isFavorite,
//                         );
//                       },
//                     ),
//                     TextFormField(
//                       initialValue: _initValues['description'],
//                       decoration: InputDecoration(labelText: 'Descripcion'),
//                       maxLines: 3,
//                       keyboardType: TextInputType.multiline,
//                       focusNode: _descriptionFocusNode,
//                       validator: (value) {
//                         if (value.isEmpty) {
//                           return 'Porfavor provea una Descipcion para el Producto';
//                         }
//                         if (value.length < 10) {
//                           return 'La Descripcion debe ser almenos de 10 Caracteres';
//                         }
//                         return null;
//                       },
//                       onSaved: (value) {
//                         _editedProduct = Product(
//                           title: _editedProduct.title,
//                           price: _editedProduct.price,
//                           description: value,
//                           imageUrl: _editedProduct.imageUrl,
//                           id: _editedProduct.id,
//                           isFavorite: _editedProduct.isFavorite,
//                         );
//                       },
//                     ),
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: <Widget>[
//                         Container(
//                           width: 100,
//                           height: 100,
//                           margin: EdgeInsets.only(top: 8, right: 10),
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                               width: 1,
//                               color: Colors.grey,
//                             ),
//                           ),
//                           child: _imageUrlController.text.isEmpty
//                               ? Text('Introdusca una URL')
//                               : FittedBox(
//                                   child: Image.network(
//                                     _imageUrlController.text,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                         ),
//                         Expanded(
//                           child: TextFormField(
//                             decoration:
//                                 InputDecoration(labelText: 'URL de la Imagen'),
//                             keyboardType: TextInputType.url,
//                             textInputAction: TextInputAction.done,
//                             controller: _imageUrlController,
//                             focusNode: _imageUrlFocusNode,
//                             onFieldSubmitted: (_) {
//                               _saveForm();
//                             },
//                             validator: (value) {
//                               if (value.isEmpty) {
//                                 return 'Porfavor provea el link de una Imagen para el Producto';
//                               }
//                               if (!value.startsWith('http') ||
//                                   !value.startsWith('https')) {
//                                 return 'Porfavor provea URL Valida';
//                               }
//                               if (value.endsWith('.png') &&
//                                   value.endsWith('.jpg') &&
//                                   value.endsWith('.jpeg')) {
//                                 return 'Porfavor Agrege un formato de foto valido.';
//                               }
//                               return null;
//                             },
//                             onSaved: (value) {
//                               _editedProduct = Product(
//                                 title: _editedProduct.title,
//                                 price: _editedProduct.price,
//                                 description: _editedProduct.description,
//                                 imageUrl: value,
//                                 id: _editedProduct.id,
//                                 isFavorite: _editedProduct.isFavorite,
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//       drawer: AppDrawer(),
//       bottomNavigationBar: Footer(),
//     );
//   }
// }
// }

//Codigo de Profesor

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';
import '../widgets/app_drawer.dart';
import '../screens/user_product_screen.dart';

//Este import es para el footer como widget.
import '../widgets/footer.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findbyId(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl,
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushNamed(UserProductsScreen.routeName);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('A Ocurrido un Error!'),
                content: Text('Algo salio Mal.'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Aceptar'),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  )
                ],
              ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pushNamed(UserProductsScreen.routeName);
      }
    }
    // Navigator.of(context).pushNamed(UserProductsScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Producto'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Porfavor provea un Titulo.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            title: value,
                            price: _editedProduct.price,
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite);
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Porfavor digite un Precio.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Porfavor digite un numero valido.';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Porfavor digite un numero mayor a Zero.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            title: _editedProduct.title,
                            price: double.parse(value),
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite);
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Porfavor digite una Descripción.';
                        }
                        if (value.length < 10) {
                          return 'La descripcion debe al menos tener 10 Caracteres.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          description: value,
                          imageUrl: _editedProduct.imageUrl,
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(
                            top: 8,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Digite una URL para la Imagen')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'URL de la Imagen'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Porfavor digite una URL para la Imagen.';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Favor ingresar una URL valida.';
                              }
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Favor ingresar una URL con formato de Imagen.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                title: _editedProduct.title,
                                price: _editedProduct.price,
                                description: _editedProduct.description,
                                imageUrl: value,
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            drawer: AppDrawer(),
           bottomNavigationBar: Footer(),
    );
  }
}
