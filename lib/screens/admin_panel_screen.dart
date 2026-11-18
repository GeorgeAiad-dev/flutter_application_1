import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/app_theme.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  bool _isAdmin = false;

  List _requests = [];
  List _members = [];
  List _plans = [];
  List _offers = [];
  List _news = [];

  @override
  void initState() {
    super.initState();
    _loadAdminData();
  }

  Future<void> _loadAdminData() async {
    setState(() => _isLoading = true);
    try {
      final user = _supabase.auth.currentUser;
      if (user != null) {
        final profile = await _supabase
            .from('profiles')
            .select('role')
            .eq('id', user.id)
            .maybeSingle();
        _isAdmin = profile?['role'] == 'admin';
      }

      final reqData = await _supabase
          .from('subscription_requests')
          .select('*, profiles(full_name, phone, email)')
          .order('created_at', ascending: false);

      final memData = await _supabase
          .from('profiles')
          .select()
          .order('created_at', ascending: false);

      final plansData = await _supabase
          .from('plans')
          .select()
          .order('duration_days', ascending: true);

      final offersData = await _supabase
          .from('offers')
          .select()
          .order('created_at', ascending: false);

      final newsData = await _supabase
          .from('news')
          .select()
          .order('created_at', ascending: false);

      if (!mounted) return;
      setState(() {
        _requests = List.from(reqData);
        _members = List.from(memData);
        _plans = List.from(plansData);
        _offers = List.from(offersData);
        _news = List.from(newsData);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading admin data: $e'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  Future<void> _handleRequest(Map req, bool approve) async {
    try {
      final now = DateTime.now();
      final planName = (req['plan_name'] ?? '').toString();
      int days = 30;
      if (planName.contains('3')) {
        days = 90;
      } else if (planName.contains('6')) {
        days = 180;
      } else if (planName.contains('12')) {
        days = 365;
      }

      await _supabase.from('subscription_requests').update({
        'status': approve ? 'active' : 'rejected',
        if (approve) 'start_date': now.toIso8601String(),
        if (approve) 'end_date': now.add(Duration(days: days)).toIso8601String(),
      }).eq('id', req['id']);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            approve
                ? 'Subscription activated successfully!'
                : 'Subscription request rejected.',
          ),
          backgroundColor:
              approve ? AppColors.primaryTeal : Colors.red.shade700,
        ),
      );
      _loadAdminData();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Action failed (make sure your role is admin): $e'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  Future<String?> _uploadImage(XFile file, String folder) async {
    final Uint8List bytes = await file.readAsBytes();
    final ext = file.name.split('.').last;
    final path = '$folder/${DateTime.now().millisecondsSinceEpoch}.$ext';

    await _supabase.storage.from('gym-images').uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(contentType: 'image/$ext', upsert: true),
        );

    return _supabase.storage.from('gym-images').getPublicUrl(path);
  }

  Future<void> _deleteItem(String table, dynamic id) async {
    try {
      await _supabase.from(table).delete().eq('id', id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Deleted successfully.'),
          backgroundColor: AppColors.primaryTeal,
        ),
      );
      _loadAdminData();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Delete failed: $e'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pendingRequests =
        _requests.where((r) => r['status'] == 'pending').toList();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadAdminData,
            ),
          ],
          bottom: TabBar(
            labelColor: AppColors.primaryTeal,
            unselectedLabelColor: AppColors.textGrey,
            indicatorColor: AppColors.primaryTeal,
            tabs: [
              Tab(text: 'Requests (${pendingRequests.length})'),
              Tab(text: 'Members (${_members.length})'),
              const Tab(text: 'Manage'),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primaryTeal),
              )
            : Column(
                children: [
                  if (!_isAdmin)
                    Container(
                      width: double.infinity,
                      color: Colors.amber.shade100,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: Text(
                        'Note: Your account role is "member". Set role = "admin" in Supabase profiles table to save changes.',
                        style: TextStyle(
                            fontSize: 12, color: Colors.amber.shade900),
                      ),
                    ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildRequestsTab(pendingRequests),
                        _buildMembersTab(),
                        _buildManageTab(),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildRequestsTab(List pending) {
    if (pending.isEmpty) {
      return const Center(
        child: Text(
          'No pending subscription requests',
          style: TextStyle(color: AppColors.textGrey, fontSize: 15),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: pending.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final req = pending[index] as Map;
        final profile = req['profiles'] as Map?;
        final memberName = profile?['full_name'] ?? 'Gym Member';
        final phone = profile?['phone'] ?? '';

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      memberName.toString(),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Pending Cash',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
                if (phone.toString().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    phone.toString(),
                    style:
                        const TextStyle(fontSize: 12, color: AppColors.textGrey),
                  ),
                ],
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryFill,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        (req['plan_name'] ?? '').toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
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
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red.shade700,
                          side: BorderSide(color: Colors.red.shade200),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () => _handleRequest(req, false),
                        child: const Text('Reject'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _handleRequest(req, true),
                        child: const Text('Activate'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMembersTab() {
    if (_members.isEmpty) {
      return const Center(
        child: Text('No registered members yet',
            style: TextStyle(color: AppColors.textGrey)),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: _members.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final member = _members[index] as Map;
        final name = (member['full_name'] ?? 'Member').toString();
        final email = (member['email'] ?? '').toString();
        final role = (member['role'] ?? 'member').toString();

        Map? activeSub;
        for (final r in _requests) {
          if (r['user_id'] == member['id'] && r['status'] == 'active') {
            activeSub = r as Map;
            break;
          }
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primaryTealLight,
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : 'M',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryTeal,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        activeSub != null
                            ? '${activeSub['plan_name']} • ${activeSub['price']}'
                            : email,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: activeSub != null
                        ? AppColors.activeGreenBg
                        : AppColors.secondaryFill,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    activeSub != null ? 'Active' : role.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: activeSub != null
                          ? AppColors.activeGreenText
                          : AppColors.textGrey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildManageTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _manageHeader(
          icon: Icons.card_membership_outlined,
          title: 'Membership Plans (${_plans.length})',
          actionLabel: '+ Add Plan',
          onAdd: _showAddPlanDialog,
        ),
        ..._plans.map((p) => _itemTile(
              title: p['name'].toString(),
              subtitle: '${p['price']} • ${p['duration_text']}',
              onDelete: () => _deleteItem('plans', p['id']),
            )),
        const SizedBox(height: 20),
        _manageHeader(
          icon: Icons.local_offer_outlined,
          title: 'Special Offers (${_offers.length})',
          actionLabel: '+ Add Offer',
          onAdd: _showAddOfferDialog,
        ),
        ..._offers.map((o) => _itemTile(
              title: o['title'].toString(),
              subtitle: '${o['price']} • ${o['valid_until']}',
              onDelete: () => _deleteItem('offers', o['id']),
            )),
        const SizedBox(height: 20),
        _manageHeader(
          icon: Icons.article_outlined,
          title: 'Gym News (${_news.length})',
          actionLabel: '+ Post News',
          onAdd: _showAddNewsDialog,
        ),
        ..._news.map((n) => _itemTile(
              title: n['title'].toString(),
              subtitle: n['date_text'].toString(),
              onDelete: () => _deleteItem('news', n['id']),
            )),
      ],
    );
  }

  Widget _manageHeader({
    required IconData icon,
    required String title,
    required String actionLabel,
    required VoidCallback onAdd,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryTeal, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
          ),
          TextButton(
            onPressed: onAdd,
            child: Text(
              actionLabel,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryTeal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemTile({
    required String title,
    required String subtitle,
    required VoidCallback onDelete,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: IconButton(
          icon: Icon(Icons.delete_outline, color: Colors.red.shade600, size: 20),
          onPressed: onDelete,
        ),
      ),
    );
  }

  void _showAddPlanDialog() {
    final nameCtrl = TextEditingController();
    final durationTextCtrl = TextEditingController(text: '30 days full access');
    final daysCtrl = TextEditingController(text: '30');
    final priceCtrl = TextEditingController(text: '600 EGP');
    final descCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New Plan'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Plan Name (e.g. 6 Months)')),
              TextField(
                  controller: durationTextCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Duration Subtitle')),
              TextField(
                  controller: daysCtrl,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Duration in Days')),
              TextField(
                  controller: priceCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Price (e.g. 2,200 EGP)')),
              TextField(
                  controller: descCtrl,
                  decoration: const InputDecoration(labelText: 'Description')),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (nameCtrl.text.trim().isEmpty) return;
              Navigator.pop(ctx);
              await _supabase.from('plans').insert({
                'name': nameCtrl.text.trim(),
                'duration_text': durationTextCtrl.text.trim(),
                'duration_days': int.tryParse(daysCtrl.text.trim()) ?? 30,
                'price': priceCtrl.text.trim(),
                'description': descCtrl.text.trim(),
                'is_best_value': false,
              });
              _loadAdminData();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAddOfferDialog() {
    final titleCtrl = TextEditingController();
    final subCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final priceCtrl = TextEditingController(text: '1,500 EGP');
    final oldPriceCtrl = TextEditingController(text: '2,000 EGP');
    final validCtrl = TextEditingController(text: 'Ends Dec 31');
    XFile? pickedImage;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Add Special Offer'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton.icon(
                  onPressed: () async {
                    final img = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (img != null) {
                      setDialogState(() => pickedImage = img);
                    }
                  },
                  icon: const Icon(Icons.image_outlined),
                  label: Text(pickedImage == null
                      ? 'Pick Offer Photo'
                      : 'Photo Selected ✓'),
                ),
                TextField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(labelText: 'Offer Title')),
                TextField(
                    controller: subCtrl,
                    decoration: const InputDecoration(labelText: 'Subtitle')),
                TextField(
                    controller: priceCtrl,
                    decoration: const InputDecoration(labelText: 'Offer Price')),
                TextField(
                    controller: oldPriceCtrl,
                    decoration: const InputDecoration(labelText: 'Old Price')),
                TextField(
                    controller: validCtrl,
                    decoration: const InputDecoration(labelText: 'Valid Until')),
                TextField(
                    controller: descCtrl,
                    decoration:
                        const InputDecoration(labelText: 'Full Description')),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (titleCtrl.text.trim().isEmpty) return;
                Navigator.pop(ctx);
                String imageUrl =
                    'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800&q=80';
                if (pickedImage != null) {
                  imageUrl =
                      await _uploadImage(pickedImage!, 'offers') ?? imageUrl;
                }
                await _supabase.from('offers').insert({
                  'title': titleCtrl.text.trim(),
                  'subtitle': subCtrl.text.trim(),
                  'description': descCtrl.text.trim(),
                  'badge': 'New',
                  'price': priceCtrl.text.trim(),
                  'old_price': oldPriceCtrl.text.trim(),
                  'valid_until': validCtrl.text.trim(),
                  'image_url': imageUrl,
                });
                _loadAdminData();
              },
              child: const Text('Publish'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddNewsDialog() {
    final titleCtrl = TextEditingController();
    final dateCtrl = TextEditingController(text: 'Nov 18, 2026');
    final bodyCtrl = TextEditingController();
    XFile? pickedImage;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Post Gym News'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton.icon(
                  onPressed: () async {
                    final img = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (img != null) {
                      setDialogState(() => pickedImage = img);
                    }
                  },
                  icon: const Icon(Icons.image_outlined),
                  label: Text(pickedImage == null
                      ? 'Pick News Photo'
                      : 'Photo Selected ✓'),
                ),
                TextField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(labelText: 'Headline')),
                TextField(
                    controller: dateCtrl,
                    decoration: const InputDecoration(labelText: 'Date')),
                TextField(
                    controller: bodyCtrl,
                    maxLines: 3,
                    decoration:
                        const InputDecoration(labelText: 'Article Body')),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (titleCtrl.text.trim().isEmpty) return;
                Navigator.pop(ctx);
                String imageUrl =
                    'https://images.unsplash.com/photo-1540497077202-7c8a3999166f?w=800&q=80';
                if (pickedImage != null) {
                  imageUrl =
                      await _uploadImage(pickedImage!, 'news') ?? imageUrl;
                }
                await _supabase.from('news').insert({
                  'title': titleCtrl.text.trim(),
                  'date_text': dateCtrl.text.trim(),
                  'body': bodyCtrl.text.trim(),
                  'image_url': imageUrl,
                });
                _loadAdminData();
              },
              child: const Text('Post'),
            ),
          ],
        ),
      ),
    );
  }
}