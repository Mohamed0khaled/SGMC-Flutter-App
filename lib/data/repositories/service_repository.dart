import 'package:sgmc_app/core/utils/arabic_normalizer.dart';
import 'package:sgmc_app/data/data_sources/local_data_source.dart';
import 'package:sgmc_app/data/models/item_model.dart';

class ServiceRepository {
  final LocalDataSource localDataSource;

  ServiceRepository(this.localDataSource);

  Future<List<ItemModel>> getAllItems({String? languageCode}) {
    return localDataSource.loadItems(languageCode: languageCode);
  }

  /// Get unique governorates from items
  /// Returns deduplicated list using Arabic normalization
  /// Example: "الإسكندرية", "الاسكندريه" → single "الإسكندرية"
  List<String> getGovernorates(List<ItemModel> items) {
    // Collect all governorate names
    final allGovernorates = items
        .map((e) => e.governorate)
        .where((gov) => gov.isNotEmpty)
        .toList();

    // Group by normalized key, keep first occurrence for display
    final grouped = ArabicNormalizer.groupByNormalized(allGovernorates);

    // Return unique display values, sorted
    final uniqueGovernorates = grouped.values.toSet().toList()..sort();
    
    return uniqueGovernorates;
  }

  /// Get provider types for a specific governorate
  /// Uses Arabic normalization for comparison
  List<String> getProviderTypes(List<ItemModel> items, String governorate) {
    final normalizedGov = ArabicNormalizer.normalize(governorate);
    
    return items
        .where((e) => ArabicNormalizer.normalize(e.governorate) == normalizedGov)
        .map((e) => e.providerType)
        .where((type) => type.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
  }

  /// Get items filtered by governorate and provider type
  /// Uses Arabic normalization for governorate comparison
  List<ItemModel> getItemsByProviderType({
    required List<ItemModel> items,
    required String governorate,
    required String providerType,
  }) {
    final normalizedGov = ArabicNormalizer.normalize(governorate);
    final normalizedType = _normalize(providerType);

    return items.where((item) {
      return ArabicNormalizer.normalize(item.governorate) == normalizedGov &&
          _normalize(item.providerType) == normalizedType;
    }).toList();
  }

  /// Normalize string for comparison (lowercase + trim)
  /// Used for non-Arabic text like provider types
  String _normalize(String value) {
    return value.trim().toLowerCase();
  }

  /// Group items by area/city
  Map<String, List<ItemModel>> groupItemsByArea(List<ItemModel> items) {
    final Map<String, List<ItemModel>> grouped = {};

    for (final item in items) {
      final area = item.city.trim().isEmpty ? 'Unknown Area' : item.city.trim();

      grouped.putIfAbsent(area, () => []);
      grouped[area]!.add(item);
    }

    return grouped;
  }

  /// Search items across multiple fields
  /// Uses Arabic normalization for reliable matching
  List<ItemModel> searchItems({
    required List<ItemModel> items,
    required String query,
  }) {
    if (query.trim().isEmpty) return items;

    final normalizedQuery = ArabicNormalizer.normalize(query);

    return items.where((item) {
      // Use Arabic normalization for Arabic fields
      return ArabicNormalizer.contains(item.name, query) ||
          ArabicNormalizer.contains(item.specialty, query) ||
          ArabicNormalizer.contains(item.city, query) ||
          ArabicNormalizer.contains(item.governorate, query) ||
          // Also check services field
          ArabicNormalizer.contains(item.services, query);
    }).toList();
  }
}
