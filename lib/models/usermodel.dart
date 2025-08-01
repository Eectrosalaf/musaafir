class UserDetailsModel {
  final String name;
  // final String address;
  // final String phone;
  // final String category;
  final String email;
  UserDetailsModel(
      {required this.name,
      // required this.address,
      // required this.phone,
      // required this.category,
      required this.email});

  Map<String, dynamic> getJson() => {
        'name': name,
        // 'address': address,
        // 'phone': phone,
        // 'category': category,
        'email': email,
      };

  factory UserDetailsModel.getModelFromJson(Map<String, dynamic> json) {
    return UserDetailsModel(
        name: json["name"],
        // address: json["address"],
        // phone: json["phone"],
        // category: json["category"],
        email: json["email"]);
  }
}