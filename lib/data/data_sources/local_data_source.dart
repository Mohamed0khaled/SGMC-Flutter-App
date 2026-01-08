import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sgmc_app/data/models/item_model.dart';


class LocalDataSource {
  Future<List<ItemModel>> loadItems() async {
    final jsonString =
        await rootBundle.loadString('assets/data/services.json');

    final List decoded = json.decode(jsonString);

    return decoded.map((e) => ItemModel.fromJson(e)).toList();
  }
}
