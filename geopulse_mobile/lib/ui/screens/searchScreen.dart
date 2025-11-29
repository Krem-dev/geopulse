import 'package:flutter/material.dart';
import '../../core/theme/appColors.dart';
import '../../core/theme/appSpacing.dart';
import '../../core/theme/appTypography.dart';
import '../components/molecules/newsCard.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  final List<String> _recentSearches = [
    'Traffic updates',
    'Weather',
    'Local events',
  ];

  final List<String> _trendingSearches = [
    'Breaking news',
    'Road closure',
    'City council',
    'Weather alert',
    'Sports',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? AppColors.neutralDark : AppColors.gray50,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.gray900 : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search news...',
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: AppColors.gray500,
            ),
          ),
          style: TextStyle(
            fontSize: 16,
            color: isDark ? Colors.white : AppColors.gray900,
          ),
          onChanged: (value) {
            setState(() {
              _isSearching = value.isNotEmpty;
            });
          },
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _isSearching = false;
                });
              },
            ),
        ],
      ),
      body: _isSearching ? _buildSearchResults(isDark) : _buildSearchSuggestions(isDark),
    );
  }

  Widget _buildSearchSuggestions(bool isDark) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_recentSearches.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Searches',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.gray900,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text('Clear'),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md),
            ..._recentSearches.map((search) => _buildSearchItem(
                  icon: Icons.history,
                  text: search,
                  onTap: () {
                    _searchController.text = search;
                    setState(() {
                      _isSearching = true;
                    });
                  },
                  isDark: isDark,
                )),
            SizedBox(height: AppSpacing.xl),
          ],
          Text(
            'Trending Searches',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.gray900,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: _trendingSearches.map((search) => _buildTrendingChip(search, isDark)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(bool isDark) {
    return ListView(
      padding: EdgeInsets.only(top: AppSpacing.md),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text(
            'Results for "${_searchController.text}"',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.gray600,
            ),
          ),
        ),
        SizedBox(height: AppSpacing.md),
        NewsCard(
          headline: 'Search result matching your query',
          source: 'ABC News',
          timeAgo: '10 min ago',
          distance: '1.2 km',
          category: 'Local',
          categoryColor: AppColors.primary,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSearchItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: AppColors.gray500,
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  color: isDark ? Colors.white : AppColors.gray900,
                ),
              ),
            ),
            Icon(
              Icons.north_west,
              size: 16,
              color: AppColors.gray400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendingChip(String text, bool isDark) {
    return InkWell(
      onTap: () {
        _searchController.text = text;
        setState(() {
          _isSearching = true;
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isDark ? AppColors.gray800 : AppColors.gray100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? AppColors.gray700 : AppColors.gray200,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.trending_up,
              size: 14,
              color: AppColors.primary,
            ),
            SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : AppColors.gray900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
