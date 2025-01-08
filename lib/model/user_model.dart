// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? secondName;
  String? profile;

  UserModel({
    this.uid,
    this.email,
    this.firstName,
    this.secondName,
    this.profile,
  });

//receive data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      secondName: map['secondName'],
      profile: map['profile'],
    );
  }
  //sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'secondName': secondName,
      'profile': profile,
    };
  }
}
