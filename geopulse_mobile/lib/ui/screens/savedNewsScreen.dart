import 'package:flutter/material.dart';
import '../../core/theme/appColors.dart';
import '../../core/theme/appSpacing.dart';
import '../../core/theme/appTypography.dart';
import '../components/molecules/newsCard.dart';
import 'newsDetailScreen.dart';

class SavedNewsScreen extends StatefulWidget {
  const SavedNewsScreen({Key? key}) : super(key: key);

  @override
  State<SavedNewsScreen> createState() => _SavedNewsScreenState();
}

class _SavedNewsScreenState extends State<SavedNewsScreen> {
  // Mock data - in a real app, this would come from a local database or API
  List<Map<String, dynamic>> savedNews = [
    {
      'headline': 'New Community Center Opens Downtown',
      'source': 'City Chronicle',
      'timeAgo': 'Saved 2h ago',
      'distance': '1.2 km away',
      'category': 'Local',
      'categoryColor': AppColors.primary,
      'imageUrl': 'https://picsum.photos/800/400?random=1',
    },
    {
      'headline': 'Tech Summit 2025 Announced',
      'source': 'Tech Weekly',
      'timeAgo': 'Saved 1d ago',
      'distance': '5.0 km away',
      'category': 'Event',
      'categoryColor': AppColors.accent,
      'imageUrl': 'https://picsum.photos/800/400?random=2',
    },
    {
      'headline': 'Weekend Traffic Advisory: Marathon',
      'source': 'TrafficWatch',
      'timeAgo': 'Saved 3d ago',
      'distance': '0.5 km away',
      'category': 'Safety',
      'categoryColor': AppColors.error,
      'imageUrl': 'https://picsum.photos/800/400?random=3',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.neutralDark : AppColors.gray50,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.neutralDark : Colors.white,
        elevation: 0,
        title: Text(
          'Saved Stories',
          style: AppTypography.headlineMedium.copyWith(
            fontSize: 20,
            color: isDark ? Colors.white : AppColors.gray900,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : AppColors.gray900),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: savedNews.isEmpty
          ? _buildEmptyState(isDark)
          : ListView.builder(
              padding: EdgeInsets.all(AppSpacing.md),
              itemCount: savedNews.length,
              itemBuilder: (context, index) {
                final news = savedNews[index];
                return Dismissible(
                  key: Key(news['headline']),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {
                      savedNews.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Article removed from bookmarks'),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () {
                            // Undo logic would go here
                          },
                        ),
                      ),
                    );
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: AppSpacing.lg),
                    margin: EdgeInsets.only(bottom: AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete_outline, color: Colors.white, size: 28),
                        SizedBox(height: 4),
                        Text(
                          'Remove',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  child: NewsCard(
                    headline: news['headline'],
                    source: news['source'],
                    timeAgo: news['timeAgo'],
                    distance: news['distance'],
                    category: news['category'],
                    categoryColor: news['categoryColor'],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewsDetailScreen(news: news),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.bookmark_border,
                size: 64,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            Text(
              'No Saved Stories Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppColors.gray900,
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              'Tap the bookmark icon on any article to save it for later reading.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.gray600,
                height: 1.5,
              ),
            ),
            SizedBox(height: AppSpacing.xl),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.md,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Explore News'),
            ),
          ],
        ),
      ),
    );
  }
}
