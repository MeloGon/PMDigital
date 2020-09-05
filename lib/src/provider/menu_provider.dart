import 'dart:convert';

import 'package:http/http.dart' as http;

class MenuProvider {
  Stream ultimosCambios(String token) async* {
    final resp = await http.get(
        'https://innovadis.net.pe/apiPMDigital/public/proyecto/timpoUltimoRegistro',
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          "Authorization": token,
        });
    final jsonresp = jsonDecode(resp.body);
    print(jsonresp['semanal']);
    yield jsonresp['semanal'];
  }
}
