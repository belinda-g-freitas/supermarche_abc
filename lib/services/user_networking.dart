import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supermarche_abc/models/user.dart';

class NetworkHelper {
  final String url = "https://kumbabrand.000webhostapp.com;dbname=id15383106_flutter_abc_supermarket/user_methods.php";
  
  NetworkHelper(/* this.url */);

  Future getUser() async {
    http.Response response = await http.get(Uri.parse(url + '?m=GET_ALL_USER'));

    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }

  Future addUser(User user) async {
    try {
      await http.post(Uri.parse(url + '?method=ADD_USER'), body: user /*{'username': '', 'email': '', 'password': '', 'amount': ''}*/);
    } catch (e) {
      print('THERE WAS THIS ERROR: $e');
    }
  }

  Future updateUser(User user) async {
    try {
      await http.put(Uri.parse(url + '?method=UPDATE_USER'), body: user);
    } catch (e) {
      print('THERE WAS THIS ERROR: $e');
    }
  }

  Future deleteUser(String username) async {
    try {
      await http.post(Uri.parse(url + '?method=DELETE_USER'), body: username);
    } catch (e) {
      print('THERE WAS THIS ERROR:$e');
    }
  }

  Future userLogin(User user) async {
    http.Response response = await http.post(Uri.parse(url + 'method=LOGIN'), body: user /*{'username': '',  'password': ''}*/);

    //await http.read(url);
    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }
}
