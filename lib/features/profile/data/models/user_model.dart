class UserModel {
  final int id;
  final String firebaseUid;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String role;

  UserModel({
    required this.id,
    required this.firebaseUid,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['ID'] ?? json['id'] ?? 0,
      firebaseUid: json['firebase_uid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      role: json['role'] ?? 'user',
    );
  }
}
