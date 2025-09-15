import 'package:flutter/material.dart';
import 'proverb.dart';
import 'proverbs_data.dart';

class AddProverbScreen extends StatefulWidget {
  const AddProverbScreen({super.key});

  @override
  State<AddProverbScreen> createState() => _AddProverbScreenState();
}

class _AddProverbScreenState extends State<AddProverbScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  final _meaningController = TextEditingController();
  final _originController = TextEditingController();
  String _selectedCategory = 'Wisdom';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<String> _categories = [
    'Wisdom',
    'Character',
    'Success',
    'Courage',
    'Caution',
    'Adaptation',
    'Perseverance',
    'Life',
    'Love',
    'Friendship',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutBack,
          ),
        );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _textController.dispose();
    _meaningController.dispose();
    _originController.dispose();
    super.dispose();
  }

  void _saveProverb() {
    if (_formKey.currentState!.validate()) {
      final proverb = Proverb(
        id: ProverbsRepository.nextId,
        text: _textController.text.trim(),
        meaning: _meaningController.text.trim(),
        origin: _originController.text.trim(),
        category: _selectedCategory,
      );

      ProverbsRepository.addProverb(proverb);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Proverb added successfully!'),
          backgroundColor: const Color(0xFF6B4E3D),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      appBar: AppBar(
        title: const Text(
          'Add New Proverb',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2E7D9A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.create,
                          size: 50,
                          color: const Color(0xFF2E7D9A).withValues(alpha: 0.7),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Share Your Wisdom',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2E7D9A),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Add a meaningful proverb to inspire others',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildTextField(
                    controller: _textController,
                    label: 'Proverb Text',
                    hint: 'Enter the proverb...',
                    icon: Icons.format_quote,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _meaningController,
                    label: 'Meaning',
                    hint: 'Explain what this proverb means...',
                    icon: Icons.lightbulb_outline,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _originController,
                    label: 'Origin',
                    hint: 'e.g., English, Latin, Chinese...',
                    icon: Icons.public,
                  ),
                  const SizedBox(height: 20),
                  _buildCategoryDropdown(),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _saveProverb,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D9A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Add Proverb',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: const Color(0xFF2E7D9A)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(16),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        initialValue: _selectedCategory,
        decoration: InputDecoration(
          labelText: 'Category',
          prefixIcon: const Icon(Icons.category, color: Color(0xFF2E7D9A)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(16),
        ),
        items: _categories.map((category) {
          return DropdownMenuItem(value: category, child: Text(category));
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedCategory = value!;
          });
        },
      ),
    );
  }
}
