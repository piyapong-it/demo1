import 'dart:convert';

import 'package:demo1/src/bloc/auth/auth_bloc.dart';
import 'package:demo1/src/models/product.dart';
import 'package:demo1/src/pages/app_routes.dart';
import 'package:demo1/src/pages/home/widgets/dialog_barcode_image.dart';
import 'package:demo1/src/pages/home/widgets/dialog_qr_image.dart';
import 'package:demo1/src/pages/home/widgets/dialog_scan_qrcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import '../../constants/asset.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> products = [];
  @override
  initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    // final result = await dio.get("http://10.11.50.229:1150/products");
    // products = productFromJson(jsonEncode(result.data));
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("HomePage"),
        ),
        drawer: CustomDrawer(),
        body: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(" - " + products[index].name, style: TextStyle(fontSize: 10),),
            );
          },
        ));
  }
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    Key? key,
  }) : super(key: key);

  void _showDialogBarcode(context) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) => const DialogBarcodeImage(
        'www.codemobiles.com',
      ),
    );
  }

  void _showDialogQRImage(context) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) => const DialogQRImage(
        'www.codemobiles.com',
        image: Asset.pinBikerImage,
      ),
    );
  }

  void _showScanQRCode(context) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) => const DialogScanQRCode(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _buildProfile(),
          ListTile(
            onTap: () {},
            leading: Icon(
              Icons.add_box_rounded,
              color: Colors.deepPurple,
            ),
            trailing: Text("120"),
            title: Text("Stock"),
          ),
          ListTile(
            onTap: () => _showDialogBarcode(context),
            title: const Text("BarCode"),
            leading:
                const Icon(Icons.bar_chart_outlined, color: Colors.deepOrange),
          ),
          ListTile(
            onTap: () => _showDialogQRImage(context),
            title: const Text("QRCode"),
            leading: const Icon(Icons.qr_code, color: Colors.green),
          ),
          ListTile(
            onTap: () => _showScanQRCode(context),
            title: const Text("Scanner"),
            leading: const Icon(Icons.qr_code_scanner, color: Colors.blueGrey),
          ),
          ListTile(
            onTap: () => Navigator.pushNamed(context, AppRoute.map),
            title: const Text("Map"),
            leading: const Icon(Icons.map_outlined, color: Colors.blue),
          ),
          ListTile(
            onTap: () => Navigator.pushNamed(context, AppRoute.sqlite),
            title: const Text("SQLite3 (Option)"),
            leading: const Icon(Icons.table_rows_sharp, color: Colors.blue),
          ),
          const Spacer(),
          _buildLogoutButton(),
        ],
      ),
    );
  }

  UserAccountsDrawerHeader _buildProfile() => UserAccountsDrawerHeader(
        currentAccountPicture: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const CircleAvatar(
            backgroundImage: AssetImage(Asset.cmLogoImage),
          ),
        ),
        accountName: const Text('CMDev'),
        accountEmail: const Text('support@codemobiles.com'),
      );

  Builder _buildLogoutButton() => Builder(
        builder: (context) => SafeArea(
          child: ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Log out'),
              onTap: () => context.read<AuthBloc>().add(AuthEventLogout())),
        ),
      );
}
