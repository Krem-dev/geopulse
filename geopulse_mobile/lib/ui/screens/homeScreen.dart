import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' as math;
import '../../core/theme/appColors.dart';
import '../../core/theme/appSpacing.dart';
import '../components/molecules/newsCard.dart';
import '../components/organisms/bottomNavigation.dart';
import '../components/organisms/customAppBar.dart';
import 'newsDetailScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBottomNavIndex = 0;
  String _currentLocation = 'Brooklyn, NY';
  Position? _lastKnownPosition;
  final double _refreshDistanceThreshold = 15000;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestPermissions();
      _startLocationTracking();
    });
  }

  Future<void> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.notification,
    ].request();
    
    if (statuses[Permission.location]!.isGranted) {
      print('Location permission granted');
    } else if (statuses[Permission.location]!.isPermanentlyDenied) {
      openAppSettings();
    }
    
    if (statuses[Permission.notification]!.isGranted) {
      print('Notification permission granted');
    } else if (statuses[Permission.notification]!.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> _startLocationTracking() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      _lastKnownPosition = position;
      print('Initial location: ${position.latitude}, ${position.longitude}');
      
      Geolocator.getPositionStream(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
        ),
      ).listen((Position position) {
        _handleLocationUpdate(position);
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  void _handleLocationUpdate(Position newPosition) {
    if (_lastKnownPosition == null) {
      _lastKnownPosition = newPosition;
      return;
    }

    final distance = _calculateDistance(
      _lastKnownPosition!.latitude,
      _lastKnownPosition!.longitude,
      newPosition.latitude,
      newPosition.longitude,
    );

    print('Distance moved: ${distance.toStringAsFixed(2)} meters');

    if (distance >= _refreshDistanceThreshold) {
      print('User moved ${(distance / 1000).toStringAsFixed(1)} km - Refreshing news');
      _lastKnownPosition = newPosition;
      _refreshNewsForNewLocation(newPosition);
    }
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371000;
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);
    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degree) {
    return degree * math.pi / 180;
  }

  void _refreshNewsForNewLocation(Position position) {
    if (!mounted) return;
    
    setState(() {
      _currentLocation = 'Location Updated';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('📍 Location changed! Refreshing news...'),
        duration: Duration(seconds: 2),
      ),
    );

    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _currentLocation = 'New Location';
        });
      }
    });
  }

  final List<Map<String, dynamic>> mockNews = [
    {
      'headline': 'Major Traffic Accident on Highway 101',
      'source': 'ABC News',
      'timeAgo': '5 min ago',
      'distance': '0.5 km away',
      'category': 'Safety',
      'categoryColor': AppColors.accent,
    },
    {
      'headline': 'New Restaurant Opens in Downtown',
      'source': 'Local Times',
      'timeAgo': '1 hr ago',
      'distance': '1.2 km away',
      'category': 'Local',
      'categoryColor': Color(0xFF9C27B0),
    },
    {
      'headline': 'City Council Announces New Development Plan',
      'source': 'City News',
      'timeAgo': '2 hrs ago',
      'distance': '2.1 km away',
      'category': 'Breaking',
      'categoryColor': AppColors.error,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.neutralDark : AppColors.gray50,
      appBar: HomeAppBar(
        currentLocation: _currentLocation,
        onLocationTap: _showLocationSelector,
        onNotificationTap: _navigateToAlerts,
        notificationCount: 3,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: isDark ? AppColors.gray900 : Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: isDark ? AppColors.gray800 : AppColors.gray200,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.location_on, color: AppColors.primary, size: 20),
                SizedBox(width: AppSpacing.sm),
                Text(
                  'News Near You',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.gray900,
                  ),
                ),
                Spacer(),
                Text(
                  'Updated 2m ago',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.gray600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(Duration(seconds: 1));
              },
              color: AppColors.primary,
              child: ListView.builder(
                padding: EdgeInsets.only(bottom: AppSpacing.huge),
                itemCount: mockNews.length,
                itemBuilder: (context, index) {
                  final news = mockNews[index];
                  return NewsCard(
                    headline: news['headline'],
                    source: news['source'],
                    timeAgo: news['timeAgo'],
                    distance: news['distance'],
                    category: news['category'],
                    categoryColor: news['categoryColor'],
                    onTap: () => _navigateToNewsDetail(news),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          setState(() {
            _currentBottomNavIndex = index;
          });
          _handleBottomNavTap(index);
        },
        items: [
          BottomNavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home'),
          BottomNavItem(icon: Icons.map_outlined, activeIcon: Icons.map, label: 'Map'),
          BottomNavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'You'),
        ],
      ),
    );
  }

  void _showLocationSelector() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.gray900 : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: AppSpacing.md),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.gray700 : AppColors.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: AppColors.primary,
                        size: 24,
                      ),
                      SizedBox(width: AppSpacing.md),
                      Text(
                        'Select Location',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : AppColors.gray900,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                        color: isDark ? AppColors.gray400 : AppColors.gray600,
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.xl),
                  Container(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.my_location,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        SizedBox(width: AppSpacing.md),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Current Location',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.gray600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              _currentLocation,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : AppColors.gray900,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),
                  Text(
                    'Recent Locations',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.gray600,
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  _buildLocationOption('Manhattan, NY', '12 km away', false, isDark),
                  _buildLocationOption('Queens, NY', '18 km away', false, isDark),
                  _buildLocationOption('Bronx, NY', '22 km away', false, isDark),
                  SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _showLocationSearch();
                      },
                      icon: Icon(Icons.search),
                      label: Text('Search New Location'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationOption(String name, String distance, bool isSelected, bool isDark) {
    return InkWell(
      onTap: () {
        setState(() {
          _currentLocation = name;
        });
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        margin: EdgeInsets.only(bottom: AppSpacing.sm),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : (isDark ? AppColors.gray800 : AppColors.gray50),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDark ? AppColors.gray700 : AppColors.gray200),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.location_city,
              size: 20,
              color: isSelected ? AppColors.primary : AppColors.gray500,
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.gray900,
                    ),
                  ),
                  Text(
                    distance,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.gray600,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }

  void _showLocationSearch() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final searchController = TextEditingController();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _LocationSearchSheet(
        currentLocation: _currentLocation,
        onLocationSelected: (location) {
          setState(() {
            _currentLocation = location;
          });
        },
      ),
    );
  }

  void _navigateToNewsDetail(Map<String, dynamic> news) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewsDetailScreen(news: news),
      ),
    );
  }

  void _navigateToAlerts() {
    Navigator.pushNamed(context, '/notifications');
  }

  void _handleBottomNavTap(int index) {
    switch (index) {
      case 0:
        setState(() => _currentBottomNavIndex = 0);
        break;
      case 1:
        Navigator.pushNamed(context, '/map');
        break;
      case 2:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }
}

