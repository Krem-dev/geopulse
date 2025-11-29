import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as math;
import '../../core/theme/appColors.dart';
import '../../core/theme/appSpacing.dart';
import '../../core/theme/appTypography.dart';
import '../components/organisms/customAppBar.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  GoogleMapController? _mapController;
  String _selectedPOI = 'none';
  bool _isCategoryMenuExpanded = false;
  AnimationController? _fabAnimationController;
  Animation<double>? _fabAnimation;
  AnimationController? _pulseAnimationController;
  
  final LatLng _userLocation = LatLng(40.7128, -74.0060);

  final List<String> _poiCategories = [
    'none',
    'hospital',
    'police',
    'gas_station',
    'lodging',
    'restaurant',
    'store',
  ];

  final List<MapPin> _newsPins = [
    MapPin(
      lat: 40.7128,
      lng: -74.0060,
      title: 'Traffic Accident',
      category: 'Traffic',
      intensity: 'high',
      distance: '0.5 km',
    ),
    MapPin(
      lat: 40.7180,
      lng: -74.0020,
      title: 'Weather Alert',
      category: 'Weather',
      intensity: 'medium',
      distance: '1.2 km',
    ),
    MapPin(
      lat: 40.7050,
      lng: -74.0100,
      title: 'Local Event',
      category: 'Event',
      intensity: 'low',
      distance: '2.1 km',
    ),
  ];

  final Map<String, List<POIPlace>> _poiData = {
    'hospital': [
      POIPlace(lat: 40.7150, lng: -74.0050, name: 'NYC Health + Hospitals'),
      POIPlace(lat: 40.7200, lng: -74.0080, name: 'Mount Sinai Hospital'),
      POIPlace(lat: 40.7080, lng: -74.0120, name: 'Bellevue Hospital'),
      POIPlace(lat: 40.7220, lng: -74.0010, name: 'NewYork-Presbyterian'),
    ],
    'police': [
      POIPlace(lat: 40.7140, lng: -74.0070, name: '1st Precinct'),
      POIPlace(lat: 40.7190, lng: -74.0040, name: '5th Precinct'),
      POIPlace(lat: 40.7060, lng: -74.0130, name: 'NYPD Headquarters'),
    ],
    'gas_station': [
      POIPlace(lat: 40.7160, lng: -74.0090, name: 'Shell Gas Station'),
      POIPlace(lat: 40.7100, lng: -74.0110, name: 'BP Gas Station'),
      POIPlace(lat: 40.7210, lng: -74.0030, name: 'Exxon'),
      POIPlace(lat: 40.7070, lng: -74.0100, name: 'Mobil'),
    ],
    'lodging': [
      POIPlace(lat: 40.7170, lng: -74.0045, name: 'Marriott Downtown'),
      POIPlace(lat: 40.7120, lng: -74.0085, name: 'Hilton Manhattan'),
      POIPlace(lat: 40.7190, lng: -74.0020, name: 'The Ritz-Carlton'),
    ],
    'restaurant': [
      POIPlace(lat: 40.7155, lng: -74.0065, name: 'The River Café'),
      POIPlace(lat: 40.7175, lng: -74.0055, name: 'Delmonico\'s'),
      POIPlace(lat: 40.7095, lng: -74.0105, name: 'Fraunces Tavern'),
    ],
    'store': [
      POIPlace(lat: 40.7165, lng: -74.0075, name: 'Whole Foods Market'),
      POIPlace(lat: 40.7135, lng: -74.0095, name: 'CVS Pharmacy'),
      POIPlace(lat: 40.7185, lng: -74.0045, name: 'Target'),
    ],
  };

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = CurvedAnimation(
      parent: _fabAnimationController!,
      curve: Curves.easeInOut,
    );
    
    _pulseAnimationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    
    _pulseAnimationController?.addListener(() {
      setState(() {});
    });
  }


  @override
  void dispose() {
    _fabAnimationController?.dispose();
    _pulseAnimationController?.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371;
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

  String _formatDistance(double km) {
    if (km < 1) {
      return '${(km * 1000).round()} m';
    }
    return '${km.toStringAsFixed(1)} km';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.neutralDark : Colors.white,
      appBar: CustomAppBar(
        title: 'Map View',
        showBackButton: false,
      ),
      body: Stack(
        children: [
          _buildMapPlaceholder(isDark),
          _buildFloatingCategoryMenu(isDark),
          _buildMyLocationButton(),
          if (_selectedPOI == 'none')
            _buildNewsListButton(isDark),
        ],
      ),
    );
  }

  Widget _buildMapPlaceholder(bool isDark) {
    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        setState(() {
          _mapController = controller;
        });
        controller.setMapStyle(_getMapStyle(isDark));
      },
      initialCameraPosition: CameraPosition(
        target: _userLocation,
        zoom: 14,
      ),
      markers: _buildMarkers(),
      circles: _buildPulseCircles(),
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapType: MapType.normal,
      compassEnabled: false,
      mapToolbarEnabled: false,
      buildingsEnabled: false,
      indoorViewEnabled: false,
    );
  }

  String _getMapStyle(bool isDark) {
    return '''
    [
      {
        "featureType": "poi",
        "elementType": "labels",
        "stylers": [{"visibility": "off"}]
      },
      {
        "featureType": "poi.business",
        "stylers": [{"visibility": "off"}]
      },
      {
        "featureType": "poi.medical",
        "stylers": [{"visibility": "off"}]
      },
      {
        "featureType": "poi.government",
        "stylers": [{"visibility": "off"}]
      },
      {
        "featureType": "poi.school",
        "stylers": [{"visibility": "off"}]
      },
      {
        "featureType": "poi.sports_complex",
        "stylers": [{"visibility": "off"}]
      },
      {
        "featureType": "poi.park",
        "elementType": "labels",
        "stylers": [{"visibility": "off"}]
      },
      {
        "featureType": "transit",
        "elementType": "labels.icon",
        "stylers": [{"visibility": "off"}]
      }
      ${isDark ? ''',
      {
        "elementType": "geometry",
        "stylers": [{"color": "#212121"}]
      },
      {
        "elementType": "labels.text.fill",
        "stylers": [{"color": "#757575"}]
      },
      {
        "elementType": "labels.text.stroke",
        "stylers": [{"color": "#212121"}]
      }''' : ''}
    ]
    ''';
  }

  Set<Circle> _buildPulseCircles() {
    if (_selectedPOI == 'none') {
      return {};
    }
    
    final pois = _poiData[_selectedPOI] ?? [];
    final pulseValue = _pulseAnimationController?.value ?? 0;
    final radius = 50 + (pulseValue * 100);
    final opacity = (1 - pulseValue) * 0.3;
    
    return pois.map((poi) {
      return Circle(
        circleId: CircleId(poi.name),
        center: LatLng(poi.lat, poi.lng),
        radius: radius,
        fillColor: _getPOIColor(_selectedPOI).withOpacity(opacity),
        strokeColor: _getPOIColor(_selectedPOI).withOpacity(opacity * 0.5),
        strokeWidth: 1,
      );
    }).toSet();
  }

  Color _getPOIColor(String category) {
    switch (category) {
      case 'hospital':
        return Colors.red;
      case 'police':
        return Colors.blue;
      case 'gas_station':
        return Colors.orange;
      case 'lodging':
        return Colors.purple;
      case 'restaurant':
        return Colors.yellow;
      case 'store':
        return Colors.green;
      default:
        return Colors.red;
    }
  }

  Set<Marker> _buildMarkers() {
    if (_selectedPOI == 'none') {
      return {};
    } else {
      final pois = _poiData[_selectedPOI] ?? [];
      return pois.map((poi) {
        final distance = _calculateDistance(
          _userLocation.latitude,
          _userLocation.longitude,
          poi.lat,
          poi.lng,
        );
        return Marker(
          markerId: MarkerId(poi.name),
          position: LatLng(poi.lat, poi.lng),
          infoWindow: InfoWindow(
            title: poi.name,
            snippet: _formatDistance(distance),
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            _getPOIMarkerHue(_selectedPOI),
          ),
          anchor: Offset(0.5, 0.5),
        );
      }).toSet();
    }
  }

  double _getPOIMarkerHue(String category) {
    switch (category) {
      case 'hospital':
        return BitmapDescriptor.hueRed;
      case 'police':
        return BitmapDescriptor.hueBlue;
      case 'gas_station':
        return BitmapDescriptor.hueOrange;
      case 'lodging':
        return BitmapDescriptor.hueViolet;
      case 'restaurant':
        return BitmapDescriptor.hueYellow;
      case 'store':
        return BitmapDescriptor.hueGreen;
      default:
        return BitmapDescriptor.hueRed;
    }
  }


  double _getMarkerHue(String intensity) {
    switch (intensity) {
      case 'high':
        return BitmapDescriptor.hueRed;
      case 'medium':
        return BitmapDescriptor.hueOrange;
      case 'low':
        return BitmapDescriptor.hueYellow;
      default:
        return BitmapDescriptor.hueBlue;
    }
  }



  Widget _buildFloatingCategoryMenu(bool isDark) {
    final categories = [
      {'icon': Icons.local_hospital, 'label': 'Hospitals', 'key': 'hospital'},
      {'icon': Icons.local_police, 'label': 'Police', 'key': 'police'},
      {'icon': Icons.local_gas_station, 'label': 'Gas Stations', 'key': 'gas_station'},
      {'icon': Icons.hotel, 'label': 'Hotels', 'key': 'lodging'},
      {'icon': Icons.restaurant, 'label': 'Restaurants', 'key': 'restaurant'},
      {'icon': Icons.store, 'label': 'Stores', 'key': 'store'},
    ];

    return Positioned(
      top: AppSpacing.md,
      right: AppSpacing.md,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _isCategoryMenuExpanded
                ? Column(
                    children: categories.map((cat) {
                      final isSelected = _selectedPOI == cat['key'];
                      return Padding(
                        padding: EdgeInsets.only(bottom: AppSpacing.sm),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedPOI = isSelected ? 'none' : cat['key'] as String;
                              _isCategoryMenuExpanded = false;
                              _fabAnimationController?.reverse();
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.sm,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : (isDark ? AppColors.gray800 : AppColors.white),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  cat['icon'] as IconData,
                                  size: 20,
                                  color: isSelected
                                      ? AppColors.white
                                      : AppColors.primary,
                                ),
                                SizedBox(width: AppSpacing.sm),
                                Text(
                                  cat['label'] as String,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? AppColors.white
                                        : (isDark ? Colors.white : AppColors.gray900),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  )
                : SizedBox.shrink(),
          ),
          FloatingActionButton(
            heroTag: 'category',
            onPressed: () {
              setState(() {
                _isCategoryMenuExpanded = !_isCategoryMenuExpanded;
                if (_isCategoryMenuExpanded) {
                  _fabAnimationController?.forward();
                } else {
                  _fabAnimationController?.reverse();
                }
              });
            },
            backgroundColor: AppColors.primary,
            child: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              progress: _fabAnimation ?? AlwaysStoppedAnimation(0),
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyLocationButton() {
    return Positioned(
      bottom: 100,
      right: AppSpacing.md,
      child: FloatingActionButton(
        heroTag: 'location',
        mini: true,
        onPressed: _centerOnUserLocation,
        backgroundColor: AppColors.white,
        elevation: 4,
        child: Icon(Icons.my_location, color: AppColors.primary, size: 20),
      ),
    );
  }

  Widget _buildNewsListButton(bool isDark) {
    return Positioned(
      bottom: AppSpacing.lg,
      left: AppSpacing.lg,
      right: 80,
      child: GestureDetector(
        onTap: _showNewsList,
        child: Container(
          padding: EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: isDark ? AppColors.gray800 : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.list, color: AppColors.primary),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  '${_newsPins.length} news stories nearby',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.gray900,
                  ),
                ),
              ),
              Icon(Icons.keyboard_arrow_up, color: AppColors.gray500),
            ],
          ),
        ),
      ),
    );
  }

  void _showNewsList() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
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
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: AppColors.primary),
                    SizedBox(width: AppSpacing.sm),
                    Text(
                      'News Near You',
                      style: AppTypography.headlineMedium.copyWith(
                        color: isDark ? Colors.white : AppColors.gray900,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  itemCount: _newsPins.length,
                  itemBuilder: (context, index) {
                    final pin = _newsPins[index];
                    return ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _getIntensityColor(pin.intensity).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getCategoryIcon(pin.category),
                          color: _getIntensityColor(pin.intensity),
                          size: 20,
                        ),
                      ),
                      title: Text(
                        pin.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : AppColors.gray900,
                        ),
                      ),
                      subtitle: Text(
                        '${pin.category} • ${pin.distance}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.gray600,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _mapController?.animateCamera(
                          CameraUpdate.newLatLng(LatLng(pin.lat, pin.lng)),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getIntensityColor(String intensity) {
    switch (intensity) {
      case 'high':
        return AppColors.error;
      case 'medium':
        return AppColors.accent;
      case 'low':
        return AppColors.warning;
      default:
        return AppColors.gray500;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Traffic':
        return Icons.directions_car;
      case 'Weather':
        return Icons.cloud;
      case 'Event':
        return Icons.event;
      default:
        return Icons.location_on;
    }
  }

  void _showNewsDetail(MapPin pin) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${pin.title} - ${pin.distance}')),
    );
  }

  void _centerOnUserLocation() {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(_userLocation, 15),
    );
  }
}

class MapPin {
  final double lat;
  final double lng;
  final String title;
  final String category;
  final String intensity;
  final String distance;

  MapPin({
    required this.lat,
    required this.lng,
    required this.title,
    required this.category,
    required this.intensity,
    required this.distance,
  });
}

class POIPlace {
  final double lat;
  final double lng;
  final String name;

  POIPlace({
    required this.lat,
    required this.lng,
    required this.name,
  });
}
