import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pmdigital_app/src/models/OrdenModel.dart';

class MenuProvider {
  int _contAbiertas = 0;
  DateTime currentDate = DateTime.now();

  Stream ultimosCambios(String token) async* {
    final resp = await http.get(
        'https://innovadis.net.pe/apiPMDigital/public/proyecto/timpoUltimoRegistro',
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          "Authorization": token,
        });
    final jsonresp = jsonDecode(resp.body);

    yield jsonresp['semanal'];
  }

  Future<int> contadorAbiertas(String token) async {
    final resp = await http.post(
        'https://innovadis.net.pe/apiPMDigital/public/orden_trabajo/getAllOTs',
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          "Authorization": token,
        },
        body: {
          //{"grupo":1, "cantGrupo":20, "buscar":"", "fecha":"", "prioridad":"", "estatus":""}
          'json': '{"grupo": 1,"cantGrupo": 200000,"buscar":""' +
              ',"fecha":"","prioridad":"","estatus":""}'
        });

    final List<OrdenModel> listaordenes = new List();
    final decode = json.decode(resp.body);
    (decode['ots_secundario'] as List)
        .map((e) => OrdenModel.fromJsonMap(e))
        .toList()
        .forEach((element) {
      listaordenes.add(element);
    });

    listaordenes.forEach((element) {
      if (element.estado == "En proceso" &&
          element.fechaFinPlan == currentDate) {
        _contAbiertas++;
      }
    });

    return _contAbiertas;
  }
}
