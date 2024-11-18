class UserModel {
  final String userName;
  final String email;

  UserModel({
    required this.userName,
    required this.email,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userName: map['userName'] ?? '',
      email: map['email'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'email': email,
    };
  }
}
