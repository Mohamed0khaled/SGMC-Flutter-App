/// Arabic Text Normalization Utility
/// 
/// Handles inconsistent Arabic text variations by normalizing for comparison
/// while preserving original text for display.
/// 
/// Common issues addressed:
/// - Diacritics (تشكيل): الإسكندرية vs الاسكندرية
/// - Hamza variants: أ, إ, آ → ا
/// - Taa Marbuta: ة → ه
/// - Alef Maqsura: ى → ي
/// - Extra spaces and case differences
class ArabicNormalizer {
  /// Normalizes Arabic text for reliable comparison
  /// 
  /// Usage:
  /// - For equality checks: normalize(text1) == normalize(text2)
  /// - For searching: normalize(query).contains(normalize(target))
  /// - For grouping: Map with normalized keys, original values
  static String normalize(String text) {
    if (text.isEmpty) return text;

    String normalized = text;

    // 1. Remove Arabic diacritics (تشكيل)
    // These include: َ ً ُ ٌ ِ ٍ ْ ّ (fatha, damma, kasra, shadda, sukun, etc.)
    normalized = normalized.replaceAll(RegExp(r'[\u064B-\u065F]'), '');

    // 2. Normalize Hamza variants
    // أ (Alef with Hamza above) → ا
    normalized = normalized.replaceAll('أ', 'ا');
    // إ (Alef with Hamza below) → ا
    normalized = normalized.replaceAll('إ', 'ا');
    // آ (Alef with Madda) → ا
    normalized = normalized.replaceAll('آ', 'ا');
    // ء (Hamza on its own) → remove or keep as is
    // For governorate names, standalone hamza is rare, so we keep it

    // 3. Normalize Alef Maqsura
    // ى (Alef Maqsura) → ي (Yaa)
    normalized = normalized.replaceAll('ى', 'ي');

    // 4. Normalize Taa Marbuta
    // ة (Taa Marbuta) → ه (Haa)
    // This makes الإسكندرية → الاسكندريه
    normalized = normalized.replaceAll('ة', 'ه');

    // 5. Remove extra whitespace
    normalized = normalized.trim();
    normalized = normalized.replaceAll(RegExp(r'\s+'), ' ');

    // 6. Convert to lowercase (for case-insensitive comparison)
    normalized = normalized.toLowerCase();

    return normalized;
  }

  /// Checks if two Arabic texts are equivalent after normalization
  static bool areEqual(String text1, String text2) {
    return normalize(text1) == normalize(text2);
  }

  /// Checks if query matches target after normalization
  static bool contains(String target, String query) {
    return normalize(target).contains(normalize(query));
  }

  /// Groups items by normalized key, preserving first occurrence for display
  /// 
  /// Example:
  /// Input: ["الإسكندرية", "الاسكندريه", "القاهرة"]
  /// Output: {"الاسكندريه": "الإسكندرية", "القاهره": "القاهرة"}
  static Map<String, String> groupByNormalized(List<String> items) {
    final Map<String, String> grouped = {};
    
    for (final item in items) {
      final normalizedKey = normalize(item);
      // Only keep first occurrence (cleaner version usually)
      if (!grouped.containsKey(normalizedKey)) {
        grouped[normalizedKey] = item;
      }
    }
    
    return grouped;
  }
}
