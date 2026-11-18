class OfferItem {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String badge;
  final String price;
  final String? oldPrice;
  final String validUntil;
  final String imageUrl;

  const OfferItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.badge,
    required this.price,
    this.oldPrice,
    required this.validUntil,
    required this.imageUrl,
  });
}

class NewsItem {
  final String id;
  final String title;
  final String date;
  final String body;
  final String imageUrl;

  const NewsItem({
    required this.id,
    required this.title,
    required this.date,
    required this.body,
    required this.imageUrl,
  });
}

class PlanItem {
  final String id;
  final String name;
  final String durationText;
  final String price;
  final String description;
  final bool isBestValue;

  const PlanItem({
    required this.id,
    required this.name,
    required this.durationText,
    required this.price,
    required this.description,
    this.isBestValue = false,
  });
}

class SubscriptionHistoryItem {
  final String planName;
  final String dateRange;
  final String status; // 'Expired' or 'Cancelled'

  const SubscriptionHistoryItem({
    required this.planName,
    required this.dateRange,
    required this.status,
  });
}

class NotificationItem {
  final String title;
  final String body;
  final String time;
  final bool isUnread;

  const NotificationItem({
    required this.title,
    required this.body,
    required this.time,
    this.isUnread = false,
  });
}

class SampleData {
  static const String userName = 'Ahmed';
  static const String currentPlanName = '3-Month Plan';
  static const String currentPlanSubtitle = 'Unlimited gym & pool';
  static const int daysLeft = 42;
  static const String validUntil = 'Dec 29, 2026';
  static const double elapsedProgress = 0.53;

  static const List<OfferItem> offers = [
    OfferItem(
      id: 'off_1',
      title: '12 PT Sessions',
      subtitle: 'Personal coaching & body scan',
      description: 'Get 12 one-on-one personal training sessions with our certified coaches, including a full InBody assessment and customized nutrition guidance.',
      badge: 'Limited spots',
      price: '2,100 EGP',
      oldPrice: '2,600 EGP',
      validUntil: 'Ends Nov 30',
      imageUrl: 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800&q=80',
    ),
    OfferItem(
      id: 'off_2',
      title: 'Winter Transformation',
      subtitle: '6-Month full facility access',
      description: 'Enjoy unlimited access to the gym floor, cardio zone, sauna, and group classes for 6 full months at a special seasonal discount.',
      badge: 'Best value',
      price: '2,400 EGP',
      oldPrice: '3,000 EGP',
      validUntil: 'Ends Dec 15',
      imageUrl: 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=800&q=80',
    ),
    OfferItem(
      id: 'off_3',
      title: 'Bring a Friend Pass',
      subtitle: '1-Month dual membership',
      description: 'Train together and stay motivated! Sign up with a workout partner and get two 1-month full memberships for a discounted bundle price.',
      badge: 'New',
      price: '850 EGP',
      oldPrice: '1,000 EGP',
      validUntil: 'Ends Dec 05',
      imageUrl: 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=800&q=80',
    ),
  ];

  static const List<NewsItem> news = [
    NewsItem(
      id: 'news_1',
      title: 'New Cardio & Functional Zone Now Open',
      date: 'Nov 14, 2026',
      body: 'We have expanded our second-floor training area with brand-new treadmills, rowing machines, and a dedicated functional turf zone. Come check it out during your next workout!',
      imageUrl: 'https://images.unsplash.com/photo-1540497077202-7c8a3999166f?w=800&q=80',
    ),
    NewsItem(
      id: 'news_2',
      title: 'Updated Friday Operating Hours',
      date: 'Nov 10, 2026',
      body: 'Starting this week, The Gym will open on Fridays from 1:00 PM until 12:00 AM midnight to give you more flexibility for your weekend training sessions.',
      imageUrl: 'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?w=800&q=80',
    ),
  ];

  // الباقات التجريبية
  static const List<PlanItem> plans = [
    PlanItem(
      id: 'plan_1m',
      name: '1 Month',
      durationText: '30 days full access',
      price: '500 EGP',
      description: 'Full access to gym equipment and locker rooms.',
    ),
    PlanItem(
      id: 'plan_3m',
      name: '3 Months',
      durationText: '90 days full access',
      price: '1,300 EGP',
      description: 'Unlimited gym & pool access + 1 free InBody session.',
      isBestValue: true,
    ),
    PlanItem(
      id: 'plan_12m',
      name: '12 Months',
      durationText: '365 days full access',
      price: '4,500 EGP',
      description: 'All-year unlimited access + 2 free freeze weeks.',
    ),
  ];

  // سجل الاشتراكات السابقة
  static const List<SubscriptionHistoryItem> subscriptionHistory = [
    SubscriptionHistoryItem(
      planName: '1-Month Plan',
      dateRange: 'Aug 15, 2026 – Sep 14, 2026',
      status: 'Expired',
    ),
    SubscriptionHistoryItem(
      planName: '3-Month Plan',
      dateRange: 'May 01, 2026 – Jul 30, 2026',
      status: 'Expired',
    ),
    SubscriptionHistoryItem(
      planName: '1-Month Plan',
      dateRange: 'Apr 10, 2026',
      status: 'Cancelled',
    ),
  ];

  // الإشعارات التجريبية
  static const List<NotificationItem> notifications = [
    NotificationItem(
      title: 'Your subscription is now active',
      body: 'Your 3-Month Plan has been activated. Enjoy your workouts!',
      time: '2h ago',
      isUnread: true,
    ),
    NotificationItem(
      title: 'New offer: Winter Transformation',
      body: 'Get 6 months full facility access for 2,400 EGP instead of 3,000 EGP.',
      time: '1d ago',
      isUnread: true,
    ),
    NotificationItem(
      title: 'Your plan ends in 3 days',
      body: 'Visit the reception desk to renew your previous membership.',
      time: 'Sep 11, 2026',
      isUnread: false,
    ),
  ];
}
