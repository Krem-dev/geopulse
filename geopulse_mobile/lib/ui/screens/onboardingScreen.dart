import 'package:flutter/material.dart';
import '../../core/theme/appColors.dart';
import '../../core/theme/appSpacing.dart';
import '../../core/theme/appTypography.dart';
import '../components/atoms/primaryButton.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _precacheImages();
  }

  Future<void> _precacheImages() async {
    final images = [
      'assets/images/slide1.jpg',
      'assets/images/slide2.jpg',
      'assets/images/slide3.jpg',
    ];
    
    for (String image in images) {
      precacheImage(AssetImage(image), context);
    }
  }

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      icon: Icons.location_on,
      title: 'Hyper-Local News',
      description: 'Get real-time news and updates from your exact location',
      color: AppColors.primary,
      backgroundImage: 'assets/images/slide1.jpg',
    ),
    OnboardingPage(
      icon: Icons.notifications_active,
      title: 'Instant Alerts',
      description: 'Stay informed with critical safety and emergency notifications',
      color: AppColors.accent,
      backgroundImage: 'assets/images/slide2.jpg',
    ),
    OnboardingPage(
      icon: Icons.map,
      title: 'Location-Based News',
      description: 'News updates automatically refresh when you move to a new location',
      color: AppColors.success,
      backgroundImage: 'assets/images/slide3.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? AppColors.neutralDark : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _skip,
                child: Text('Skip'),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index], isDark);
                },
              ),
            ),
            _buildPageIndicator(),
            SizedBox(height: AppSpacing.xl),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: PrimaryButton(
                label: _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                onPressed: _currentPage == _pages.length - 1 ? _finish : _nextPage,
              ),
            ),
            SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page, bool isDark) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (page.backgroundImage.isNotEmpty)
          Image.asset(
            page.backgroundImage,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: page.color.withOpacity(0.1),
              );
            },
          )
        else
          Container(
            color: page.color.withOpacity(0.1),
          ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.6),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: page.color.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: Icon(
                  page.icon,
                  size: 64,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: AppSpacing.xxxl),
              Text(
                page.title,
                style: AppTypography.displaySmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.lg),
              Text(
                page.description,
                style: AppTypography.bodyLarge.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _pages.length,
        (index) => Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == index ? AppColors.primary : AppColors.gray300,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _skip() {
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void _finish() {
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class OnboardingPage {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final String backgroundImage;

  OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    this.backgroundImage = '',
  });
}