class _LocationSearchSheet extends StatefulWidget {
  final String currentLocation;
  final Function(String) onLocationSelected;

  const _LocationSearchSheet({
    required this.currentLocation,
    required this.onLocationSelected,
  });

  @override
  State<_LocationSearchSheet> createState() => _LocationSearchSheetState();
}

class _LocationSearchSheetState extends State<_LocationSearchSheet> {
  final searchController = TextEditingController();
  List<Map<String, String>> filteredCities = [];

  final List<Map<String, String>> allCities = [
    {'city': 'New York, NY', 'country': 'United States'},
    {'city': 'Los Angeles, CA', 'country': 'United States'},
    {'city': 'Chicago, IL', 'country': 'United States'},
    {'city': 'Houston, TX', 'country': 'United States'},
    {'city': 'Phoenix, AZ', 'country': 'United States'},
    {'city': 'Philadelphia, PA', 'country': 'United States'},
    {'city': 'San Antonio, TX', 'country': 'United States'},
    {'city': 'San Diego, CA', 'country': 'United States'},
    {'city': 'Dallas, TX', 'country': 'United States'},
    {'city': 'San Jose, CA', 'country': 'United States'},
    {'city': 'Austin, TX', 'country': 'United States'},
    {'city': 'Jacksonville, FL', 'country': 'United States'},
    {'city': 'Fort Worth, TX', 'country': 'United States'},
    {'city': 'Columbus, OH', 'country': 'United States'},
    {'city': 'Charlotte, NC', 'country': 'United States'},
    {'city': 'San Francisco, CA', 'country': 'United States'},
    {'city': 'Indianapolis, IN', 'country': 'United States'},
    {'city': 'Seattle, WA', 'country': 'United States'},
    {'city': 'Denver, CO', 'country': 'United States'},
    {'city': 'Washington, DC', 'country': 'United States'},
    {'city': 'Boston, MA', 'country': 'United States'},
    {'city': 'El Paso, TX', 'country': 'United States'},
    {'city': 'Nashville, TN', 'country': 'United States'},
    {'city': 'Detroit, MI', 'country': 'United States'},
    {'city': 'Oklahoma City, OK', 'country': 'United States'},
    {'city': 'Portland, OR', 'country': 'United States'},
    {'city': 'Las Vegas, NV', 'country': 'United States'},
    {'city': 'Memphis, TN', 'country': 'United States'},
    {'city': 'Louisville, KY', 'country': 'United States'},
    {'city': 'Baltimore, MD', 'country': 'United States'},
    {'city': 'Milwaukee, WI', 'country': 'United States'},
    {'city': 'Albuquerque, NM', 'country': 'United States'},
    {'city': 'Tucson, AZ', 'country': 'United States'},
    {'city': 'Fresno, CA', 'country': 'United States'},
    {'city': 'Mesa, AZ', 'country': 'United States'},
    {'city': 'Sacramento, CA', 'country': 'United States'},
    {'city': 'Atlanta, GA', 'country': 'United States'},
    {'city': 'Kansas City, MO', 'country': 'United States'},
    {'city': 'Colorado Springs, CO', 'country': 'United States'},
    {'city': 'Raleigh, NC', 'country': 'United States'},
    {'city': 'Omaha, NE', 'country': 'United States'},
    {'city': 'Miami, FL', 'country': 'United States'},
    {'city': 'Long Beach, CA', 'country': 'United States'},
    {'city': 'Virginia Beach, VA', 'country': 'United States'},
    {'city': 'Oakland, CA', 'country': 'United States'},
    {'city': 'Minneapolis, MN', 'country': 'United States'},
    {'city': 'Tulsa, OK', 'country': 'United States'},
    {'city': 'Tampa, FL', 'country': 'United States'},
    {'city': 'Arlington, TX', 'country': 'United States'},
    {'city': 'New Orleans, LA', 'country': 'United States'},
  ];

