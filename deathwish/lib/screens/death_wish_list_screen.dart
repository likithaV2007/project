import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class DeathWishListScreen extends StatefulWidget {
  const DeathWishListScreen({super.key});

  @override
  State<DeathWishListScreen> createState() => _DeathWishListScreenState();
}

class _DeathWishListScreenState extends State<DeathWishListScreen>
    with TickerProviderStateMixin {
  final List<Map<String, dynamic>> _deathWishes = [
    {'id': 1, 'text': 'Visit the Northern Lights', 'completed': false},
    {'id': 2, 'text': 'Write a letter to my family', 'completed': true},
    {'id': 3, 'text': 'Donate to charity', 'completed': false},
  ];

  final List<String> _trustedPeople = ['mom@email.com', 'bestfriend@email.com'];
  final _wishController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isPro = false;
  bool _isOwner = true; // true for owner, false for trusted person
  bool _isSelectionMode = false;
  Set<int> _selectedWishes = {};

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
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
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                _buildHeader(),
                if (!_isPro && _isOwner) _buildProBanner(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_isOwner) _buildTrustedPeopleSection(),
                        if (_isOwner) const SizedBox(height: 30),
                        _buildWishesSection(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _isOwner ? _buildFloatingActionButton() : null,
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
          Expanded(
            child: Text(
              _isOwner ? 'Death Wish List' : 'Shared Death Wishes',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textOnGradient,
              ),
            ),
          ),
          if (_isOwner)
            IconButton(
              icon: Icon(_isPro ? Icons.star : Icons.star_border, color: Colors.amber),
              onPressed: _showProDialog,
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
          colors: [Colors.amber.withOpacity(0.2), Colors.orange.withOpacity(0.2)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.amber),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Upgrade to Pro for unlimited wishes and trusted people',
              style: TextStyle(color: AppColors.textOnGradient, fontSize: 14),
            ),
          ),
          TextButton(
            onPressed: _showProDialog,
            child: const Text('Upgrade', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildTrustedPeopleSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.surfaceGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.security, color: AppColors.primary),
              SizedBox(width: 8),
              Text(
                'Trusted People',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _trustedPeople.map((email) => Chip(
              label: Text(email, style: const TextStyle(color: AppColors.textPrimary)),
              backgroundColor: AppColors.primary.withOpacity(0.2),
              deleteIcon: const Icon(Icons.close, color: AppColors.textPrimary, size: 18),
              onDeleted: () {
                setState(() {
                  _trustedPeople.remove(email);
                });
              },
            )).toList(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _emailController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(
                    hintText: 'Add trusted person email',
                    hintStyle: TextStyle(color: AppColors.textHint),
                    prefixIcon: Icon(Icons.email, color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: _addTrustedPerson,
                  icon: const Icon(Icons.add, color: AppColors.textOnGradient),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWishesSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.surfaceGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.favorite, color: AppColors.primary),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Death Wishes',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
          if (_isSelectionMode && _selectedWishes.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                TextButton.icon(
                  onPressed: _deleteSelectedWishes,
                  icon: const Icon(Icons.delete, color: AppColors.error),
                  label: Text('Delete (${_selectedWishes.length})', style: const TextStyle(color: AppColors.error)),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          ..._deathWishes.asMap().entries.map((entry) {
            final index = entry.key;
            final wish = entry.value;
            final isSelected = _selectedWishes.contains(wish['id']);
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.textPrimary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: isSelected ? Border.all(color: AppColors.primary, width: 2) : null,
              ),
              child: Row(
                children: [
                  if (_isSelectionMode && _isOwner)
                    Checkbox(
                      value: isSelected,
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            _selectedWishes.add(wish['id']);
                          } else {
                            _selectedWishes.remove(wish['id']);
                          }
                        });
                      },
                      activeColor: AppColors.primary,
                    )
                  else if (_isOwner)
                    Checkbox(
                      value: wish['completed'],
                      onChanged: (value) {
                        setState(() {
                          wish['completed'] = value ?? false;
                        });
                      },
                      activeColor: AppColors.primary,
                    )
                  else
                    Icon(
                      wish['completed'] ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: wish['completed'] ? AppColors.success : AppColors.textSecondary,
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: _isSelectionMode && _isOwner ? () {
                        setState(() {
                          if (isSelected) {
                            _selectedWishes.remove(wish['id']);
                          } else {
                            _selectedWishes.add(wish['id']);
                          }
                        });
                      } : null,
                      child: Text(
                        wish['text'],
                        style: TextStyle(
                          color: wish['completed'] ? AppColors.textSecondary : AppColors.textPrimary,
                          decoration: wish['completed'] ? TextDecoration.lineThrough : null,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  if (_isOwner && !_isSelectionMode) ...[
                    IconButton(
                      icon: const Icon(Icons.edit, color: AppColors.primary),
                      onPressed: () => _editWish(index, wish),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: AppColors.error),
                      onPressed: () {
                        setState(() {
                          _deathWishes.removeAt(index);
                        });
                      },
                    ),
                    if (index == 0 && _deathWishes.isNotEmpty)
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _isSelectionMode = !_isSelectionMode;
                            _selectedWishes.clear();
                          });
                        },
                        icon: Icon(_isSelectionMode ? Icons.close : Icons.checklist, color: AppColors.primary),
                        label: Text(_isSelectionMode ? 'Cancel' : 'Select', style: const TextStyle(color: AppColors.primary)),
                      ),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Container(
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
        onPressed: _addWish,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(Icons.add, color: AppColors.textOnGradient),
      ),
    );
  }

  void _addWish() {
    if (!_isOwner) return;
    if (!_isPro && _deathWishes.length >= 5) {
      _showProDialog();
      return;
    }
    _showWishDialog();
  }

  void _editWish(int index, Map<String, dynamic> wish) {
    _wishController.text = wish['text'];
    _showWishDialog(isEdit: true, editIndex: index);
  }

  void _showWishDialog({bool isEdit = false, int? editIndex}) {
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
                isEdit ? 'Edit Death Wish' : 'Add Death Wish',
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _wishController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  hintText: 'Enter your wish',
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
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton(
                        onPressed: () {
                          if (_wishController.text.isNotEmpty) {
                            setState(() {
                              if (isEdit && editIndex != null) {
                                _deathWishes[editIndex]['text'] = _wishController.text;
                              } else {
                                final newId = _deathWishes.isEmpty ? 1 : _deathWishes.map((w) => w['id'] as int).reduce((a, b) => a > b ? a : b) + 1;
                                _deathWishes.add({'id': newId, 'text': _wishController.text, 'completed': false});
                              }
                            });
                            _wishController.clear();
                            Navigator.pop(context);
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

  void _deleteSelectedWishes() {
    setState(() {
      _deathWishes.removeWhere((wish) => _selectedWishes.contains(wish['id']));
      _selectedWishes.clear();
      _isSelectionMode = false;
    });
  }

  void _addTrustedPerson() {
    if (!_isPro && _trustedPeople.length >= 2) {
      _showProDialog();
      return;
    }

    if (_emailController.text.isNotEmpty && !_trustedPeople.contains(_emailController.text)) {
      setState(() {
        _trustedPeople.add(_emailController.text);
      });
      _emailController.clear();
    }
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
                  Text('• Unlimited death wishes', style: TextStyle(color: AppColors.textPrimary)),
                  Text('• Unlimited trusted people', style: TextStyle(color: AppColors.textPrimary)),
                  Text('• Priority support', style: TextStyle(color: AppColors.textPrimary)),
                  Text('• Advanced privacy settings', style: TextStyle(color: AppColors.textPrimary)),
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