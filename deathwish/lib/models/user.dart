class User {
  final String id;
  final String password;
  final bool isPublic;
  final List<String> friendIds;

  User({
    required this.id,
    required this.password,
    required this.isPublic,
    this.friendIds = const [],
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'password': password,
    'isPublic': isPublic,
    'friendIds': friendIds,
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    password: json['password'],
    isPublic: json['isPublic'],
    friendIds: List<String>.from(json['friendIds'] ?? []),
  );
}