  @override
  void initState() {
    super.initState();
    filteredCities = allCities;
    searchController.addListener(_filterCities);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterCities() {
    final query = searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredCities = allCities;
      } else {
        filteredCities = allCities.where((city) {
          return city['city']!.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: isDark ? AppColors.gray900 : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          SizedBox(height: AppSpacing.md),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.search, color: AppColors.primary),
                      SizedBox(width: AppSpacing.sm),
                      Text(
                        'Search Location',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : AppColors.gray900,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.lg),
                  TextField(
                    controller: searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Enter city, address, or ZIP code',
                      prefixIcon: Icon(Icons.location_on_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () => searchController.clear(),
                      ),
                      filled: true,
                      fillColor: isDark ? AppColors.gray800 : AppColors.gray50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        widget.onLocationSelected(value);
                        Navigator.pop(context);
                      }
                    },
                  ),
                  SizedBox(height: AppSpacing.xl),
                  Text(
                    searchController.text.isEmpty ? 'Popular Cities' : 'Suggestions',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.gray600,
                    ),
                  ),
                  if (searchController.text.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        '${filteredCities.length} ${filteredCities.length == 1 ? 'result' : 'results'} found',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.gray500,
                        ),
                      ),
                    ),
                  SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
            Expanded(
              child: filteredCities.isEmpty
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.xl),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: AppColors.gray400,
                            ),
                            SizedBox(height: AppSpacing.lg),
                            Text(
                              'No locations found',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : AppColors.gray900,
                              ),
                            ),
                            SizedBox(height: AppSpacing.sm),
                            Text(
                              'Try searching for a different city',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.gray600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      itemCount: filteredCities.length,
                      itemBuilder: (context, index) {
                        final city = filteredCities[index];
                        return _buildSearchLocationItem(
                          city['city']!,
                          city['country']!,
                          isDark,
                        );
                      },
                    ),
            ),
          ],
        ),
      );
  }

  Widget _buildSearchLocationItem(String city, String country, bool isDark) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.location_city, color: AppColors.primary, size: 20),
      ),
      title: Text(
        city,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : AppColors.gray900,
        ),
      ),
      subtitle: Text(
        country,
        style: TextStyle(
          fontSize: 12,
          color: AppColors.gray600,
        ),
      ),
      onTap: () {
        widget.onLocationSelected(city);
        Navigator.pop(context);
      },
    );
  }
}
