import 'package:shared_preferences/shared_preferences.dart';
import 'package:film_app/features_personal/user_model.dart';

class AuthHelper {
  static Future<void> saveUserToPrefs(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("accessToken", user.accessToken ?? "");
    await prefs.setString("refreshToken", user.refreshToken ?? "");
    await prefs.setString("username", user.username ?? "");
  }
}
