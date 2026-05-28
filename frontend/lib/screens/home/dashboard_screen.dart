import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _firestoreService = FirestoreService();
  Map<String, dynamic>? _analytics;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    final user = context.read<AuthProvider>().user;
    if (user == null) return;
    final data = await _firestoreService.getAnalytics(user.uid);
    setState(() { _analytics = data; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello, ${user?.displayName ?? 'User'}'),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadAnalytics),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadAnalytics,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats Cards
              if (_loading)
                const Center(child: CircularProgressIndicator())
              else ...[
                _buildStatsGrid(),
                const SizedBox(height: 24),
                Text('Quick Actions', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 12),
                _buildQuickActions(),
                const SizedBox(height: 24),
                Text('AI Status', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 12),
                _buildAIStatusCard(),
                const SizedBox(height: 24),
                Text('Recent Activity', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 12),
                _buildRecentActivity(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    final stats = [
      {'icon': Icons.receipt_long, 'label': 'Orders', 'value': '${_analytics?['totalOrders'] ?? 0}', 'color': AppTheme.primaryColor},
      {'icon': Icons.people, 'label': 'Customers', 'value': '${_analytics?['totalCustomers'] ?? 0}', 'color': AppTheme.secondaryColor},
      {'icon': Icons.check_circle, 'label': 'Completed', 'value': '${_analytics?['completedOrders'] ?? 0}', 'color': Colors.green},
      {'icon': Icons.currency_rupee, 'label': 'Revenue', 'value': '₹${NumberFormat('#,##0').format(_analytics?['totalRevenue'] ?? 0)}', 'color': Colors.orange},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, childAspectRatio: 1.5, crossAxisSpacing: 12, mainAxisSpacing: 12,
      ),
      itemCount: stats.length,
      itemBuilder: (_, i) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(stats[i]['icon'] as IconData, color: stats[i]['color'] as Color, size: 28),
              const SizedBox(height: 8),
              Text(stats[i]['value'] as String, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: stats[i]['color'] as Color)),
              Text(stats[i]['label'] as String, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {'icon': Icons.chat, 'label': 'New Chat', 'color': AppTheme.primaryColor},
      {'icon': Icons.add_shopping_cart, 'label': 'New Order', 'color': AppTheme.secondaryColor},
      {'icon': Icons.person_add, 'label': 'Add Customer', 'color': Colors.blue},
      {'icon': Icons.document_scanner, 'label': 'Scan Receipt', 'color': Colors.purple},
    ];

    return Row(
      children: actions.map((a) => Expanded(
        child: GestureDetector(
          onTap: () {},
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Icon(a['icon'] as IconData, color: a['color'] as Color, size: 28),
                  const SizedBox(height: 4),
                  Text(a['label'] as String, style: const TextStyle(fontSize: 11), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildAIStatusCard() {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: AppTheme.secondaryColor,
          child: Icon(Icons.smart_toy, color: Colors.white),
        ),
        title: const Text('AI Assistant'),
        subtitle: const Text('Local AI Mode • Active'),
        trailing: Switch(value: true, onChanged: (_) {}),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildActivityItem('New order received', '5 min ago', Icons.shopping_cart),
            const Divider(),
            _buildActivityItem('AI replied to customer', '12 min ago', Icons.smart_toy),
            const Divider(),
            _buildActivityItem('New customer added', '1 hour ago', Icons.person_add),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String title, String time, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(child: Text(title)),
          Text(time, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
        ],
      ),
    );
  }
}
