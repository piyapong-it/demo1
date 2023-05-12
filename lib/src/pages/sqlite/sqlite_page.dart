import 'package:demo1/src/pages/sqlite/widgets/CMTextForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SQLitePage extends StatefulWidget {
  const SQLitePage({Key? key}) : super(key: key);

  @override
  State<SQLitePage> createState() => _SQLitePageState();
}

class _SQLitePageState extends State<SQLitePage> {
  final _form = GlobalKey<FormState>();
  final _sqliteModel = SqliteModel("", 0, 0);

  @override
  void initState() {
    super.initState();
    setupDatabase();
  }

  Future<void> setupDatabase() async {
    await DatabaseService().open();
    context.read<SqliteBloc>().add(SqliteEventQuery());
  }

  @override
  void dispose() {
    super.dispose();
    DatabaseService().close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('SQLite (Optional)'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Card(
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _form,
                    child: SizedBox(
                      height: 270,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                        CMTextForm(
                          initialValue: "ReactJS",
                          label: "Name",
                          onSave: (newValue) => _sqliteModel.name = newValue,
                        ),
                        CMTextForm(
                          initialValue: "10",
                          label: "Price",
                          onSave: (newValue) => _sqliteModel.price = double.parse(newValue),
                        ),
                        CMTextForm(
                          initialValue: "200",
                          label: "Stock",
                          onSave: (newValue) => _sqliteModel.stock = double.parse(newValue),
                        ),
                        const SizedBox(height: 20),
                        BlocBuilder<SqliteBloc, SqliteState>(builder: (context, state) {
                          return ElevatedButton(
                              onPressed: state.status == SqliteStatus.fetching ? null : _handleClickSaveBtn,
                              child: Text(state.status == SqliteStatus.fetching ? "Loading..." : "Save"));
                        })
                      ]),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: BlocBuilder<SqliteBloc, SqliteState>(
                  builder: (context, state) {
                    return ListView.builder(
                      itemCount: state.historyArray.length,
                      itemBuilder: (context, index) {
                        final name = state.historyArray[index]["name"];
                        final price = state.historyArray[index]["price"];
                        final stock = state.historyArray[index]["stock"];
                        return Row(
                          children: [
                            Expanded(child: Text(name)),
                            Expanded(child: Text(price.toString() + " บาท")),
                            Expanded(child: Text(stock.toString() + " ชิ้น")),
                          ],
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ));
  }

  void _handleClickSaveBtn() {
    _form.currentState?.save();
    context.read<SqliteBloc>().add(SqliteEventInsert(_sqliteModel));
  }

  void _handleClickQueryBtn() {
    context.read<SqliteBloc>().add(SqliteEventQuery());
  }
}
