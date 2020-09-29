import 'package:ExchangeRates/providers/db.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../modals/modal.dart';

class MyHomePage extends StatefulWidget {
  static const routeName = 'home';

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _isInit = false;
  var _isLoading = false;
  var _refreshing=false;
  String _base = "";
  String _date = "";
  var inputValue;
  List<CUR> _fetchedList = [];
  List<DataRow> cells = [];
  @override
  void didChangeDependencies() {
    if (!_isInit) {
      setState(
        () {
          _isLoading = true;
        },
      );

      Provider.of<DbProvider>(context, listen: true).fetchData().then((value) {
        _fetchedList = Provider.of<DbProvider>(context, listen: true).items;
        _base = Provider.of<DbProvider>(context, listen: true).base;
        _date = Provider.of<DbProvider>(context, listen: true).date;
      }).then((_) {
        setState(
          () {
            _isLoading = false;
          },
        );
      });
    }
    _isInit = true;
    super.didChangeDependencies();
  }

  final _form = GlobalKey<FormState>();
  Future<void> _saveform() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    print(inputValue);

    cells = [];
    setState(() {
      print(inputValue);
      _fetchedList.forEach((element) {
        cells.add(DataRow(cells: [
          DataCell(Text(
            element.s.toString(),
            style: TextStyle(fontSize: 22, color: Colors.indigo),
          )),
          DataCell(Text(((element.i) * int.parse(inputValue)).toString(),
              style: TextStyle(fontSize: 20)))
        ]));
      });
    });
  }
  Future<void> _refresh() async {
setState(() {
      _refreshing = true;
    });
    await Provider.of<DbProvider>(context, listen: true).refresh();
    setState(() {
      _date=DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
      _refreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          FlatButton(
              onPressed: () {
                _refresh();
              },
              child:_refreshing?CircularProgressIndicator(): Text(
                "Refresh",
                style: TextStyle(color: Colors.white),
              ))
        ],
        backgroundColor: Colors.purple,
        title:_refreshing?CircularProgressIndicator(): Text(_base + "\n" + _date),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Form(
                      key: _form,
                      child: Column(
                        children: [
                          Container(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Enter value'),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "You must enter some value";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                inputValue = value;
                              },
                            ),
                          ),
                          FlatButton(
                              onPressed: () {
                                _saveform();
                              },
                              child: Text("change",style: TextStyle(color: Colors.white),),color: Colors.purple,)
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    height: 10,
                  ),
                  SingleChildScrollView(
                    child: Center(

                        // decoration: BoxDecoration(color: Colors.grey),
                        child: Column(
                      children: <Widget>[
                        Container(
                          height: 400,
                          child: SingleChildScrollView(
                            child: DataTable(columns: [
                              DataColumn(
                                  label: Text(
                                'CUR',
                                style: TextStyle(fontSize: 20),
                              )),
                              DataColumn(
                                  label: Text(
                                'value',
                                style: TextStyle(fontSize: 20),
                              ))
                            ], rows: cells),
                          ),
                        ),
                      ],
                    )),
                  ),
                ],
              ),
            ),
    );
  }
}
