import 'package:flutter/material.dart';
import 'proverb.dart';
import 'proverbs_data.dart';
import 'add_proverb_screen.dart';

void main() {
  runApp(const ProverbsApp());
}

class ProverbsApp extends StatelessWidget {
  const ProverbsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Proverbs Wisdom',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D9A),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'serif',
      ),
      home: const ProverbsHomePage(),
    );
  }
}

class ProverbsHomePage extends StatefulWidget {
  const ProverbsHomePage({super.key});

  @override
  State<ProverbsHomePage> createState() => _ProverbsHomePageState();
}

class _ProverbsHomePageState extends State<ProverbsHomePage>
    with TickerProviderStateMixin {
  int currentIndex = 0;
  String selectedCategory = 'All';
  final PageController _pageController = PageController();
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  List<String> get categories {
    final cats = ProverbsRepository.proverbs
        .map((p) => p.category)
        .toSet()
        .toList();
    cats.insert(0, 'All');
    return cats;
  }

  List<Proverb> get filteredProverbs {
    if (selectedCategory == 'All') return ProverbsRepository.proverbs;
    return ProverbsRepository.proverbs
        .where((p) => p.category == selectedCategory)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeInOut),
    );
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _navigateToAddProverb() async {
    final result = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AddProverbScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                ),
            child: child,
          );
        },
      ),
    );

    if (result == true) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      appBar: AppBar(
        title: const Text(
          'Proverbs Wisdom',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2E7D9A),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((category) {
                  final isSelected = category == selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                      backgroundColor: Colors.white,
                      selectedColor: const Color(
                        0xFF2E7D9A,
                      ).withValues(alpha: 0.2),
                      checkmarkColor: const Color(0xFF2E7D9A),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: filteredProverbs.length,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final proverb = filteredProverbs[index];
                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    double value = 1.0;
                    if (_pageController.position.haveDimensions) {
                      value = _pageController.page! - index;
                      value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                    }
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        child: Card(
                          elevation: 12,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white,
                                  const Color(
                                    0xFF2E7D9A,
                                  ).withValues(alpha: 0.08),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF2E7D9A,
                                  ).withValues(alpha: 0.2),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(28),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TweenAnimationBuilder<double>(
                                  duration: Duration(
                                    milliseconds: 800 + (index * 100),
                                  ),
                                  tween: Tween(begin: 0.0, end: 1.0),
                                  builder: (context, value, child) {
                                    return Transform.scale(
                                      scale: value,
                                      child: Icon(
                                        Icons.format_quote,
                                        size: 45,
                                        color: const Color(
                                          0xFF2E7D9A,
                                        ).withValues(alpha: 0.8),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 20),
                                TweenAnimationBuilder<double>(
                                  duration: Duration(
                                    milliseconds: 1000 + (index * 100),
                                  ),
                                  tween: Tween(begin: 0.0, end: 1.0),
                                  builder: (context, value, child) {
                                    return Opacity(
                                      opacity: value,
                                      child: Transform.translate(
                                        offset: Offset(0, 20 * (1 - value)),
                                        child: Text(
                                          proverb.text,
                                          style: const TextStyle(
                                            fontSize: 26,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF2C1810),
                                            height: 1.4,
                                            letterSpacing: 0.5,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 24),
                                TweenAnimationBuilder<double>(
                                  duration: Duration(
                                    milliseconds: 1200 + (index * 100),
                                  ),
                                  tween: Tween(begin: 0.0, end: 1.0),
                                  builder: (context, value, child) {
                                    return Opacity(
                                      opacity: value,
                                      child: Transform.translate(
                                        offset: Offset(0, 15 * (1 - value)),
                                        child: Container(
                                          padding: const EdgeInsets.all(18),
                                          decoration: BoxDecoration(
                                            color: const Color(
                                              0xFF2E7D9A,
                                            ).withValues(alpha: 0.12),
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                            border: Border.all(
                                              color: const Color(
                                                0xFF2E7D9A,
                                              ).withValues(alpha: 0.2),
                                              width: 1,
                                            ),
                                          ),
                                          child: Text(
                                            proverb.meaning,
                                            style: const TextStyle(
                                              fontSize: 17,
                                              color: Color(0xFF4A3429),
                                              height: 1.6,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 20),
                                TweenAnimationBuilder<double>(
                                  duration: Duration(
                                    milliseconds: 1400 + (index * 100),
                                  ),
                                  tween: Tween(begin: 0.0, end: 1.0),
                                  builder: (context, value, child) {
                                    return Opacity(
                                      opacity: value,
                                      child: Transform.translate(
                                        offset: Offset(0, 10 * (1 - value)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 8,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: const Color(
                                                  0xFF2E7D9A,
                                                ).withValues(alpha: 0.15),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                  color: const Color(
                                                    0xFF2E7D9A,
                                                  ).withValues(alpha: 0.3),
                                                ),
                                              ),
                                              child: Text(
                                                proverb.origin,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF2E7D9A),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 8,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: const Color(
                                                  0xFF4A90A4,
                                                ).withValues(alpha: 0.15),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                  color: const Color(
                                                    0xFF4A90A4,
                                                  ).withValues(alpha: 0.3),
                                                ),
                                              ),
                                              child: Text(
                                                proverb.category,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF4A90A4),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${currentIndex + 1} of ${filteredProverbs.length}',
                  style: const TextStyle(
                    color: Color(0xFF2E7D9A),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: List.generate(
                    filteredProverbs.length > 5 ? 5 : filteredProverbs.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index == currentIndex % 5
                            ? const Color(0xFF2E7D9A)
                            : const Color(0xFF2E7D9A).withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabAnimation,
        child: FloatingActionButton.extended(
          onPressed: _navigateToAddProverb,
          backgroundColor: const Color(0xFF2E7D9A),
          foregroundColor: Colors.white,
          elevation: 8,
          icon: const Icon(Icons.add),
          label: const Text(
            'Add Proverb',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
