/* import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkHelper {
  NetworkHelper(this.url);

  final Uri url; //var url = Uri.parse('');

  Future getData() async {
    //var reponse = http.Response;
    var response = await http.get(url);
    var register = await http.post(url, body: {'username': '', 'email': '', 'password': ''});
    var login = await http.post(url, body: {'username': '', 'password': ''});
    //await http.read(url);
    //await http.put(url)(url);

    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }
}
 */