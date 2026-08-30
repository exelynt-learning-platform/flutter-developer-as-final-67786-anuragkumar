import 'package:flutter/foundation.dart';

@immutable
class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    this.name,
    this.photoUrl,
  });

  final String id;
  final String email;
  final String? name;
  final String? photoUrl;

  @override
  bool operator ==(Object other) {
    return identical(this, other) || other is AppUser && runtimeType == other.runtimeType && id == other.id && email == other.email && name == other.name && photoUrl == other.photoUrl;
  }

  @override
  int get hashCode => Object.hash(id, email, name, photoUrl);
}