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

class SampleData {
  // بيانات المستخدم التجريبية (نفس اللي في موك اب Stitch)
  static const String userName = 'Ahmed';
  static const String currentPlanName = '3-Month Plan';
  static const String currentPlanSubtitle = 'Unlimited gym & pool';
  static const int daysLeft = 42;
  static const String validUntil = 'Dec 29, 2026';
  static const double elapsedProgress = 0.53; // 53%

  // قائمة العروض التجريبية
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

  // قائمة الأخبار التجريبية
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
}
