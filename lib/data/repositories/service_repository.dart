import 'package:sgmc_app/data/data_sources/local_data_source.dart';
import 'package:sgmc_app/data/models/item_model.dart';

class ServiceRepository {
  final LocalDataSource localDataSource;

  ServiceRepository(this.localDataSource);

  Future<List<ItemModel>> getAllItems({String? languageCode}) {
    return localDataSource.loadItems(languageCode: languageCode);
  }

  /// Get unique governorates from items
  List<String> getGovernorates(List<ItemModel> items) {
    return items
        .map((e) => e.governorate)
        .where((gov) => gov.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
  }

  /// Get provider types for a specific governorate
  /// Uses normalized comparison (case-insensitive, trimmed)
  List<String> getProviderTypes(List<ItemModel> items, String governorate) {
    final normalizedGov = _normalize(governorate);
    return items
        .where((e) => _normalize(e.governorate) == normalizedGov)
        .map((e) => e.providerType)
        .where((type) => type.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
  }

  /// Get items filtered by governorate and provider type
  List<ItemModel> getItemsByProviderType({
    required List<ItemModel> items,
    required String governorate,
    required String providerType,
  }) {
    final normalizedGov = _normalize(governorate);
    final normalizedType = _normalize(providerType);

    return items.where((item) {
      return _normalize(item.governorate) == normalizedGov &&
          _normalize(item.providerType) == normalizedType;
    }).toList();
  }

  /// Normalize string for comparison (lowercase + trim)
  String _normalize(String value) {
    return value.trim().toLowerCase();
  }

  Map<String, List<ItemModel>> groupItemsByArea(List<ItemModel> items) {
    final Map<String, List<ItemModel>> grouped = {};

    for (final item in items) {
      final area = item.city.trim().isEmpty ? 'Unknown Area' : item.city.trim();

      grouped.putIfAbsent(area, () => []);
      grouped[area]!.add(item);
    }

    return grouped;
  }

  List<ItemModel> searchItems({
    required List<ItemModel> items,
    required String query,
  }) {
    if (query.trim().isEmpty) return items;

    final q = query.toLowerCase().trim();

    return items.where((item) {
      return item.name.toLowerCase().contains(q) ||
          item.specialty.toLowerCase().contains(q) ||
          item.city.toLowerCase().contains(q) ||
          item.governorate.toLowerCase().contains(q);
    }).toList();
  }
}
