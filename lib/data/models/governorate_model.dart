import 'category_model.dart';

class GovernorateModel {
  final String name;
  final List<CategoryModel> categories;

  const GovernorateModel({
    required this.name,
    required this.categories,
  });

  factory GovernorateModel.fromJson(Map<String, dynamic> json) {
    final categoriesJson = json['categories'] as List;

    return GovernorateModel(
      name: json['name'] as String,
      categories: categoriesJson
          .map((cat) => CategoryModel.fromJson(cat))
          .toList(),
    );
  }
}
