import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../theme/app_theme.dart';
import 'auth_screens.dart';

class PlansScreen extends StatefulWidget {
  const PlansScreen({super.key});

  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  String? _errorMessage;
  List _plans = [];

  @override
  void initState() {
    super.initState();
    _loadPlans();
  }

  Future<void> _loadPlans() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final res = await _supabase
          .from('plans')
          .select()
          .order('duration_days', ascending: true);

      if (!mounted) return;
      setState(() {
        _plans = List.from(res);
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Could not load membership plans. Check your internet.';
        _isLoading = false;
      });
    }
  }

  Future<void> _requestPlan(Map plan) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please log in or create an account to subscribe.'),
          backgroundColor: AppColors.primaryTeal,
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Subscribe to ${plan['name']}'),
        content: Text(
          'Price: ${plan['price']}\n\nYour request will be sent to the reception desk. Pay cash at the gym to activate your membership.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Confirm Request'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final existingPending = await _supabase
          .from('subscription_requests')
          .select('id')
          .eq('user_id', user.id)
          .eq('status', 'pending')
          .maybeSingle();

      if (existingPending != null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'You already have a pending request waiting for reception approval.',
            ),
            backgroundColor: Colors.amber.shade800,
          ),
        );
        return;
      }

      await _supabase.from('subscription_requests').insert({
        'user_id': user.id,
        'plan_name': plan['name'].toString(),
        'price': plan['price'].toString(),
        'status': 'pending',
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Request sent for ${plan['name']}! Visit reception to complete cash payment.',
          ),
          backgroundColor: AppColors.primaryTeal,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit request: $e'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Membership Plans'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadPlans),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryTeal),
            )
          : _errorMessage != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textGrey),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _loadPlans,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          : _plans.isEmpty
          ? const Center(
              child: Text(
                'No membership plans available yet.',
                style: TextStyle(color: AppColors.textGrey),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: _plans.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final plan = _plans[index] as Map;
                final isBestValue = plan['is_best_value'] == true;

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                    side: BorderSide(
                      color: isBestValue
                          ? AppColors.primaryTeal
                          : AppColors.borderLight,
                      width: isBestValue ? 2 : 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              (plan['name'] ?? '').toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            if (isBestValue)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryTealLight,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'BEST VALUE',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryTeal,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          (plan['duration_text'] ?? '').toString(),
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textGrey,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          (plan['price'] ?? '').toString(),
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryTeal,
                          ),
                        ),
                        if ((plan['description'] ?? '')
                            .toString()
                            .isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Text(
                            plan['description'].toString(),
                            style: const TextStyle(
                              fontSize: 13,
                              height: 1.4,
                              color: AppColors.textGrey,
                            ),
                          ),
                        ],
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _requestPlan(plan),
                            child: const Text('Request Subscription'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
