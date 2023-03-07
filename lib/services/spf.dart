import 'package:shared_preferences/shared_preferences.dart';

class SPF {
  //KEY
  static String userLogInKey = "LogInKey";
  static String userNameKey = "EmailKey";
  static String userPhoneKey = "PhoneKey";
  static String userPassKey = "PassKey";

  //Getter
  static Future<bool?> getLogInStatus() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getBool(userLogInKey);
  }

  static Future<String?> getName() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(userNameKey);
  }

  static Future<String?> getPhone() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(userPhoneKey);
  }

  static Future<String?> getPass() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(userPassKey);
  }

  //Setter
  static Future<bool> saveUserLogInStatus(bool isUserLogIn) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return await sp.setBool(userLogInKey, isUserLogIn);
  }

  static Future<bool> saveUserName(String name) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return await sp.setString(userNameKey, name);
  }

  static Future<bool> savePhone(String phone) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return await sp.setString(userPhoneKey, phone);
  }

  static Future<bool> savePass(String pass) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return await sp.setString(userPassKey, pass);
  }
}
