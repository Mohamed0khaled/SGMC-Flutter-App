# SGMC - Medical Services Directory

A comprehensive Flutter application for browsing medical service providers with full Arabic/English localization support.

![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)
![License](https://img.shields.io/badge/License-Private-red.svg)

## 🌟 Features

### Core Functionality
- **Dual Language Support**: Complete Arabic and English localization with RTL support
- **Medical Services Directory**: Browse 4365+ medical service providers across Egypt
- **Advanced Search**: Global and category-specific search with Arabic text normalization
- **Contact Integration**: Direct phone dialer and email app integration
- **Dark Mode**: Full theme support with automatic color adaptation

### User Experience
- **First Launch Setup**: Language selection screen on first app open
- **Settings Screen**: Easy language and theme switching without app restart
- **Hierarchical Navigation**: Governorate → Category → Provider → Details
- **Real-time Updates**: Language changes apply immediately without restart
- **Responsive Design**: Optimized for both portrait and landscape modes

### Technical Highlights
- **Clean Architecture**: Separation of concerns with data, logic, and presentation layers
- **State Management**: BLoC/Cubit pattern for predictable state management
- **Arabic Normalization**: Handles variant spellings (الإسكندرية, الاسكندريه → single entry)
- **Persistent Settings**: SharedPreferences for user preferences
- **Material 3 Design**: Modern UI with professional theme system

## 🏗️ Architecture

### Project Structure
```
lib/
├── core/
│   ├── localization/          # i18n implementation
│   ├── theme/                 # Theme system
│   └── utils/                 # Utilities (Arabic normalizer)
├── data/
│   ├── data_sources/          # Data layer
│   ├── models/                # Data models
│   └── repositories/          # Repository pattern
├── logic/
│   └── cubits/                # State management (BLoC/Cubit)
├── presentation/
│   ├── screens/               # UI screens
│   └── widgets/               # Reusable components
└── main.dart                  # App entry point
```

### Design Patterns
- **Repository Pattern**: Abstracts data sources
- **BLoC Pattern**: Separates business logic from UI
- **Clean Architecture**: Clear separation of layers
- **Dependency Injection**: Loose coupling between components

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / VS Code
- iOS development setup (for iOS builds)

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/Mohamed0khaled/SGMC-Flutter-App.git
cd sgmc_app
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
flutter run
```

### Building for Production

**Android APK**
```bash
flutter build apk --release
```

**Android App Bundle**
```bash
flutter build appbundle --release
```

**iOS**
```bash
flutter build ios --release
```

## 📦 Dependencies

### Production Dependencies
```yaml
dependencies:
  flutter_bloc: ^9.1.1          # State management
  equatable: ^2.0.8             # Value equality
  url_launcher: ^6.3.2          # External URL/phone/email
  shared_preferences: ^2.5.4    # Persistent storage
  flutter_localizations:        # Localization support
```

### Development Dependencies
```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.14.2  # App icon generation
  flutter_lints: ^5.0.0             # Linting rules
```

## 🌐 Localization

### Supported Languages
- **Arabic (العربية)**: Full RTL support
- **English**: Complete translations

### Arabic Text Normalization

The app includes sophisticated Arabic text normalization to handle variant spellings:

```dart
// These are treated as the same governorate:
"الإسكندرية"  // Original with diacritics
"الاسكندريه"  // Without diacritics, ه ending
"الأسكندرية"  // Different hamza position
```

**Normalization Rules:**
- Removes diacritics (تشكيل)
- Normalizes Hamza variants (أ, إ, آ → ا)
- Normalizes Taa Marbuta (ة → ه)
- Normalizes Alef Maqsura (ى → ي)
- Trims whitespace and converts to lowercase

## 🎨 Theming

### Color Scheme

**Light Theme**
- Primary: Material Blue 700 (#1976D2)
- Secondary: Teal 600 (#00897B)
- Background: Light Gray-Blue (#F5F7FA)

**Dark Theme**
- Primary: Material Blue 400 (#42A5F5)
- Secondary: Teal 300 (#4DB6AC)
- Background: Dark Gray (#121212)

## 📊 Data Structure

### JSON Format
```json
{
  "Governorate": ["Arabic Name", "English Name"],
  "ProviderType": ["نوع المزود", "Provider Type"],
  "Name": ["الاسم بالعربي", "English Name"],
  "Specialty": ["التخصص", "Specialty"],
  "Phone": "0123456789",
  "Email": "email@example.com"
}
```

- **Data File**: `assets/data/services.json`
- **Total Entries**: 4365+ service providers
- **Format**: Dual language (Arabic index 1, English index 0)

## 🔧 Configuration

### Android Permissions
```xml
<queries>
    <intent>
        <action android:name="android.intent.action.DIAL" />
    </intent>
    <intent>
        <action android:name="android.intent.action.SENDTO" />
        <data android:scheme="mailto" />
    </intent>
</queries>
```

## 👨‍💻 Developer

**Mohamed Khaled**  
Flutter Developer  

Specialized in:
- Clean Architecture
- Modern UI/UX Design
- State Management (BLoC/Cubit)
- Localization & Internationalization

## 📄 License

All rights reserved © 2026 SGMC

## 🤝 Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

---

**Built with ❤️ using Flutter**
