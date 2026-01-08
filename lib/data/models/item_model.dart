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

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      name: _extractAndNormalize(json, ['TATSH Names', 'مقدم الخدمة']),
      governorate: _extractAndNormalize(json, ['Governate', 'المحافظة']),
      city: _extractAndNormalize(json, ['Area / City', 'المنطقة / المدينة']),
      address: _extractAndNormalize(json, ['Address ', 'العنوان']),
      specialty: _extractAndNormalize(json, ['Specialty', 'التخصص']),
      services: _extractAndNormalize(json, ['Services provided', 'الخدمات المقدمة']),
      providerType: _extractAndNormalize(json, ['Provider Type', 'نوع مقدم الخدمة']),
      phone: _extractAndNormalize(json, ['Tel. no. - التليفون']),
      email: _extractAndNormalize(json, ['E-MAIL - البريدالإلكتروني']),
    );
  }

  /// Extract value from multiple possible keys and normalize it
  static String _extractAndNormalize(
    Map<String, dynamic> json,
    List<String> possibleKeys,
  ) {
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
