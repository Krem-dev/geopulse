import 'package:flutter/material.dart';
import '../../core/theme/appColors.dart';
import '../../core/theme/appSpacing.dart';
import '../components/molecules/alertCard.dart';
import '../components/organisms/customAppBar.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({Key? key}) : super(key: key);

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  final List<Map<String, dynamic>> mockAlerts = [
    {
      'type': 'Emergency',
      'message': 'Severe weather warning - Heavy rain expected',
      'location': 'Your area',
      'timeAgo': '2 min ago',
      'color': AppColors.error,
      'icon': Icons.warning_amber_rounded,
      'isUnread': true,
      'priority': 'high',
    },
    {
      'type': 'Traffic',
      'message': 'Major accident on Highway 101 - Avoid area',
      'location': '0.8 km away',
      'timeAgo': '5 min ago',
      'color': AppColors.accent,
      'icon': Icons.traffic,
      'isUnread': true,
      'priority': 'medium',
    },
    {
      'type': 'Safety',
      'message': 'Road closure due to construction',
      'location': 'Main St',
      'timeAgo': '15 min ago',
      'color': AppColors.warning,
      'icon': Icons.construction,
      'isUnread': false,
      'priority': 'low',
    },
    {
      'type': 'Breaking',
      'message': 'Breaking: City council emergency meeting',
      'location': 'City Hall',
      'timeAgo': '30 min ago',
      'color': AppColors.error,
      'icon': Icons.campaign,
      'isUnread': false,
      'priority': 'high',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Alerts',
        showBackButton: false,
        actions: [
          TextButton(
            onPressed: _markAllAsRead,
            child: Text('Mark All Read'),
          ),
        ],
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Safety'),
              Tab(text: 'Breaking'),
              Tab(text: 'Updates'),
            ],
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.gray600,
            indicatorColor: AppColors.primary,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAlertsList(mockAlerts),
                _buildAlertsList(mockAlerts.where((a) => a['type'].contains('Safety')).toList()),
                _buildAlertsList(mockAlerts.where((a) => a['type'].contains('Breaking')).toList()),
                _buildAlertsList(mockAlerts.where((a) => a['type'].contains('Update')).toList()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertsList(List<dynamic> alerts) {
    if (alerts.isEmpty) {
      return Center(
        child: Text('No alerts in this category'),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
      itemCount: alerts.length,
      itemBuilder: (context, index) {
        final alert = alerts[index];
        return AlertCard(
          alertType: alert['type'],
          message: alert['message'],
          location: alert['location'],
          timeAgo: alert['timeAgo'],
          borderColor: alert['color'],
          icon: alert['icon'],
          isUnread: alert['isUnread'],
          onTap: () => _openAlert(alert),
        );
      },
    );
  }

  void _markAllAsRead() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('All alerts marked as read')),
    );
  }

  void _openAlert(Map<String, dynamic> alert) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening: ${alert['type']}')),
    );
  }
}
