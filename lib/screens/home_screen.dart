import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../theme/app_theme.dart';
import 'news_screens.dart';
import 'offers_screens.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onNavigateToMySubscription;
  final VoidCallback onNavigateToProfile;

  const HomeScreen({
    super.key,
    required this.onNavigateToMySubscription,
    required this.onNavigateToProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primaryTeal,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.fitness_center,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'THE GYM',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: AppColors.primaryTeal,
                          ),
                        ),
                        Text(
                          'Hello, ${SampleData.userName} 👋',
                          style: TextStyle(
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Notifications screen coming in Part 3',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.notifications_none_rounded,
                      color: AppColors.textDark,
                    ),
                  ),
                  GestureDetector(
                    onTap: onNavigateToProfile,
                    child: const CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primaryTealLight,
                      child: Text(
                        'A',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryTeal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Current Membership Card
              const Text(
                'CURRENT MEMBERSHIP',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                  color: AppColors.textGrey,
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: onNavigateToMySubscription,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  SampleData.currentPlanName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  SampleData.currentPlanSubtitle,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textGrey,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.activeGreenBg,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.circle,
                                    size: 8,
                                    color: AppColors.activeGreenText,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Active',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.activeGreenText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: AppColors.secondaryFill,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Time Remaining',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textGrey,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '${SampleData.daysLeft} days left',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryTeal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: AppColors.secondaryFill,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Valid Until',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textGrey,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      SampleData.validUntil,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: const LinearProgressIndicator(
                            value: SampleData.elapsedProgress,
                            minHeight: 8,
                            backgroundColor: AppColors.secondaryFill,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primaryTeal,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '53% elapsed',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textGrey,
                              ),
                            ),
                            Text(
                              'Details >',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryTeal,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 26),

              // Offers Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Offers',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        'Special upgrades & packages',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const OffersListScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'View all →',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryTeal,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 270,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: SampleData.offers.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final offer = SampleData.offers[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OfferDetailsScreen(offer: offer),
                          ),
                        );
                      },
                      child: SizedBox(
                        width: 245,
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Image.network(
                                    offer.imageUrl,
                                    height: 130,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      height: 130,
                                      color: AppColors.secondaryFill,
                                      child: const Center(
                                        child: Icon(
                                          Icons.fitness_center,
                                          color: AppColors.primaryTeal,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    left: 10,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.92),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        offer.badge,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primaryTeal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      offer.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      offer.subtitle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textGrey,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              offer.price,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primaryTeal,
                                              ),
                                            ),
                                            if (offer.oldPrice != null)
                                              Text(
                                                offer.oldPrice!,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: AppColors.textGrey,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                ),
                                              ),
                                          ],
                                        ),
                                        Container(
                                          width: 34,
                                          height: 34,
                                          decoration: const BoxDecoration(
                                            color: AppColors.primaryTeal,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ],
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
              const SizedBox(height: 26),

              // Latest News Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Latest News',
                    style: TextStyle(
                      fontSize: 20,
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
                      'View all →',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryTeal,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...SampleData.news.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NewsDetailsScreen(newsItem: item),
                        ),
                      );
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.network(
                                item.imageUrl,
                                width: 72,
                                height: 72,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 72,
                                  height: 72,
                                  color: AppColors.secondaryFill,
                                  child: const Icon(
                                    Icons.article_outlined,
                                    color: AppColors.primaryTeal,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.date,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryTeal,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.title,
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
                            const Icon(
                              Icons.chevron_right,
                              color: AppColors.textGrey,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
