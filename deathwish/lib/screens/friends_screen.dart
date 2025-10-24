import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../services/auth_service.dart';


class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final publicUsers = AuthService.getPublicUsers();
    final currentUser = AuthService.currentUser;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Add Friends'),
        backgroundColor: AppColors.surface,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search by ID',
                hintStyle: const TextStyle(color: AppColors.textSecondary),
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: publicUsers.length,
              itemBuilder: (context, index) {
                final user = publicUsers[index];
                if (user.id == currentUser?.id) return const SizedBox();
                
                final searchQuery = _searchController.text.toLowerCase();
                if (searchQuery.isNotEmpty && !user.id.toLowerCase().contains(searchQuery)) {
                  return const SizedBox();
                }
                
                final isAlreadyFriend = currentUser?.friendIds.contains(user.id) ?? false;
                
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: Text(user.id[0].toUpperCase()),
                  ),
                  title: Text(user.id, style: const TextStyle(color: Colors.white)),
                  subtitle: const Text('Public Account', style: TextStyle(color: AppColors.textSecondary)),
                  trailing: isAlreadyFriend
                      ? const Icon(Icons.check, color: Colors.green)
                      : IconButton(
                          icon: const Icon(Icons.person_add, color: AppColors.primary),
                          onPressed: () {
                            if (AuthService.addFriend(user.id)) {
                              setState(() {});
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Added ${user.id} as friend')),
                              );
                            }
                          },
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