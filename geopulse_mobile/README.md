# GeoPulse Mobile

Hyper-local news intelligence app built with Flutter. Shows real-time news, safety updates, trending topics, and alerts based on user's current location or manually selected location.

## Project Structure

```
lib/
├── core/
│   ├── theme/
│   │   ├── appColors.dart          # Color palette & theme colors
│   │   ├── appSpacing.dart         # Spacing scale (4dp base unit)
│   │   ├── appTypography.dart      # Typography styles
│   │   └── appTheme.dart           # Light & dark theme configuration
│   ├── constants/                  # App constants
│   └── utils/                      # Utility functions
│
├── ui/
│   ├── components/
│   │   ├── atoms/                  # Atomic components (buttons, chips, etc.)
│   │   │   ├── primaryButton.dart
│   │   │   ├── secondaryButton.dart
│   │   │   ├── textButton.dart
│   │   │   ├── iconButton.dart
│   │   │   ├── loadingIndicator.dart
│   │   │   └── chip.dart
│   │   │
│   │   ├── molecules/              # Molecular components (cards, search, etc.)
│   │   │   ├── searchBar.dart
│   │   │   ├── newsCard.dart
│   │   │   ├── alertCard.dart
│   │   │   └── locationCard.dart
│   │   │
│   │   └── organisms/              # Complex components (AppBar, Nav, etc.)
│   │       ├── customAppBar.dart
│   │       ├── bottomNavigation.dart
│   │       ├── categoryTabs.dart
│   │       └── emptyState.dart
│   │
│   ├── screens/                    # Full screens
│   │   ├── homeScreen.dart
│   │   ├── newsDetailScreen.dart
│   │   ├── alertsScreen.dart
│   │   ├── trendingScreen.dart
│   │   ├── savedLocationsScreen.dart
│   │   ├── profileScreen.dart
│   │   └── settingsScreen.dart
│   │
│   └── navigation/                 # Navigation & routing
│       └── appRouter.dart
│
├── main.dart                       # App entry point
│
assets/
├── images/                         # App images
├── icons/                          # SVG/PNG icons
└── fonts/                          # Custom fonts (Inter)
```

## Architecture

### Component-Based Design
- **Atoms**: Smallest reusable components (buttons, icons, chips)
- **Molecules**: Combinations of atoms (cards, search bars, lists)
- **Organisms**: Complex sections (AppBar, navigation, modals)
- **Screens**: Full page layouts using components

### Theme System
- Centralized color palette
- Consistent spacing scale (4dp base unit)
- Typography system with predefined styles
- Light & dark mode support

### No Large Files
- Each component is in its own file
- Maximum ~150 lines per file
- Easy to find, modify, and reuse
- Clear separation of concerns

## Key Features

✓ Modular component architecture
✓ Light & dark theme support
✓ Responsive design (mobile-first)
✓ Reusable UI components
✓ Consistent spacing & typography
✓ Accessibility-ready
✓ Clean code organization

## Getting Started

1. Install Flutter: https://flutter.dev/docs/get-started/install
2. Clone the repository
3. Run `flutter pub get`
4. Run `flutter run`

## Adding New Components

1. Create a new file in appropriate folder (atoms/molecules/organisms)
2. Keep component focused and single-purpose
3. Use theme constants from `core/theme/`
4. Export from parent index file if needed
5. Use in screens or other components

## Theme Usage

```dart
import 'package:geopulse/core/theme/appColors.dart';
import 'package:geopulse/core/theme/appSpacing.dart';
import 'package:geopulse/core/theme/appTypography.dart';

// Use colors
Container(color: AppColors.primary)

// Use spacing
Padding(padding: EdgeInsets.all(AppSpacing.lg))

// Use typography
Text('Hello', style: AppTypography.headlineLarge)
```

## Component Examples

### Using PrimaryButton
```dart
PrimaryButton(
  label: 'Get Started',
  onPressed: () {},
  isLoading: false,
)
```

### Using NewsCard
```dart
NewsCard(
  headline: 'Breaking News',
  source: 'ABC News',
  timeAgo: '5 min ago',
  distance: '0.5 km',
  category: 'Breaking',
  categoryColor: AppColors.error,
  onTap: () {},
)
```

### Using CustomAppBar
```dart
CustomAppBar(
  title: 'Home',
  onBackPressed: () => Navigator.pop(context),
  actions: [IconButtonWidget(icon: Icons.menu, onPressed: () {})],
)
```

## Development Guidelines

- Keep components small and focused
- Use const constructors where possible
- Follow naming conventions (camelCase for files)
- Add documentation for complex logic
- Test components in different themes
- Ensure accessibility (48dp touch targets minimum)

## Dependencies

- **flutter_riverpod**: State management
- **go_router**: Navigation
- **google_maps_flutter**: Maps integration
- **geolocator**: Location services
- **firebase_messaging**: Push notifications
- **cached_network_image**: Image caching
- **permission_handler**: Permission management

## License

Proprietary - GeoPulse
