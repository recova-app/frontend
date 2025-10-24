# Simple Theme System - Usage Guide

## 📖 Overview

This simplified theme system makes it super easy to maintain consistent design throughout your Flutter app.

## 🎨 What's Included

### Colors (`AppTheme`)
```dart
AppTheme.primary      // Main teal color
AppTheme.secondary    // Coral accent color
AppTheme.background   // Light grey background
AppTheme.surface      // White surface
AppTheme.textDark     // Dark text
AppTheme.textGrey     // Grey text
AppTheme.textLight    // Light text
AppTheme.success      // Green
AppTheme.warning      // Orange
AppTheme.error        // Red
```

### Text Styles (`AppText`)
```dart
AppText.h1      // Large heading (32px, bold)
AppText.h2      // Medium heading (24px, semibold)
AppText.body    // Normal text (16px)
AppText.small   // Small text (14px, grey)
```

### Spacing (`AppSpacing`)
```dart
AppSpacing.small   // 8px
AppSpacing.medium  // 16px  
AppSpacing.large   // 24px
```

### Border Radius (`AppRadius`)
```dart
AppRadius.small   // 8px
AppRadius.medium  // 12px
AppRadius.large   // 16px
```

## 🚀 How to Use

### 1. Import the theme
```dart
import '../theme/app_theme.dart';
```

### 2. Use colors
```dart
Container(
  color: AppTheme.primary,
  child: Text(
    'Hello',
    style: TextStyle(color: Colors.white),
  ),
)
```

### 3. Use text styles
```dart
Column(
  children: [
    Text('Title', style: AppText.h1),
    Text('Subtitle', style: AppText.h2),
    Text('Content', style: AppText.body),
    Text('Caption', style: AppText.small),
  ],
)
```

### 4. Use spacing
```dart
Padding(
  padding: EdgeInsets.all(AppSpacing.medium), // Instead of 16.0
  child: Column(
    children: [
      Text('First'),
      SizedBox(height: AppSpacing.small), // Instead of 8.0
      Text('Second'),
    ],
  ),
)
```

### 5. Use border radius
```dart
Container(
  decoration: BoxDecoration(
    color: AppTheme.primary,
    borderRadius: BorderRadius.circular(AppRadius.medium), // Instead of 12.0
  ),
)
```

### 6. Create gradient buttons
```dart
Container(
  decoration: BoxDecoration(
    gradient: AppTheme.primaryGradient,
    borderRadius: BorderRadius.circular(AppRadius.small),
  ),
  child: ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
    ),
    child: Text('Gradient Button'),
  ),
)
```

## 📱 Example Implementation

### Before (Hardcoded)
```dart
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Color(0xFF4ECDC4),
    borderRadius: BorderRadius.circular(12),
  ),
  child: Text(
    'Hello World',
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Color(0xFF2C3E50),
    ),
  ),
)
```

### After (Theme-based)
```dart
Container(
  padding: EdgeInsets.all(AppSpacing.medium),
  decoration: BoxDecoration(
    color: AppTheme.primary,
    borderRadius: BorderRadius.circular(AppRadius.medium),
  ),
  child: Text(
    'Hello World',
    style: AppText.body.copyWith(color: Colors.white),
  ),
)
```

## 🎯 Benefits

1. **Consistency**: All colors and sizes are predefined
2. **Easy Changes**: Update one place, changes everywhere
3. **Clean Code**: No more magic numbers
4. **Fast Development**: Copy-paste patterns
5. **Maintainable**: Easy to understand and modify

## 🔧 Quick Start

1. **Use in existing widgets**: Replace hardcoded values with theme values
2. **Test it out**: Navigate to `/theme-showcase` to see examples
3. **Customize**: Modify colors in `AppTheme` class as needed
4. **Apply consistently**: Use the same patterns throughout your app

## 📋 Checklist for Converting Existing Code

- [ ] Replace `Color(0x...)` with `AppTheme.primary/secondary/etc`
- [ ] Replace `EdgeInsets.all(16)` with `EdgeInsets.all(AppSpacing.medium)`
- [ ] Replace `BorderRadius.circular(12)` with `BorderRadius.circular(AppRadius.medium)`
- [ ] Replace hardcoded TextStyle with `AppText.h1/h2/body/small`
- [ ] Use `AppTheme.primaryGradient` for gradient effects

That's it! Your theme system is now much simpler and easier to use. 🎉