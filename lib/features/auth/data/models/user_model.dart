
class UserModel {
  final String id;
  final String name;
  final String email;
  final String? profileImage;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '', // ✅ FIXED: Handle different ID types
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profileImage'],
      createdAt: json['createdAt'] != null 
          ? DateTime.tryParse(json['createdAt']) // ✅ FIXED: Use tryParse
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      if (profileImage != null) 'profileImage': profileImage, // ✅ Only include if not null
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }
}
