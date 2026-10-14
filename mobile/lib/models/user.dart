class User {
  final int id;
  final String username;
  final String email;

  User({
    required this.id,
    required this.username,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: int.parse(json['id'].toString()),
      username: json['username'].toString(),
      email: json['email'].toString(),
    );
  }
}