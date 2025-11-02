import 'package:verbisense/core/entities/user.dart';

class CoreUserModel extends User {
  CoreUserModel({
    required super.uid,
    required super.email,
    required super.name,
    required super.photoURL,
  });

  factory CoreUserModel.fromJson(Map<String, dynamic> json) {
    return CoreUserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      photoURL: json['photoURL'] as String?,
    );
  }

  CoreUserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? photoURL,
  }) {
    return CoreUserModel(
      uid: id ?? uid,
      email: email ?? this.email,
      name: name ?? this.name,
      photoURL: photoURL ?? this.photoURL,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
    };
  }
}
