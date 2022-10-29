import 'package:flutter/cupertino.dart';
import 'package:project_alpha/model/user.dart';
import 'package:project_alpha/resources/auth_method.dart';

class UserProvider with ChangeNotifier {
  final AuthMethods _authMethods = AuthMethods();
  User? _user;

  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserData();
    _user = user;
    notifyListeners();
  }
}
