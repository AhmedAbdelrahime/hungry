class UserModel {
  final String email;
  final String passowrd;
  final String name;
  final String? image;
  final String? visa;
  final String? token;
  final String? address;

  UserModel({
    required this.email,
    required this.passowrd,
    required this.name,
    this.image,
    this.visa,
    this.token,
    this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] ?? "",
      passowrd: json['password'] ?? "",
      name: json['name'] ?? "Guest",
      token: json['token'] ?? "",
      address: json['address'] ?? "",
      image: json['image'] ?? "",
      visa: json['Visa'] ?? "",
    );
  }
}
