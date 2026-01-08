class ItemModel {
  final String name;
  final String governorate;
  final String city;
  final String address;
  final String specialty;
  final String services;
  final String providerType;
  final String phone;
  final String email;

  const ItemModel({
    required this.name,
    required this.governorate,
    required this.city,
    required this.address,
    required this.specialty,
    required this.services,
    required this.providerType,
    required this.phone,
    required this.email,
  });

  factory ItemModel.fromJson(
    Map<String, dynamic> json, {
    String? languageCode,
  }) {
    return ItemModel(
      name: _extractAndNormalize(json, [
        'TATSH Names',
        'مقدم الخدمة',
      ], languageCode),
      governorate: _extractAndNormalize(json, [
        'Governate',
        'المحافظة',
      ], languageCode),
      city: _extractAndNormalize(json, [
        'Area / City',
        'المنطقة / المدينة',
      ], languageCode),
      address: _extractAndNormalize(json, [
        'Address ',
        'العنوان',
      ], languageCode),
      specialty: _extractAndNormalize(json, [
        'Specialty',
        'التخصص',
      ], languageCode),
      services: _extractAndNormalize(json, [
        'Services provided',
        'الخدمات المقدمة',
      ], languageCode),
      providerType: _extractAndNormalize(json, [
        'Provider Type',
        'نوع مقدم الخدمة',
      ], languageCode),
      phone: _extractAndNormalize(json, ['Tel. no. - التليفون']),
      email: _extractAndNormalize(json, ['E-MAIL - البريدالإلكتروني']),
    );
  }

  /// Create ItemModel with specific language
  factory ItemModel.withLanguage(
    Map<String, dynamic> json,
    String languageCode,
  ) {
    return ItemModel.fromJson(json, languageCode: languageCode);
  }

  /// Extract value from multiple possible keys and normalize it
  /// If languageCode is provided, prefer that language's key
  static String _extractAndNormalize(
    Map<String, dynamic> json,
    List<String> possibleKeys, [
    String? languageCode,
  ]) {
    // If language preference is specified, try that language first
    if (languageCode != null) {
      final preferredIndex = languageCode == 'ar' ? 1 : 0;
      if (preferredIndex < possibleKeys.length) {
        final preferredKey = possibleKeys[preferredIndex];
        final value = json[preferredKey];
        if (value != null) {
          final stringValue = value.toString().trim();
          if (stringValue.isNotEmpty) {
            return stringValue
                .replaceAll('\n', ' ')
                .replaceAll(RegExp(r'\s+'), ' ')
                .trim();
          }
        }
      }
    }

    // Fallback: try all keys in order
    for (final key in possibleKeys) {
      final value = json[key];
      if (value != null) {
        final stringValue = value.toString().trim();
        if (stringValue.isNotEmpty) {
          return stringValue
              .replaceAll('\n', ' ')
              .replaceAll(RegExp(r'\s+'), ' ')
              .trim();
        }
      }
    }
    return '';
  }
}
