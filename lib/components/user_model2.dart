// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel2 {
  String? uid;
  String? email;
  String? firstName;
  String? secondName;
  String? date;
  String? profile;
  String? profileImageUrl;
  String? usertype;

  UserModel2({
    this.uid,
    this.email,
    this.firstName,
    this.secondName,
    this.profile,
    this.usertype,
    this.date,
    this.profileImageUrl,
  });

//receive data from server
  factory UserModel2.fromMap(map) {
    return UserModel2(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      secondName: map['secondName'],
      profile: map['profile'],
      usertype: map['usertype'],
      date: map['date'],
      profileImageUrl: map['profileImageUrl'],
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
      'usertype': usertype,
      'date': date,
      'imageUrl': profileImageUrl,
    };
  }
}
