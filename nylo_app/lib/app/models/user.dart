import 'package:nylo_framework/nylo_framework.dart';

class User extends Model {
  String? username;
  String? password;

  User(String username, String password);

  User.fromJson(dynamic data) {
    username = data['username'];
    password = data['password'];
  }

  toJson() => {"username": username, "password": password};
}
