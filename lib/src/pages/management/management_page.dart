import 'dart:io';

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../constants/network_api.dart';
import '../../models/product.dart';

class ManagementPage extends StatefulWidget {
  const ManagementPage({Key? key}) : super(key: key);

  @override
  State<ManagementPage> createState() => _ManagementPageState();
}

class _ManagementPageState extends State<ManagementPage> {
  final _form = GlobalKey<FormState>();
  final _widgetStateDemo = GlobalKey<WidgetStateDemoState>();
  var _product = Product(name: "productX", price: 10, stock: 20);
  var _editMode = false;
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    final Object? arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments != null && arguments is Product) {
      _product = arguments;
      _editMode = true;
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Management'),
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                  key: _form,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(labelText: "Name"),
                        initialValue: _product.name,
                        onSaved: (value) => _product.name = value ?? "",
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: "price"),
                        initialValue: formatNumber.format(_product.price),
                         onSaved: (value) => _product.price = int.parse(value?.replaceAll(",", "") ?? "0"),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: "stock"),
                        initialValue: formatNumber.format(_product.stock),
                        onSaved: (value) => _product.stock = int.parse(value?.replaceAll(",", "") ?? "0"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(onPressed: () {
                        _form.currentState?.save();
                        print("${_product.name}, ${_product.price},${_product.stock}");
                        _widgetStateDemo.currentState?.callMe();
                      }, child: Text("Submit")),
                      WidgetStateDemo(key: _widgetStateDemo)
                    ],
                  ))
            ],
          ),
        ));
  }
}
class WidgetStateDemo extends StatefulWidget {
  const WidgetStateDemo({super.key});

  @override
  State<WidgetStateDemo> createState() => WidgetStateDemoState();
}

class WidgetStateDemoState extends State<WidgetStateDemo> {

  callMe(){
    print("CallME");
  }

  @override
  Widget build(BuildContext context) {
    return Text("WidgetStateDemo");
  }
}
