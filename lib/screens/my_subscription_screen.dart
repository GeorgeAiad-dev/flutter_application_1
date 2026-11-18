import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../theme/app_theme.dart';
import 'auth_screens.dart';

class MySubscriptionScreen extends StatefulWidget {
  const MySubscriptionScreen({super.key});

  @override
  State<MySubscriptionScreen> createState() => _MySubscriptionScreenState();
}

class _MySubscriptionScreenState extends State<MySubscriptionScreen> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  List _requests = [];

  @override
  void initState() {
    super.initState();
    _loadMySubscriptions();
  }

  Future<void> _loadMySubscriptions() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      setState(() {
        _requests = [];
        _isLoading = false;
      });
      return;
    }

    setState(() => _isLoading = true);
    try {
      final res = await _supabase
          .from('subscription_requests')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      if (!mounted) return;
      setState(() {
        _requests = List.from(res);
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _cancelPendingRequest(dynamic requestId) async {
    try {
      await _supabase
          .from('subscription_requests')
          .update({'status': 'cancelled'})
          .eq('id', requestId);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pending request cancelled.'),
          backgroundColor: AppColors.primaryTeal,
        ),
      );
      _loadMySubscriptions();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not cancel request: $e'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  String _formatDate(dynamic isoString) {
    if (isoString == null) return '-';
    final dt = DateTime.tryParse(isoString.toString());
    if (dt == null) return '-';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  int _daysRemaining(dynamic endIso) {
    if (endIso == null) return 0;
    final end = DateTime.tryParse(endIso.toString());
    if (end == null) return 0;
    final diff = end.difference(DateTime.now()).inDays;
    return diff < 0 ? 0 : diff;
  }

  @override
  Widget build(BuildContext context) {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Subscription')),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppColors.primaryTealLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.badge_outlined,
                  size: 48,
                  color: AppColors.primaryTeal,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Log in to view your membership',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Track your active gym plan, remaining days, and subscription requests.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.textGrey),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final loggedIn = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                    if (loggedIn == true) _loadMySubscriptions();
                  },
                  child: const Text('Log in'),
                ),
              ),
            ],
          ),
        ),
      );
    }

    Map? activeSub;
    Map? pendingSub;
    for (final r in _requests) {
      if (activeSub == null && r['status'] == 'active') {
        activeSub = r as Map;
      }
      if (pendingSub == null && r['status'] == 'pending') {
        pendingSub = r as Map;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Subscription'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadMySubscriptions,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryTeal),
            )
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                if (activeSub != null) ...[
                  _buildActiveCard(activeSub),
                  const SizedBox(height: 16),
                ] else ...[
                  _buildNoActiveCard(),
                  const SizedBox(height: 16),
                ],
                if (pendingSub != null) ...[
                  _buildPendingCard(pendingSub),
                  const SizedBox(height: 20),
                ],
                const Text(
                  'Subscription History',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                if (_requests.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'No subscription requests yet. Go to Plans tab to join!',
                        style: TextStyle(color: AppColors.textGrey),
                      ),
                    ),
                  )
                else
                  ..._requests.map((item) => _buildHistoryTile(item as Map)),
              ],
            ),
    );
  }

  Widget _buildActiveCard(Map sub) {
    final daysLeft = _daysRemaining(sub['end_date']);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryTeal,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.activeGreenBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Active Membership',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.activeGreenText,
                  ),
                ),
              ),
              Text(
                '$daysLeft days left',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            (sub['plan_name'] ?? '').toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            (sub['price'] ?? '').toString(),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white24),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Start: ${_formatDate(sub['start_date'])}',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                'Expires: ${_formatDate(sub['end_date'])}',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNoActiveCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.secondaryFill,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.info_outline,
                color: AppColors.primaryTeal,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'No Active Membership',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Choose a plan from the Plans tab or claim a Special Offer.',
                    style: TextStyle(fontSize: 12, color: AppColors.textGrey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingCard(Map req) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(color: Colors.amber.shade400),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pending Approval',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade900,
                    fontSize: 14,
                  ),
                ),
                Text(
                  (req['price'] ?? '').toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryTeal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              (req['plan_name'] ?? '').toString(),
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Visit the gym reception to pay in cash and activate your subscription.',
              style: TextStyle(fontSize: 12, color: AppColors.textGrey),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red.shade700,
                  side: BorderSide(color: Colors.red.shade200),
                ),
                onPressed: () => _cancelPendingRequest(req['id']),
                child: const Text('Cancel Request'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTile(Map item) {
    final status = (item['status'] ?? 'pending').toString();
    Color badgeBg = AppColors.secondaryFill;
    Color badgeText = AppColors.textGrey;

    if (status == 'active') {
      badgeBg = AppColors.activeGreenBg;
      badgeText = AppColors.activeGreenText;
    } else if (status == 'pending') {
      badgeBg = Colors.amber.shade50;
      badgeText = Colors.amber.shade900;
    } else if (status == 'rejected' || status == 'cancelled') {
      badgeBg = Colors.red.shade50;
      badgeText = Colors.red.shade700;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(
          (item['plan_name'] ?? '').toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Text(
          '${item['price']} • Requested ${_formatDate(item['created_at'])}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: badgeBg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            status.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: badgeText,
            ),
          ),
        ),
      ),
    );
  }
}
