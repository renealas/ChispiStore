import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;
  String _name;
  String _userImage;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  String get userName{
    return _name;
  }

   String get userImage{
    return _userImage;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/$urlSegment?key=AIzaSyCQbgJOcBh2E9N_EOQc7OtR55MoW7i-3Hs';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      final userUrl = 'https://flutter-update-62e28.firebaseio.com/users/$_userId.json?auth=$_token';
      final nameResponse = await http.get(userUrl);
      final nameData = json.decode(nameResponse.body);            
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      _name = nameData == null ? 'Nulo' : nameData['name'];
      _userImage = nameData == null ? 'Nulo' : nameData['userImage'];
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
        'name': _name,
        'userImage': _userImage,
      });
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signupNewUser');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'verifyPassword');
  }

  Future<void> resetPassword(String email) async {
    final url =
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/getOobConfirmationCode?key=AIzaSyCQbgJOcBh2E9N_EOQc7OtR55MoW7i-3Hs';
        final response = await http.post(
        url,
        body: json.encode(
          {
            'requestType':'PASSWORD_RESET',
            'email': email,
          },
        ),
      );
      final responseData = json.decode(response.body);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    _name = extractedUserData['name'];
    _userImage = extractedUserData['userImage'];
    notifyListeners();
    _autoLogout();
    return true;
  }

  void logout() async{
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    _name = null;
    _userImage = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    //prefs.remove('userData'); //Aqui solo remueve session y es en caso se guarde algo mas localmente. 
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}