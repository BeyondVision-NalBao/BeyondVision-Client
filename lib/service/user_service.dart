import 'package:beyond_vision/model/user_model.dart';
import 'package:beyond_vision/provider/login_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:beyond_vision/service/date_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserService {
  DateService dateService = DateService();
  static const String baseUrl = "http://34.64.89.205/api/v1/member";
  AuthProvider auth = AuthProvider();

  //첫 로그인 또는 로그인
  Future<User> getUserData(String? accessToken) async {
    if (accessToken != null) {
      final url = Uri.parse('$baseUrl/google/$accessToken');

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(utf8.decode(response.bodyBytes));
        User currentUser = User.fromJson(data);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool("isLogined", true);
        prefs.setString("loginDate", dateService.loginDate(DateTime.now()));
        if (!currentUser.isNewMember!) {
          prefs.setInt("memberId", currentUser.memberId!);
          prefs.setInt("exerciseGoal", currentUser.exerciseGoal);
          print(currentUser.memberId!);
          print(currentUser.exerciseGoal);
        }

        return currentUser;
      }
    }
    throw Error();
  }

  Future<User> postUserInfo(
      int age, String gender, int exerciseGoal, User user) async {
    final url = Uri.parse('$baseUrl/signup');

    var response = await http.post(url,
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: json.encode({
          "name": user.name,
          "email": user.email,
          "socialId": user.socialId,
          "profileImageUrl": user.profileImageUrl,
          "age": age,
          "gender": gender,
          "exerciseGoal": exerciseGoal,
        }));
    if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      User currentUser = User.fromJson(data);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt("memberId", currentUser.memberId!);
      prefs.setInt("exerciseGoal", currentUser.exerciseGoal);
      return currentUser;
    }
    throw Error();
  }

  Future<bool> quitUser(int memberId) async {
    final url = Uri.parse('$baseUrl/signout/$memberId');

    var response = await http.delete(url);

    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();

      return true;
    }

    return false;
  }

  Future<int> editUserInfo(int oldGoal, int newGoal, int memberId) async {
    final url = Uri.parse('$baseUrl/info/$memberId');

    var response = await http.post(url,
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: json.encode({"exerciseGoal": newGoal}));

    if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      User currentUser = User.fromJson(data);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt("exerciseGoal", currentUser.exerciseGoal);
      return newGoal;
    }
    return oldGoal;
  }

  Future<bool> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    int allPrefs = prefs.getKeys().length;

    if (allPrefs == 0) {
      // SharedPreferences가 비어 있는 경우 처리할 내용을 여기에 작성합니다.
      return true;
    } else {
      // SharedPreferences에 데이터가 있는 경우 처리할 내용을 여기에 작성합니다.
      return false;
    }
  }
}
