
import '../models/user.dart';

class AuthService {
  static final Map<String, User> _users = {};
  static User? _currentUser;

  static bool createAccount(String id, String password, bool isPublic) {
    if (_users.containsKey(id)) return false;
    
    _users[id] = User(id: id, password: password, isPublic: isPublic);
    return true;
  }

  static bool login(String id, String password) {
    final user = _users[id];
    if (user != null && user.password == password) {
      _currentUser = user;
      return true;
    }
    return false;
  }

  static User? get currentUser => _currentUser;

  static bool addFriend(String friendId) {
    if (_currentUser == null || !_users.containsKey(friendId)) return false;
    
    final friend = _users[friendId]!;
    if (!friend.isPublic) return false;
    
    final updatedFriends = List<String>.from(_currentUser!.friendIds);
    if (!updatedFriends.contains(friendId)) {
      updatedFriends.add(friendId);
      _users[_currentUser!.id] = User(
        id: _currentUser!.id,
        password: _currentUser!.password,
        isPublic: _currentUser!.isPublic,
        friendIds: updatedFriends,
      );
      _currentUser = _users[_currentUser!.id];
    }
    return true;
  }

  static List<User> getPublicUsers() {
    return _users.values.where((user) => user.isPublic).toList();
  }
}