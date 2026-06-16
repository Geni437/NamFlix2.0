import '../../domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.email,
    super.username,
    super.avatarUrl,
    super.preferredCountry,
    super.preferredLanguage,
    super.preferredCategories,
    super.isPro,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    final cats = <String>[];
    final rawCats = json['preferred_categories'];
    if (rawCats is List) cats.addAll(rawCats.map((e) => e.toString()));

    return UserProfileModel(
      id:                  json['id'] as String? ?? '',
      email:               json['email'] as String? ?? '',
      username:            json['username'] as String?,
      avatarUrl:           json['avatar_url'] as String?,
      preferredCountry:    json['preferred_country'] as String?,
      preferredLanguage:   json['preferred_language'] as String?,
      preferredCategories: cats,
      isPro:               (json['is_pro'] as int? ?? 0) == 1,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'username': username,
    'avatar_url': avatarUrl,
    'preferred_country': preferredCountry,
    'preferred_language': preferredLanguage,
    'preferred_categories': preferredCategories,
    'is_pro': isPro ? 1 : 0,
  };
}
