import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prueba_gbp/src/models/user_model.dart';

class UserProvider with ChangeNotifier {
  getUsers() async {
    List<UserModel> users = [];
    final url = 'https://api.github.com/users';
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    if (decodedData == null) return [];
    if (resp.statusCode != 200) return users;

    decodedData.forEach((user) {
      final userTemp = UserModel.fromJson(user);
      users.add(userTemp);
    });
    return users;
  }
}
