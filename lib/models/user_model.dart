class UserModel {
  String? userId;
  String? name;
  String? email;
  String? mobNo;
  String? gender;
  String? createdAt;
  bool isOnline = false;
  int? status = 1; //1-> Active, 2->InActive, 3->Suspended
  String? profilePic = "";
  int? profileStatus = 1; //1->public, 2->friends, 3->private

  UserModel({
    this.userId,
    required this.createdAt,
    required this.name,
    required this.email,
    required this.mobNo,
    required this.gender,
    required this.isOnline,
    required this.status,
    required this.profilePic,
    required this.profileStatus}); //1-> public, 2->private, 3->onlyFriends



  factory UserModel.fromDoc(Map<String, dynamic> document) {
    return UserModel(
      userId: document['userId']??"",
      createdAt: document['createdAt']??"",
      name: document['name']??"",
      email: document['email']??"",
      mobNo: document['mobNo']??"",
      gender: document['gender']??"",
      isOnline: document['isOnline']??"",
      status: document['status']??1,
      profilePic: document['profilePic']??"",
      profileStatus: document['profileStatus']??1,
    );
  }

  Map<String, dynamic> toDoc() => {
    "userId": userId,
    "createdAt" : createdAt,
    "name" : name,
    "email" : email,
    "mobNo" : mobNo,
    "gender" : gender,
    "isOnline" : isOnline,
    "status" : status,
    "profilePic" : profilePic,
    "profileStatus" : profileStatus,
  };
}