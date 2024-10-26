import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String email;
  final String? phoneNumber;
  final String token;

  const User({
    required this.id,
    required this.email,
    this.phoneNumber,
    required this.token,
  });

  @override
  List<Object?> get props => [id, email, phoneNumber, token];
}
