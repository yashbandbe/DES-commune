// ignore_for_file: public_member_api_docs, sort_constructors_first
class AdminUserModel {
  String? uid;
  String? email;
  String? firstName;
  String? secondName;
  String? phoneno;
  String? passout;

  AdminUserModel({
    this.uid,
    this.email,
    this.firstName,
    this.secondName,
    this.phoneno,
    this.passout,
  });

//receive data from server
  factory AdminUserModel.fromMap(map) {
    return AdminUserModel(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      secondName: map['secondName'],
      phoneno: map['phoneno'],
      passout: map['passout'],
    );
  }
  //sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'secondName': secondName,
      'phoneno': phoneno,
      'passout': passout,
    };
  }
}
