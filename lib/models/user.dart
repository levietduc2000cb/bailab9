class User {
  final int id;
  final String firstName;
  final String lastName;
  final String maidenName;
  final String gender;
  final String email;
  final String phone;
  final String image;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.maidenName,
    required this.gender,
    required this.email,
    required this.phone,
    required this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        maidenName: json['maidenName'],
        gender: json['gender'],
        email: json['email'],
        phone: json['phone'],
        image: json['image']);
  }
}
