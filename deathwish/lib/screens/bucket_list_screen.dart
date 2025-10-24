import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class BucketListScreen extends StatefulWidget {
  const BucketListScreen({super.key});

  @override
  State<BucketListScreen> createState() => _BucketListScreenState();
}

class _BucketListScreenState extends State<BucketListScreen>
    with TickerProviderStateMixin {
  final List<Map<String, dynamic>> _bucketList = [
    {'id': 1, 'text': 'Learn to play piano', 'completed': false},
    {'id': 2, 'text': 'Travel to Paris', 'completed': true},
    {'id': 3, 'text': 'Run a half marathon', 'completed': false},
    {'id': 4, 'text': 'Learn a new language', 'completed': false},
  ];

  final _wishController = TextEditingController();
  bool _isPro = false;
  bool _isSelectionMode = false;
  Set<int> _selectedItems = {};

  late AnimationController _fadeController;
  late AnimationController _progressController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOutCubic),
    );
    
    _fadeController.forward();
    _progressController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  double get _completionRate {
    if (_bucketList.isEmpty) return 0.0;
    final completed = _bucketList.where((item) => item['completed']).length;
    return completed / _bucketList.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                _buildHeader(),
                if (!_isPro) _buildProBanner(),
                _buildProgressSection(),
                Expanded(
                  child: _buildBucketListSection(),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.textOnGradient),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Bucket List',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textOnGradient,
              ),
            ),
          ),
          IconButton(
            icon: Icon(_isPro ? Icons.star : Icons.star_border, color: Colors.amber),
            onPressed: _showProDialog,
          ),
          IconButton(
            icon: const Icon(Icons.share, color: AppColors.textOnGradient),
            onPressed: _shareBucketList,
          ),
        ],
      ),
    );
  }

  Widget _buildProBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.info.withOpacity(0.2), AppColors.secondary.withOpacity(0.2)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.info.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.info),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Upgrade to Pro for unlimited bucket list items',
              style: TextStyle(color: AppColors.textOnGradient, fontSize: 14),
            ),
          ),
          TextButton(
            onPressed: _showProDialog,
            child: const Text('Upgrade', style: TextStyle(color: AppColors.info, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.surfaceGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.public, color: AppColors.info),
              const SizedBox(width: 8),
              const Text(
                'Public Progress',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                '${(_completionRate * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.info,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return LinearProgressIndicator(
                value: _completionRate * _progressAnimation.value,
                backgroundColor: AppColors.textSecondary.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.info),
                minHeight: 8,
              );
            },
          ),
          const SizedBox(height: 12),
          Text(
            '${_bucketList.where((item) => item['completed']).length} of ${_bucketList.length} completed',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          if (_isSelectionMode && _selectedItems.isNotEmpty) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                TextButton.icon(
                  onPressed: _deleteSelectedItems,
                  icon: const Icon(Icons.delete, color: AppColors.error),
                  label: Text('Delete (${_selectedItems.length})', style: const TextStyle(color: AppColors.error)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBucketListSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        itemCount: _bucketList.length,
        itemBuilder: (context, index) {
          final item = _bucketList[index];
          final isSelected = _selectedItems.contains(item['id']);
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              gradient: AppColors.surfaceGradient,
              borderRadius: BorderRadius.circular(16),
              border: isSelected ? Border.all(color: AppColors.primary, width: 2) : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: _isSelectionMode
                  ? Checkbox(
                      value: isSelected,
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            _selectedItems.add(item['id']);
                          } else {
                            _selectedItems.remove(item['id']);
                          }
                        });
                      },
                      activeColor: AppColors.primary,
                    )
                  : Checkbox(
                      value: item['completed'],
                      onChanged: (value) {
                        setState(() {
                          item['completed'] = value ?? false;
                        });
                        _progressController.reset();
                        _progressController.forward();
                      },
                      activeColor: AppColors.info,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
              title: GestureDetector(
                onTap: _isSelectionMode ? () {
                  setState(() {
                    if (isSelected) {
                      _selectedItems.remove(item['id']);
                    } else {
                      _selectedItems.add(item['id']);
                    }
                  });
                } : null,
                child: Text(
                  item['text'],
                  style: TextStyle(
                    color: item['completed'] ? AppColors.textSecondary : AppColors.textPrimary,
                    decoration: item['completed'] ? TextDecoration.lineThrough : null,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              trailing: _isSelectionMode ? null : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (item['completed'])
                    const Icon(Icons.check_circle, color: AppColors.success, size: 20),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.edit, color: AppColors.primary),
                    onPressed: () => _editBucketItem(index, item),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: AppColors.error),
                    onPressed: () {
                      setState(() {
                        _bucketList.removeAt(index);
                      });
                      _progressController.reset();
                      _progressController.forward();
                    },
                  ),
                  if (index == 0 && _bucketList.isNotEmpty)
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _isSelectionMode = !_isSelectionMode;
                          _selectedItems.clear();
                        });
                      },
                      icon: Icon(_isSelectionMode ? Icons.close : Icons.checklist, color: AppColors.primary),
                      label: Text(_isSelectionMode ? 'Cancel' : 'Select', style: const TextStyle(color: AppColors.primary)),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.info, AppColors.secondary]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.info.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: _addBucketItem,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(Icons.add, color: AppColors.textOnGradient),
      ),
    );
  }

  void _addBucketItem() {
    if (!_isPro && _bucketList.length >= 10) {
      _showProDialog();
      return;
    }
    _showBucketItemDialog();
  }

  void _editBucketItem(int index, Map<String, dynamic> item) {
    _wishController.text = item['text'];
    _showBucketItemDialog(isEdit: true, editIndex: index);
  }

  void _showBucketItemDialog({bool isEdit = false, int? editIndex}) {
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
              Text(
                isEdit ? 'Edit Bucket List Item' : 'Add Bucket List Item',
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _wishController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  hintText: 'Enter your bucket list item',
                  hintStyle: TextStyle(color: AppColors.textHint),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        _wishController.clear();
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [AppColors.info, AppColors.secondary]),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton(
                        onPressed: () {
                          if (_wishController.text.isNotEmpty) {
                            setState(() {
                              if (isEdit && editIndex != null) {
                                _bucketList[editIndex]['text'] = _wishController.text;
                              } else {
                                final newId = _bucketList.isEmpty ? 1 : _bucketList.map((w) => w['id'] as int).reduce((a, b) => a > b ? a : b) + 1;
                                _bucketList.add({'id': newId, 'text': _wishController.text, 'completed': false});
                              }
                            });
                            _wishController.clear();
                            Navigator.pop(context);
                            _progressController.reset();
                            _progressController.forward();
                          }
                        },
                        child: Text(isEdit ? 'Update' : 'Add', style: const TextStyle(color: AppColors.textOnGradient)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteSelectedItems() {
    setState(() {
      _bucketList.removeWhere((item) => _selectedItems.contains(item['id']));
      _selectedItems.clear();
      _isSelectionMode = false;
    });
    _progressController.reset();
    _progressController.forward();
  }

  void _shareBucketList() {
    final completedCount = _bucketList.where((item) => item['completed']).length;
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
              const Icon(Icons.share, color: AppColors.info, size: 48),
              const SizedBox(height: 16),
              const Text(
                'Share Bucket List',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'Progress: $completedCount/${_bucketList.length} completed',
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: _completionRate,
                backgroundColor: AppColors.textSecondary.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.info),
                minHeight: 8,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close', style: TextStyle(color: AppColors.textSecondary)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [AppColors.info, AppColors.secondary]),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Bucket list shared!')),
                          );
                        },
                        child: const Text('Share', style: TextStyle(color: AppColors.textOnGradient)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showProDialog() {
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
              const Icon(Icons.star, color: Colors.amber, size: 48),
              const SizedBox(height: 16),
              const Text(
                'Upgrade to Pro',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Column(
                children: [
                  Text('Pro Features:', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  Text('• Unlimited bucket list items', style: TextStyle(color: AppColors.textPrimary)),
                  Text('• Advanced sharing options', style: TextStyle(color: AppColors.textPrimary)),
                  Text('• Custom categories', style: TextStyle(color: AppColors.textPrimary)),
                  Text('• Progress analytics', style: TextStyle(color: AppColors.textPrimary)),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Colors.amber, Colors.orange]),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _isPro = true;
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Upgraded to Pro!')),
                          );
                        },
                        child: const Text('Upgrade \$9.99', style: TextStyle(color: AppColors.textOnGradient, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}