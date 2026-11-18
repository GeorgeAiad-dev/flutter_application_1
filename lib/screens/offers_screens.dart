import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../theme/app_theme.dart';

class OffersListScreen extends StatelessWidget {
  const OffersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Offers')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: SampleData.offers.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
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
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Image.network(
                        offer.imageUrl,
                        height: 170,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 170,
                          color: AppColors.secondaryFill,
                          child: const Center(
                            child: Icon(
                              Icons.fitness_center,
                              size: 40,
                              color: AppColors.primaryTeal,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.92),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            offer.badge,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryTeal,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                offer.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ),
                            Text(
                              offer.validUntil,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textGrey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          offer.subtitle,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textGrey,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Text(
                              offer.price,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryTeal,
                              ),
                            ),
                            if (offer.oldPrice != null) ...[
                              const SizedBox(width: 8),
                              Text(
                                offer.oldPrice!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textGrey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
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

class OfferDetailsScreen extends StatelessWidget {
  final OfferItem offer;
  const OfferDetailsScreen({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Image.network(
                        offer.imageUrl,
                        height: 280,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 280,
                          color: AppColors.secondaryFill,
                          child: const Center(
                            child: Icon(
                              Icons.fitness_center,
                              size: 50,
                              color: AppColors.primaryTeal,
                            ),
                          ),
                        ),
                      ),
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: AppColors.textDark,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryTealLight,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            offer.validUntil,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryTeal,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          offer.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              offer.price,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryTeal,
                              ),
                            ),
                            if (offer.oldPrice != null) ...[
                              const SizedBox(width: 10),
                              Text(
                                offer.oldPrice!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textGrey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'ABOUT THIS OFFER',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                            color: AppColors.textGrey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          offer.description,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.6,
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
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Offer "${offer.title}" requested! Pay cash at the gym.',
                        ),
                        backgroundColor: AppColors.primaryTeal,
                      ),
                    );
                  },
                  child: const Text('Request Subscription'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
