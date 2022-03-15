import 'package:flutter/cupertino.dart';
import 'package:not_instagram/model/user.dart';
import 'package:not_instagram/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  late UserModel _user = UserModel.name(email: 'email', userName: 'userName', userId: 'userId', bio: 'bio', photoUrl: 'photoUrl', followers: [], following: [], chatRooms: []);
  final AuthMethods _authMethods = AuthMethods();

  UserModel get user => _user;

  set user(UserModel value) {
    _user = value;
  }

  Future<void> refreshUser() async{
    UserModel user = await _authMethods.getUserDetails();
    _user=user;
    notifyListeners();
  }
}
