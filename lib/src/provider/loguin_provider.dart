import 'dart:convert';

import 'package:http/http.dart' as http;

class LoguinProvider {
  String _url = 'https://innovadis.net.pe/apiPMDigital/public/usuario/login';

  Future loguinUser(String email, String password) async {
    final resp = await http.post(_url, headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      'json': '{"usuario":"' + email + '","contrasena":"' + password + '"}',
    });
    final decodeResp = json.decode(resp.body);
    return decodeResp;
  }
}
