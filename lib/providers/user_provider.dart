import 'package:flutter/cupertino.dart';
import 'package:not_instagram/model/user.dart';
import 'package:not_instagram/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  late User _user = User.name(email: 'email', userName: 'userName', userId: 'userId', bio: 'bio', photoUrl: 'photoUrl', followers: [], following: []);
  final AuthMethods _authMethods = AuthMethods();

  User get user => _user;

  set user(User value) {
    _user = value;
  }

  Future<void> refreshUser() async{
    User user = await _authMethods.getUserDetails();
    _user=user;
    notifyListeners();
  }
}
