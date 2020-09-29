import 'dart:convert';
import '../modals/modal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DbProvider with ChangeNotifier {
  List<CUR> _items = [];
  var base;
  String date;
  List<CUR> get items {
    return [..._items];
  }

  Future<void> refresh() async {
    print("object");
    final updateResultsUrl = 'https://api.exchangeratesapi.io/latest';

    try {
      await http.put(updateResultsUrl,
          body: json.encode(
              {'date': DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()}));
         
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchData() async {
    _items = [];
    print('object');
    final url = 'https://api.exchangeratesapi.io/latest';
    try {
      final response = await http.get(url);
      print("response");
      final extractedData =
          await json.decode(response.body) as Map<String, dynamic>;
      print(extractedData);
      print('zxzxzx');
      extractedData.forEach((key, val) {
        if (key == "base") {
          base = val;
        }
        if (key == "date") {
          date = val;
        }
        if (key == "rates") {
          val.forEach((country, val) {
            _items.add(CUR(
              s: country,
              i: val,
            ));
          });
        }
      });
      print("sadasfasdf");
      print(items);

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
