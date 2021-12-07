class UserModel {
  String? uid;
  String? email;
  String? name;
  String? surname;

  UserModel({this.uid, this.email, this.name, this.surname});

  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      surname: map['surname'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'surname': surname,
    };
  }
}
