import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../theme/app_theme.dart';
import 'auth_screens.dart';

class OffersListScreen extends StatefulWidget {
  const OffersListScreen({super.key});

  @override
  State<OffersListScreen> createState() => _OffersListScreenState();
}

class _OffersListScreenState extends State<OffersListScreen> {
  final _supabase = Supabase.instance.client;
  final _searchController = TextEditingController();

  bool _isLoading = true;
  String? _errorMessage;
  List _offers = [];
  Set _savedOfferIds = {};
  String _selectedFilter = 'All';

  final List _filters = ['All', 'Saved', 'Limited spots', 'Best value', 'New'];

  @override
  void initState() {
    super.initState();
    _loadOffersAndWishlist();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadOffersAndWishlist() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final offersRes = await _supabase
          .from('offers')
          .select()
          .order('created_at', ascending: false);

      Set savedIds = {};
      final user = _supabase.auth.currentUser;
      if (user != null) {
        final savedRes = await _supabase
            .from('saved_offers')
            .select('offer_id')
            .eq('user_id', user.id);
        savedIds = List.from(savedRes)
            .map((e) => e['offer_id'].toString())
            .toSet();
      }

      if (!mounted) return;
      setState(() {
        _offers = List.from(offersRes);
        _savedOfferIds = savedIds;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage =
            'Could not load offers. Check your internet connection.';
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleSaveOffer(String offerId) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please log in to save offers to your wishlist.'),
          backgroundColor: AppColors.primaryTeal,
        ),
      );
      final loggedIn = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      if (loggedIn == true) _loadOffersAndWishlist();
      return;
    }

    final isCurrentlySaved = _savedOfferIds.contains(offerId);
    setState(() {
      if (isCurrentlySaved) {
        _savedOfferIds.remove(offerId);
      } else {
        _savedOfferIds.add(offerId);
      }
    });

