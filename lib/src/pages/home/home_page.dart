import 'package:demo1/src/bloc/auth/auth_bloc.dart';
import 'package:demo1/src/bloc/home/home_bloc.dart';
import 'package:demo1/src/pages/home/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/asset.dart';
import '../../models/product.dart';
import '../app_routes.dart';
import 'widgets/dialog_barcode_image.dart';
import 'widgets/dialog_qr_image.dart';
import 'widgets/dialog_scan_qrcode.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  initState() {
    super.initState();
    context.read<HomeBloc>().add(HomeEventFetch());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          actions: [
            IconButton(onPressed: () {
              context.read<HomeBloc>().add(HomeEventToggleDisplay());
            }, icon: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                return Icon(state.isGrid ? Icons.grid_3x3 : Icons.list);
              },
            )),
          ],
        ),
        drawer: const CustomDrawer(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _navigateManagementPage(),
          child: const Icon(Icons.add),
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            final products = state.products;
            return RefreshIndicator(
              onRefresh: () async =>
                  context.read<HomeBloc>().add(HomeEventFetch()),
              child: state.status == FetchStatus.fetching
                  ? _buildLoadingView()
                  : Container(
                      child: state.isGrid
                          ? _buildGridView(products)
                          : _buildListView(products),
                    ),
            );
          },
        ));
  }

  _buildLoadingView() => Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Text("Loading ..."));

  Widget _buildGridView(List<Product> products) {
    return Container(
      color: Colors.black,
      child: GridView.builder(
        padding: const EdgeInsets.only(top: 10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
          childAspectRatio:
              0.75, // set height ratio -  (itemWidth / itemHeight)
        ),
        itemBuilder: (context, index) {
          return ProductItem(
            isGrid: true,
            product: products[index],
            onTap: () => {_navigateManagementPage(products[index])},
            onTapPrice: () => {print(products[index].price)},
          );
        },
        itemCount: products.length,
      ),
    );
  }

  _navigateManagementPage([Product? product]) async {
    await Navigator.pushNamed(context, AppRoute.management, arguments: product);
    context.read<HomeBloc>().add(HomeEventFetch());
  }

  Widget _buildListView(List<Product> products) {
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: [
              _buildHeader(),
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                child: SizedBox(
                  height: 350,
                  child: ProductItem(
                    product: products[index],
                    onTap: () => {_navigateManagementPage(products[index])},
                    onTapPrice: () => {print(products[index].price)},
                  ),
                ),
              ),
            ],
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: SizedBox(
              height: 350,
              child: ProductItem(
                product: products[index],
                onTap: () => {_navigateManagementPage(products[index])},
                onTapPrice: () => {print(products[index].price)},
              ),
            ),
          );
        }
      },
      itemCount: products.length,
    );
  }

  _buildHeader() {
    return Image.asset(Asset.logoImage);
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
      builder: (BuildContext dialogContext) =>
          const DialogBarcodeImage('www.codemobiles.com'),
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
            onTap: () => print("Stock"),
            leading: const Icon(
              Icons.add_box_rounded,
              color: Colors.deepPurple,
            ),
            trailing: Text("(120)"),
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
            onTap: () => context.read<AuthBloc>().add(AuthEventLogout()),
          ),
        ),
      );
}
