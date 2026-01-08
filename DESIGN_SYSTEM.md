# UI Theme Design Documentation

## Overview
This document describes the UI/UX theme system implemented for the SGMC App, a service directory application for finding medical and healthcare services across Egyptian governorates.

## Design Philosophy

### Core Principles
1. **Clarity Over Decoration**: Simple, clean interface focused on content
2. **Professional & Trustworthy**: Medical/healthcare context requires trust
3. **Fast & Accessible**: Easy navigation and quick access to information
4. **Consistent & Scalable**: Reusable components across all screens
5. **Mobile-First**: Optimized for touch interactions and small screens

## Color Palette

### Primary Colors
- **Primary**: `#1976D2` (Material Blue 700)
  - Use: Main brand color, AppBar, primary buttons, active states
  - Conveys: Trust, professionalism, stability
  
- **Primary Light**: `#42A5F5` (Material Blue 400)
  - Use: Hover states, light accents
  
- **Primary Dark**: `#0D47A1` (Material Blue 900)
  - Use: Dark mode variants, pressed states

### Secondary Colors
- **Secondary**: `#00897B` (Teal 600)
  - Use: Accent elements, secondary actions, highlights
  - Conveys: Modern, fresh, healthcare

### Background Colors
- **Background**: `#F5F7FA` (Light gray-blue)
  - Use: Screen background
  
- **Surface**: `#FFFFFF` (White)
  - Use: Cards, dialogs, bottom sheets
  
- **Surface Variant**: `#F0F4F8` (Very light blue-gray)
  - Use: Subtle backgrounds, disabled states

### Text Colors
- **Text Primary**: `#1A1A1A` (Almost black)
  - Use: Main content text
  
- **Text Secondary**: `#6B7280` (Medium gray)
  - Use: Supporting text, descriptions, captions
  
- **Text Disabled**: `#9CA3AF` (Light gray)
  - Use: Disabled text

### Status Colors
- **Success**: `#10B981` (Green)
- **Error**: `#EF4444` (Red)
- **Warning**: `#F59E0B` (Amber)
- **Info**: `#3B82F6` (Blue)

## Typography

### Font System
Using system default fonts for optimal performance and native feel:
- iOS: San Francisco
- Android: Roboto

### Text Styles

#### Display (Large Titles)
- **Display Large**: 32px, Bold, -0.5 letter spacing
- **Display Medium**: 28px, Bold, -0.3 letter spacing
- **Display Small**: 24px, Bold, -0.2 letter spacing

#### Headlines (Screen Titles)
- **Headline Large**: 22px, Semi-bold
- **Headline Medium**: 20px, Semi-bold
- **Headline Small**: 18px, Semi-bold

#### Titles (Card/List Titles)
- **Title Large**: 18px, Semi-bold
- **Title Medium**: 16px, Semi-bold (Main use for list items)
- **Title Small**: 14px, Semi-bold

#### Body (Regular Text)
- **Body Large**: 16px, Regular, 1.6 line height
- **Body Medium**: 14px, Regular, 1.6 line height
- **Body Small**: 12px, Regular (Use for secondary info)

#### Labels (Buttons/Tags)
- **Label Large**: 14px, Semi-bold
- **Label Medium**: 12px, Semi-bold, 0.5 letter spacing
- **Label Small**: 11px, Semi-bold, 0.5 letter spacing

### Specialized Styles
- **AppBar Title**: 20px, Semi-bold, White
- **Button Text**: 16px, Semi-bold, 0.5 letter spacing
- **Caption**: 12px, Regular, Secondary color
- **Overline**: 10px, Semi-bold, 1.5 letter spacing

## Spacing System

### Padding Constants
- **Small**: 8px
- **Medium**: 16px (Most common)
- **Large**: 24px
- **Extra Large**: 32px

### Border Radius
- **Card**: 12px (Soft, modern feel)
- **Button**: 8px
- **Input**: 8px
- **Chip**: 20px (Pill-shaped)

### Icon Sizes
- **Small**: 20px
- **Medium**: 24px (Default)
- **Large**: 32px

## Component Styles

### Cards (AppListCard)
- **Background**: White surface
- **Border**: 1px solid `#E5E7EB`
- **Elevation**: 0 (Flat design with border)
- **Radius**: 12px
- **Padding**: 16px horizontal and vertical
- **Leading Icon Container**: 48x48px with 12px radius, primary color at 10% opacity
- **Hover**: InkWell ripple effect

### Buttons
- **Elevated Button**:
  - Background: Primary color
  - Text: White, 16px, semi-bold
  - Padding: 24px horizontal, 16px vertical
  - Radius: 8px
  - Elevation: 2

