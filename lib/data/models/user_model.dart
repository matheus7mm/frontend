import './../../domain/entities/entities.dart';

class UserModel {
  final int id;
  final String email;
  final String? phoneNumber;
  final String token;

  UserModel({
    required this.id,
    required this.email,
    this.phoneNumber,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone_number': phoneNumber,
      'token': token,
    };
  }

  User toDomain() {
    return User(
      id: id,
      email: email,
      phoneNumber: phoneNumber,
      token: token,
    );
  }
}
