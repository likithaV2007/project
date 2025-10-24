import 'package:flutter/material.dart';
import 'wish_screen.dart';
import 'profile_screen.dart';
import 'friends_screen.dart';
import '../utils/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  final List<Map<String, dynamic>> _publicBucketLists = [
    {
      'name': 'John Doe',
      'wishes': [
        {'text': 'Travel to Japan', 'completed': false},
        {'text': 'Learn guitar', 'completed': false},
        {'text': 'Write a book', 'completed': true},
      ],
      'avatar': Icons.person,
      'color': AppColors.success,
    },
    {
      'name': 'Jane Smith',
      'wishes': [
        {'text': 'Skydiving', 'completed': false},
        {'text': 'Visit all continents', 'completed': false},
        {'text': 'Start a charity', 'completed': true},
      ],
      'avatar': Icons.person_2,
      'color': AppColors.info,
    },
    {
      'name': 'Mike Johnson',
      'wishes': [
        {'text': 'Run a marathon', 'completed': false},
        {'text': 'Learn cooking', 'completed': false},
        {'text': 'Build a house', 'completed': false},
      ],
      'avatar': Icons.person_3,
      'color': AppColors.warning,
    },
  ];

  final List<Map<String, dynamic>> _notifications = [
    {
      'name': 'Sarah Wilson',
      'message': 'wants to share their death wish list with you',
      'time': '2 hours ago',
      'type': 'death_wish_request',
    },
    {
      'name': 'Alex Chen',
      'message': 'completed a wish from their bucket list',
      'time': '1 day ago',
      'type': 'wish_completed',
    },
  ];

  late AnimationController _listController;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _listController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _slideAnimations = List.generate(
      _publicBucketLists.length,
      (index) => Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _listController,
        curve: Interval(
          index * 0.2,
          (index * 0.2) + 0.6,
          curve: Curves.easeOutCubic,
        ),
      )),
    );
    
    _listController.forward();
  }

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildWelcomeSection(),
              Expanded(
                child: _buildBucketListSection(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const WishScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 1),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
              ),
            );
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, color: AppColors.textOnGradient, size: 28),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Hero(
            tag: 'logo',
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.favorite, color: AppColors.textOnGradient, size: 24),
            ),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Text(
              'Death Wish',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textOnGradient,
              ),
            ),
          ),
          Stack(
            children: [
              IconButton(
                onPressed: _showNotifications,
                icon: const Icon(Icons.notifications, color: AppColors.textOnGradient),
              ),
              if (_notifications.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      _notifications.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FriendsScreen()),
              );
            },
            icon: const Icon(Icons.people, color: AppColors.textOnGradient),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => const ProfileScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                ),
              );
            },
            icon: const Icon(Icons.person, color: AppColors.textOnGradient),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Discover Dreams',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textOnGradient,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Explore public bucket lists from our community',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textOnGradient,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBucketListSection() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView.builder(
        itemCount: _publicBucketLists.length,
        itemBuilder: (context, index) {
          final bucketList = _publicBucketLists[index];
          return SlideTransition(
            position: _slideAnimations[index],
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                gradient: AppColors.surfaceGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => _showBucketListDetails(bucketList),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: bucketList['color'],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            bucketList['avatar'],
                            color: AppColors.textPrimary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bucketList['name'],
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${bucketList['wishes'].where((w) => !w['completed']).length} active wishes',
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.textPrimary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.textPrimary,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showNotifications() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            gradient: AppColors.surfaceGradient,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Row(
                children: [
                  Icon(Icons.notifications, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text(
                    'Notifications',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ..._notifications.map((notification) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.textPrimary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.primary,
                          child: Text(
                            notification['name'][0],
                            style: const TextStyle(
                              color: AppColors.textOnGradient,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: notification['name'],
                                      style: const TextStyle(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' ${notification['message']}',
                                      style: const TextStyle(
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                notification['time'],
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (notification['type'] == 'death_wish_request')...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.success,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _notifications.remove(notification);
                                  });
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Access granted!')),
                                  );
                                },
                                child: const Text(
                                  'Accept',
                                  style: TextStyle(color: AppColors.textOnGradient),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _notifications.remove(notification);
                                  });
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Decline',
                                  style: TextStyle(color: AppColors.textOnGradient),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              )),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Close',
                    style: TextStyle(color: AppColors.textOnGradient),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBucketListDetails(Map<String, dynamic> bucketList) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            gradient: AppColors.surfaceGradient,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: bucketList['color'],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      bucketList['avatar'],
                      color: AppColors.textPrimary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${bucketList['name']}\'s Bucket List',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ...bucketList['wishes'].where((wish) => !wish['completed']).map<Widget>((wish) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.textPrimary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => _completeWish(bucketList, wish),
                      child: Icon(
                        Icons.check_circle_outline,
                        color: bucketList['color'],
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        wish['text'],
                        style: const TextStyle(color: AppColors.textPrimary),
                      ),
                    ),
                  ],
                ),
              )),
              const SizedBox(height: 16),
              Text(
                'Tap ✓ to mark as completed',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [bucketList['color'], bucketList['color'].withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Close',
                    style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _completeWish(Map<String, dynamic> bucketList, Map<String, dynamic> wish) {
    setState(() {
      wish['completed'] = true;
      _notifications.insert(0, {
        'name': 'You',
        'message': 'completed "${wish['text']}" from ${bucketList['name']}\'s bucket list',
        'time': 'Just now',
        'type': 'wish_completed_by_me',
      });
    });
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Completed "${wish['text']}"! ${bucketList['name']} will be notified.'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}