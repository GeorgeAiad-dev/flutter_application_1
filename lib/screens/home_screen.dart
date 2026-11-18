import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../theme/app_theme.dart';
import 'news_screens.dart';
import 'notifications_screen.dart';
import 'offers_screens.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onNavigateToMySubscription;
  final VoidCallback onNavigateToProfile;

  const HomeScreen({
    super.key,
    required this.onNavigateToMySubscription,
    required this.onNavigateToProfile,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  String _memberName = 'Guest';
  Map? _currentSubscription;
  List _offers = [];
  List _news = [];

  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }

  Future<void> _loadHomeData() async {
    setState(() => _isLoading = true);
    try {
      final user = _supabase.auth.currentUser;
      String name = 'Guest';
      Map? activeOrPendingSub;

      if (user != null) {
        final profile = await _supabase
            .from('profiles')
            .select('full_name')
            .eq('id', user.id)
            .maybeSingle();

        name =
            (profile?['full_name'] ??
                    user.userMetadata?['full_name'] ??
                    'Member')
                .toString();

        final subs = await _supabase
            .from('subscription_requests')
            .select()
            .eq('user_id', user.id)
            .order('created_at', ascending: false);

        for (final s in subs) {
          if (s['status'] == 'active') {
            activeOrPendingSub = s as Map;
            break;
          }
        }
        if (activeOrPendingSub == null) {
          for (final s in subs) {
            if (s['status'] == 'pending') {
              activeOrPendingSub = s as Map;
              break;
            }
          }
        }
      }

      final offersRes = await _supabase
          .from('offers')
          .select()
          .order('created_at', ascending: false)
          .limit(5);

      final newsRes = await _supabase
          .from('news')
          .select()
          .order('created_at', ascending: false)
          .limit(4);

      if (!mounted) return;
      setState(() {
        _memberName = name;
        _currentSubscription = activeOrPendingSub;
        _offers = List.from(offersRes);
        _news = List.from(newsRes);
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
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
    final firstName = _memberName.trim().split(' ').first;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primaryTeal,
          onRefresh: _loadHomeData,
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryTeal,
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: widget.onNavigateToProfile,
                          child: CircleAvatar(
                            radius: 22,
                            backgroundColor: AppColors.primaryTealLight,
                            child: Text(
                              firstName.isNotEmpty
                                  ? firstName[0].toUpperCase()
                                  : 'G',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryTeal,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'THE GYM',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                  color: AppColors.primaryTeal,
                                ),
                              ),
                              Text(
                                'Welcome, $firstName',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const NotificationsScreen(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.notifications_outlined,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildMembershipBanner(),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Special Offers',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const OffersListScreen(),
                              ),
                            );
                            _loadHomeData();
                          },
                          child: const Text(
                            'See all',
                            style: TextStyle(
                              color: AppColors.primaryTeal,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_offers.isEmpty)
                      const Card(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'No special offers available right now.',
                            style: TextStyle(color: AppColors.textGrey),
                          ),
                        ),
                      )
                    else
                      SizedBox(
                        height: 215,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _offers.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 14),
                          itemBuilder: (context, index) {
                            final offer = _offers[index] as Map;
                            return GestureDetector(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        OfferDetailsScreen(offer: offer),
                                  ),
                                );
                                _loadHomeData();
                              },
                              child: SizedBox(
                                width: 245,
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.network(
                                        (offer['image_url'] ?? '').toString(),
                                        height: 110,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          height: 110,
                                          color: AppColors.primaryTealLight,
                                          child: const Center(
                                            child: Icon(
                                              Icons.fitness_center,
                                              color: AppColors.primaryTeal,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              (offer['title'] ?? '').toString(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textDark,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              (offer['price'] ?? '').toString(),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primaryTeal,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              (offer['valid_until'] ?? '')
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: AppColors.textGrey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Latest News',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const NewsListScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'See all',
                            style: TextStyle(
                              color: AppColors.primaryTeal,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_news.isEmpty)
                      const Card(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'No news updates yet.',
                            style: TextStyle(color: AppColors.textGrey),
                          ),
                        ),
                      )
                    else
                      ..._news.map((item) {
                        final newsItem = item as Map;
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    NewsDetailsScreen(news: newsItem),
                              ),
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: Image.network(
                                      (newsItem['image_url'] ?? '').toString(),
                                      width: 72,
                                      height: 72,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        width: 72,
                                        height: 72,
                                        color: AppColors.primaryTealLight,
                                        child: const Icon(
                                          Icons.article_outlined,
                                          color: AppColors.primaryTeal,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          (newsItem['date_text'] ?? '')
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primaryTeal,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          (newsItem['title'] ?? '').toString(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textDark,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildMembershipBanner() {
    final sub = _currentSubscription;
    final isActive = sub != null && sub['status'] == 'active';
    final isPending = sub != null && sub['status'] == 'pending';

    return GestureDetector(
      onTap: widget.onNavigateToMySubscription,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.primaryTeal,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.activeGreenBg
                          : Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isActive
                          ? 'Active Membership'
                          : isPending
                          ? 'Pending Approval'
                          : 'Current Membership',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isActive
                            ? AppColors.activeGreenText
                            : Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isActive || isPending
                        ? (sub['plan_name'] ?? '').toString()
                        : 'No Active Plan',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isActive
                        ? '${_daysRemaining(sub['end_date'])} days remaining • Tap for details'
                        : isPending
                        ? 'Pay cash at reception to activate'
                        : 'Tap to view plans & start your fitness journey',
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white70,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
