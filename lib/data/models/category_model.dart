import 'package:sgmc_app/data/models/item_model.dart';

class CategoryModel {
  final String name;
  final List<ItemModel> items;

  CategoryModel({required this.name, required this.items});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List;

    return CategoryModel(
      name: json['name'] as String,
      items: itemsJson
          .map((item) => ItemModel.fromJson(item))
          .toList(),
    );
  }
}
