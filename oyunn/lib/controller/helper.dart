import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String userLoggedKey = "Logged key";
  static String usernameKey = "Username key";
  static String useremailKey = "Email key";


  static Future<bool?> saveuserLoggIdstate(bool isUserLoggedin) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedKey,isUserLoggedin);
  }


  static Future<bool?> saveuserNameSF(String username) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return  await sf.setString(usernameKey,username);
  }

  
    static Future<bool?> saveuserEmailSF(String userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(useremailKey,userEmail);
  }

  static Future<bool?> getuserLoggIdstate() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return   sf.getBool(userLoggedKey);
  }

 


  static Future<String?> getuserNameSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();

    return   sf.getString(usernameKey);
  }

  
    static Future<String?> getuserEmailSF( ) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return   sf.getString(useremailKey);
  }




}
