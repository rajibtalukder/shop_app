import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    title: '',
    description: '',
    price: 0,
    imgUrl: '',
    id: null,
  );
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imgUrl': '',
  };
  var _isInit = true;
  var isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments as String?;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imgUrl': '',
        };
        _imageUrlController.text = _editedProduct.imgUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      isLoading = true;
    });
    if (_editedProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduuct(_editedProduct.id.toString(), _editedProduct);
      Navigator.of(context).pop();
      setState(() {
        isLoading = false;
      });
      //print('update method ');
    } else {
      try{
        await Provider.of<Products>(context, listen: false)
          .addProduct(_editedProduct);
      }catch(error){
         // ignore: prefer_void_to_null
         await showDialog<Null>(
          context: context,
          builder: ((ctx) => AlertDialog(
                title: Text(
                  'Warning...!',
                  style: TextStyle(color: Theme.of(context).errorColor),
                ),
                content: Text(
                  error.toString(),
                  style: TextStyle(color: Theme.of(context).errorColor),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: const Text('Ok'))
                ],
              )),
        );
      }
      finally{
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
      }
          
        
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit product'),
          actions: [
            Tooltip(
              message: 'Save',
              child: IconButton(
                icon: const Icon(Icons.save),
                onPressed: _saveForm,
              ),
            )
          ],
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                    autovalidateMode: AutovalidateMode.always,
                    key: _form,
                    child: ListView(children: [
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: const InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: ((_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        }),
                        onSaved: (value) {
                          _editedProduct = Product(
                            title: value.toString(),
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imgUrl: _editedProduct.imgUrl,
                            id: _editedProduct.id,
                            isFavourite: _editedProduct.isFavourite,
                          );
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter value on field';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],
                        decoration: const InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: ((_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        }),
                        onSaved: (value) {
                          _editedProduct = Product(
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: double.parse(value.toString()),
                            imgUrl: _editedProduct.imgUrl,
                            id: _editedProduct.id,
                            isFavourite: _editedProduct.isFavourite,
                          );
                        },
                        // validator: (value) {
                        //   if (value!.isEmpty) {
                        //     return 'Please enter value on field';
                        //   }
                        //   return null;
                        // },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter value on field';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a number';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Please enter number which is gretter than zero';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['description'],
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                        maxLines: 2,
                        textInputAction: TextInputAction.newline,
                        focusNode: _descriptionFocusNode,
                        onSaved: (value) {
                          _editedProduct = Product(
                            title: _editedProduct.title,
                            description: value.toString(),
                            price: _editedProduct.price,
                            imgUrl: _editedProduct.imgUrl,
                            id: _editedProduct.id,
                            isFavourite: _editedProduct.isFavourite,
                          );
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter value on field';
                          }
                          if (value.length < 10) {
                            return 'Character is too short';
                          }
                          return null;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            margin: const EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            child: _imageUrlController.text.isEmpty
                                ? const Text('No Image')
                                : FittedBox(
                                    //fit: BoxFit.cover,
                                    child:
                                        Image.network(_imageUrlController.text),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Enter image URL'),
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                controller: _imageUrlController,
                                focusNode: _imageUrlFocusNode,
                                onEditingComplete: () {
                                  setState(() {});
                                },
                                onSaved: (value) {
                                  _editedProduct = Product(
                                    title: _editedProduct.title,
                                    description: _editedProduct.description,
                                    price: _editedProduct.price,
                                    imgUrl: value.toString(),
                                    id: _editedProduct.id,
                                    isFavourite: _editedProduct.isFavourite,
                                  );
                                },
                                validator: ((value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter an ImageUrl';
                                  }
                                  if (!value.startsWith('http') &&
                                      !value.startsWith('https')) {
                                    return 'Please enter a valid ImageUrl..';
                                  }
                                  if (!value.endsWith('.png') &&
                                      !value.endsWith('.jpg') &&
                                      !value.endsWith('jpeg')) {
                                    return 'Please enter a image which in png/jpg/jpeg file';
                                  }
                                  return null;
                                }),
                                onFieldSubmitted: (_) {
                                  _saveForm();
                                }),
                          )
                        ],
                      )
                    ])),
              ));
  }
}
