import 'package:flutter/material.dart';

/// App Localizations - Centralized translations
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // Get translations based on current locale
  Map<String, String> get _localizedValues {
    return locale.languageCode == 'ar' ? _arValues : _enValues;
  }

  // Helper method to get translation
  String translate(String key) {
    return _localizedValues[key] ?? key;
  }

  // === App Title ===
  String get appTitle => translate('app_title');

  // === Home Screen ===
  String get selectGovernorate => translate('select_governorate');
  String get chooseLocation => translate('choose_location');
  String get selectGovernorateDesc => translate('select_governorate_desc');
  String get searchProviders => translate('search_providers');
  String get noGovernoratesFound => translate('no_governorates_found');
  String get noGovernoratesDesc => translate('no_governorates_desc');
  String get loadingGovernorates => translate('loading_governorates');

  // === Categories Screen ===
  String get categories => translate('categories');
  String get selectCategory => translate('select_category');
  String get selectCategoryDesc => translate('select_category_desc');
  String get noCategoriesAvailable => translate('no_categories_available');
  String get noCategoriesDesc => translate('no_categories_desc');

  // === Items Screen ===
  String get results => translate('results');
  String get searchInCategory => translate('search_in_category');
  String get noServicesFound => translate('no_services_found');
  String get noServicesDesc => translate('no_services_desc');

  // === Item Details Screen ===
  String get providerInfo => translate('provider_info');
  String get providerName => translate('provider_name');
  String get specialty => translate('specialty');
  String get servicesProvided => translate('services_provided');
  String get location => translate('location');
  String get governorate => translate('governorate');
  String get cityArea => translate('city_area');
  String get address => translate('address');
  String get contactInfo => translate('contact_info');
  String get phone => translate('phone');
  String get email => translate('email');

  // === Settings Screen ===
  String get settings => translate('settings');
  String get language => translate('language');
  String get themeMode => translate('theme_mode');
  String get aboutDeveloper => translate('about_developer');
  String get lightMode => translate('light_mode');
  String get darkMode => translate('dark_mode');
  String get systemMode => translate('system_mode');

  // === Language Selection Screen ===
  String get selectLanguage => translate('select_language');
  String get selectLanguageDesc => translate('select_language_desc');
  String get arabic => translate('arabic');
  String get english => translate('english');
  String get continues => translate('continue');

  // === Empty States ===
  String get noDataAvailable => translate('no_data_available');
  String get noDataDesc => translate('no_data_desc');
  String get noResultsFound => translate('no_results_found');
  String get noResultsDesc => translate('no_results_desc');
  String get searchOffMessage => translate('search_off_message');

  // === Common ===
  String get retry => translate('retry');
  String get back => translate('back');
  String get done => translate('done');
  String get cancel => translate('cancel');

  // English Translations
  static const Map<String, String> _enValues = {
    'app_title': 'SGMC Services',
    
    // Home Screen
    'select_governorate': 'Select Governorate',
    'choose_location': 'Choose Your Location',
    'select_governorate_desc': 'Select a governorate to view available services',
    'search_providers': 'Search providers, specialties, areas...',
    'no_governorates_found': 'No Governorates Found',
    'no_governorates_desc': 'There are no governorates available at the moment.',
    'loading_governorates': 'Loading governorates...',
    
    // Categories Screen
    'categories': 'Categories',
    'select_category': 'Select Category',
    'select_category_desc': 'Choose a provider type to view services',
    'no_categories_available': 'No Categories Available',
    'no_categories_desc': 'No provider types found for this governorate.',
    
    // Items Screen
    'results': 'Results',
    'search_in_category': 'Search in this category...',
    'no_services_found': 'No services found',
    'no_services_desc': 'No services available in this category.',
    
    // Item Details
    'provider_info': 'Provider Information',
    'provider_name': 'Provider Name',
    'specialty': 'Specialty',
    'services_provided': 'Services Provided',
    'location': 'Location',
    'governorate': 'Governorate',
    'city_area': 'City / Area',
    'address': 'Address',
    'contact_info': 'Contact Information',
    'phone': 'Phone',
    'email': 'Email',
    
    // Settings
    'settings': 'Settings',
    'language': 'Language',
    'theme_mode': 'Theme Mode',
    'about_developer': 'About Developer',
    'light_mode': 'Light',
    'dark_mode': 'Dark',
    'system_mode': 'System',
    
    // Language Selection
    'select_language': 'Select Language',
    'select_language_desc': 'Choose your preferred language',
    'arabic': 'العربية',
    'english': 'English',
    'continue': 'Continue',
    
    // Empty States
    'no_data_available': 'No Data Available',
    'no_data_desc': 'Please refresh or contact support if the issue persists.',
    'no_results_found': 'No Results Found',
    'no_results_desc': 'Try adjusting your search query.',
    'search_off_message': 'Try adjusting your search query.',
    
    // Common
    'retry': 'Retry',
    'back': 'Back',
    'done': 'Done',
    'cancel': 'Cancel',
  };

  // Arabic Translations
  static const Map<String, String> _arValues = {
    'app_title': 'خدمات SGMC',
    
    // Home Screen
    'select_governorate': 'اختر المحافظة',
    'choose_location': 'اختر موقعك',
    'select_governorate_desc': 'اختر محافظة لعرض الخدمات المتاحة',
    'search_providers': 'ابحث عن مقدمي الخدمة، التخصصات، المناطق...',
    'no_governorates_found': 'لا توجد محافظات',
    'no_governorates_desc': 'لا توجد محافظات متاحة في الوقت الحالي.',
    'loading_governorates': 'جاري تحميل المحافظات...',
    
    // Categories Screen
    'categories': 'الفئات',
    'select_category': 'اختر الفئة',
    'select_category_desc': 'اختر نوع مقدم الخدمة لعرض الخدمات',
    'no_categories_available': 'لا توجد فئات متاحة',
    'no_categories_desc': 'لم يتم العثور على أنواع مقدمي خدمات لهذه المحافظة.',
    
    // Items Screen
    'results': 'النتائج',
    'search_in_category': 'ابحث في هذه الفئة...',
    'no_services_found': 'لم يتم العثور على خدمات',
    'no_services_desc': 'لا توجد خدمات متاحة في هذه الفئة.',
    
    // Item Details
    'provider_info': 'معلومات مقدم الخدمة',
    'provider_name': 'اسم مقدم الخدمة',
    'specialty': 'التخصص',
    'services_provided': 'الخدمات المقدمة',
    'location': 'الموقع',
    'governorate': 'المحافظة',
    'city_area': 'المدينة / المنطقة',
    'address': 'العنوان',
    'contact_info': 'معلومات الاتصال',
    'phone': 'الهاتف',
    'email': 'البريد الإلكتروني',
    
    // Settings
    'settings': 'الإعدادات',
    'language': 'اللغة',
    'theme_mode': 'وضع المظهر',
    'about_developer': 'عن المطور',
    'light_mode': 'فاتح',
    'dark_mode': 'داكن',
    'system_mode': 'النظام',
    
    // Language Selection
    'select_language': 'اختر اللغة',
    'select_language_desc': 'اختر لغتك المفضلة',
    'arabic': 'العربية',
    'english': 'English',
    'continue': 'متابعة',
    
    // Empty States
    'no_data_available': 'لا توجد بيانات متاحة',
    'no_data_desc': 'يرجى التحديث أو الاتصال بالدعم إذا استمرت المشكلة.',
    'no_results_found': 'لم يتم العثور على نتائج',
    'no_results_desc': 'حاول تعديل استعلام البحث.',
    'search_off_message': 'حاول تعديل استعلام البحث.',
    
    // Common
    'retry': 'إعادة المحاولة',
    'back': 'رجوع',
    'done': 'تم',
    'cancel': 'إلغاء',
  };
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