    try {
      if (isCurrentlySaved) {
        await _supabase
            .from('saved_offers')
            .delete()
            .eq('user_id', user.id)
            .eq('offer_id', offerId);
      } else {
        await _supabase.from('saved_offers').insert({
          'user_id': user.id,
          'offer_id': offerId,
        });
      }
    } catch (_) {
      _loadOffersAndWishlist();
    }
  }

  List get _filteredOffers {
    final query = _searchController.text.trim().toLowerCase();
    return _offers.where((offer) {
      final title = (offer['title'] ?? '').toString().toLowerCase();
      final subtitle = (offer['subtitle'] ?? '').toString().toLowerCase();
      final badge = (offer['badge'] ?? '').toString();
      final id = offer['id'].toString();

      final matchesSearch =
          query.isEmpty || title.contains(query) || subtitle.contains(query);

      bool matchesFilter = true;
      if (_selectedFilter == 'Saved') {
        matchesFilter = _savedOfferIds.contains(id);
      } else if (_selectedFilter != 'All') {
        matchesFilter = badge.toLowerCase() == _selectedFilter.toLowerCase();
      }

      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredOffers;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Special Offers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadOffersAndWishlist,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search offers...',
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.primaryTeal,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.borderLight),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.borderLight),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 38,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final filter = _filters[index].toString();
                final isSelected = _selectedFilter == filter;
                return ChoiceChip(
                  label: Text(filter),
                  selected: isSelected,
                  selectedColor: AppColors.primaryTeal,
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  onSelected: (_) => setState(() => _selectedFilter = filter),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryTeal,
                    ),
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
                            onPressed: _loadOffersAndWishlist,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  )
                : filtered.isEmpty
                ? Center(
                    child: Text(
                      _selectedFilter == 'Saved'
                          ? 'No saved offers yet. Tap the heart icon to save!'
                          : 'No offers match your search.',
                      style: const TextStyle(color: AppColors.textGrey),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final offer = filtered[index] as Map;
                      final offerId = offer['id'].toString();
                      final isSaved = _savedOfferIds.contains(offerId);

                      return GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OfferDetailsScreen(
                                offer: offer,
                                isSaved: isSaved,
                              ),
                            ),
                          );
                          _loadOffersAndWishlist();
                        },
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Image.network(
                                    (offer['image_url'] ?? '').toString(),
                                    height: 160,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      height: 160,
                                      color: AppColors.primaryTealLight,
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
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        (offer['badge'] ?? 'Offer').toString(),
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primaryTeal,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 18,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: Icon(
                                          isSaved
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: isSaved
                                              ? Colors.red
                                              : AppColors.textDark,
                                          size: 20,
                                        ),
                                        onPressed: () =>
                                            _toggleSaveOffer(offerId),
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
                                    Text(
                                      (offer['title'] ?? '').toString(),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      (offer['subtitle'] ?? '').toString(),
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textGrey,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Text(
                                          (offer['price'] ?? '').toString(),
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primaryTeal,
                                          ),
                                        ),
                                        if (offer['old_price'] != null &&
                                            offer['old_price']
                                                .toString()
                                                .isNotEmpty) ...[
                                          const SizedBox(width: 8),
                                          Text(
                                            offer['old_price'].toString(),
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: AppColors.textGrey,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                            ),
                                          ),
                                        ],
                                        const Spacer(),
                                        Text(
                                          (offer['valid_until'] ?? '')
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textGrey,
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
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class OfferDetailsScreen extends StatefulWidget {
  final Map offer;
  final bool isSaved;

  const OfferDetailsScreen({
    super.key,
    required this.offer,
    this.isSaved = false,
  });

  @override
  State<OfferDetailsScreen> createState() => _OfferDetailsScreenState();
}

class _OfferDetailsScreenState extends State<OfferDetailsScreen> {
  final _supabase = Supabase.instance.client;
  late bool _isSaved;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _isSaved = widget.isSaved;
  }

  Future<void> _toggleSave() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please log in to save this offer.'),
          backgroundColor: AppColors.primaryTeal,
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      return;
    }

    final offerId = widget.offer['id'].toString();
    setState(() => _isSaved = !_isSaved);

    try {
      if (_isSaved) {
        await _supabase.from('saved_offers').insert({
          'user_id': user.id,
          'offer_id': offerId,
        });
      } else {
        await _supabase
            .from('saved_offers')
            .delete()
            .eq('user_id', user.id)
            .eq('offer_id', offerId);
      }
    } catch (_) {}
  }

  Future<void> _requestOfferSubscription() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please log in or create an account first.'),
          backgroundColor: AppColors.primaryTeal,
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await _supabase.from('subscription_requests').insert({
        'user_id': user.id,
        'plan_name': '${widget.offer['title']} (Offer)',
        'price': widget.offer['price'].toString(),
        'status': 'pending',
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Request sent for ${widget.offer['title']}! Pay cash at reception to activate.',
          ),
          backgroundColor: AppColors.primaryTeal,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not send request: $e'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final offer = widget.offer;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Offer Details'),
        actions: [
          IconButton(
            icon: Icon(
              _isSaved ? Icons.favorite : Icons.favorite_border,
              color: _isSaved ? Colors.red : AppColors.textDark,
            ),
            onPressed: _toggleSave,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              (offer['image_url'] ?? '').toString(),
              height: 230,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 230,
                color: AppColors.primaryTealLight,
                child: const Center(
                  child: Icon(
                    Icons.fitness_center,
                    size: 54,
                    color: AppColors.primaryTeal,
                  ),
                ),
              ),
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
                      (offer['badge'] ?? 'Offer').toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryTeal,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    (offer['title'] ?? '').toString(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    (offer['subtitle'] ?? '').toString(),
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.textGrey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        (offer['price'] ?? '').toString(),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryTeal,
                        ),
                      ),
                      if (offer['old_price'] != null &&
                          offer['old_price'].toString().isNotEmpty) ...[
                        const SizedBox(width: 10),
                        Text(
                          offer['old_price'].toString(),
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.textGrey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'About this offer',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    (offer['description'] ?? '').toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: AppColors.textGrey,
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSubmitting
                          ? null
                          : _requestOfferSubscription,
                      child: _isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Request Subscription (Cash)'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