- **Text Button**:
  - Color: Primary
  - No background

### AppBar
- **Background**: Primary color
- **Foreground**: White
- **Elevation**: 0 (Flat)
- **Title**: 20px, semi-bold

### Input Fields
- **Background**: White surface
- **Border**: 1px solid `#E5E7EB`
- **Focus Border**: 2px solid Primary
- **Radius**: 8px
- **Padding**: 16px

## Reusable Components

### 1. AppListCard
**Purpose**: Display items in lists (governorates, categories, services)

**Props**:
- `title` (required): Main text
- `subtitle` (optional): Secondary text
- `leadingIcon` (optional): Icon on the left
- `trailing` (optional): Custom widget on right
- `onTap` (optional): Tap callback
- `backgroundColor` (optional): Custom background

**Use Cases**:
- Governorate list
- Category list
- Service provider list
- Any clickable list items

### 2. AppLoadingIndicator
**Purpose**: Show loading state

**Props**:
- `message` (optional): Loading message

### 3. AppEmptyState
**Purpose**: Show when no data available

**Props**:
- `icon` (required): Icon to display
- `message` (required): Main message
- `description` (optional): Detailed description
- `action` (optional): Action button

### 4. AppErrorState
**Purpose**: Show error state with retry option

**Props**:
- `message` (required): Error message
- `onRetry` (optional): Retry callback

### 5. AppSearchBar
**Purpose**: Search input field

**Props**:
- `hintText` (required): Placeholder text
- `onChanged` (optional): Text change callback
- `controller` (optional): Text controller
- `onClear` (optional): Clear callback

### 6. AppSectionHeader
**Purpose**: Section separator with title

**Props**:
- `title` (required): Section title
- `trailing` (optional): Right-side widget

## Screen Structure Pattern

### Standard Screen Layout
```dart
Scaffold(
  appBar: AppBar(
    title: Text('Screen Title'),
  ),
  body: Column(
    children: [
      // Header Section (optional)
      Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Title', style: headlineSmall),
            Text('Description', style: bodyMedium),
          ],
        ),
      ),
      
      Divider(height: 1),
      
      // Main Content
      Expanded(
        child: ListView.builder(...),
      ),
    ],
  ),
)
```

## Implementation Guide for Future Screens

### Categories Screen
```dart
// Use same pattern as HomeScreen
AppListCard(
  title: categoryName,
  subtitle: '$count services available',
  leadingIcon: Icons.category,
  onTap: () => navigateToItems(category),
)
```

### Service Items List Screen
```dart
AppListCard(
  title: serviceName,
  subtitle: 'Location • Specialty',
  leadingIcon: Icons.medical_services,
  trailing: Icon(Icons.star, color: Colors.amber),
  onTap: () => navigateToDetails(service),
)
```

### Details Screen
```dart
// Use Card widgets with proper padding
Card(
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Section Title', style: titleMedium),
        SizedBox(height: 8),
        Text('Content', style: bodyMedium),
      ],
    ),
  ),
)
```

## Accessibility Considerations

1. **Color Contrast**: All text meets WCAG AA standards
2. **Touch Targets**: Minimum 48x48px for interactive elements
3. **Text Scaling**: Supports system font scaling
4. **Semantics**: All interactive elements have semantic labels

## Do's and Don'ts

### Do's ✅
- Use AppListCard for all list items
- Use theme colors from AppColors
- Use text styles from AppTextStyles
- Use spacing constants from AppDimensions
- Show loading states with AppLoadingIndicator
- Show empty states with AppEmptyState
- Show errors with AppErrorState

### Don'ts ❌
- Don't hardcode colors in widgets
- Don't hardcode text styles
- Don't hardcode spacing values
- Don't create custom list items without good reason
- Don't ignore loading/error/empty states
- Don't use different icon sizes inconsistently

## File Structure
```
lib/
├── core/
│   ├── theme/
│   │   ├── app_theme.dart       # Main theme configuration
│   │   ├── app_colors.dart      # Color palette
│   │   └── app_text_styles.dart # Typography
│   └── widgets/
│       └── app_widgets.dart     # Reusable components
├── presentation/
│   └── screens/
│       └── home_screen.dart     # Example implementation
└── main.dart                     # Theme applied here
```

## Future Enhancements

Potential additions without breaking existing design:
1. Dark mode theme
2. RTL (Right-to-Left) support for Arabic
3. Additional status chip components
4. Filter/sort components
5. Bottom sheet components
6. Animation utilities
7. Image placeholder widgets

## Version
- **Version**: 1.0.0
- **Last Updated**: January 8, 2026
- **Status**: Production Ready
