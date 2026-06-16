import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String id;
  final String email;
  final String? username;
  final String? avatarUrl;
  final String? preferredCountry;
  final String? preferredLanguage;
  final List<String> preferredCategories;
  final bool isPro;

  const UserProfile({
    required this.id,
    required this.email,
    this.username,
    this.avatarUrl,
    this.preferredCountry,
    this.preferredLanguage,
    this.preferredCategories = const [],
    this.isPro = false,
  });

  String get displayName => username ?? email.split('@').first;

  String get initials {
    final parts = displayName.split(RegExp(r'[\s._-]')).where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return displayName.substring(0, displayName.length.clamp(1, 2)).toUpperCase();
  }

  @override
  List<Object?> get props => [id, email, username, isPro];
}
