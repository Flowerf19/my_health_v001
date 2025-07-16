class UserModel {
  final String id;
  final String email;
  final String name;
  final String gender;
  final DateTime dob;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.gender,
    required this.dob,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      email: data['email'],
      name: data['name'],
      gender: data['gender'],
      dob: data['dob'].toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'gender': gender,
      'dob': dob,
    };
  }
}