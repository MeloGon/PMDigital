import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pmdigital_app/src/models/OrdenFullModel.dart';
import 'package:pmdigital_app/src/models/OrdenModel.dart';

class OrdenesProvider {
  String _url =
      'https://innovadis.net.pe/apiPMDigital/public/orden_trabajo/getAllOTs';

  String _urlGlobal =
      'https://innovadis.net.pe/apiPMDigital/public/orden_trabajo/';
  int _grupoPage = 0;
  int _cantGrupo = 20;
  bool _cargando = false;
  List<OrdenModel> _ordenes = new List();

  final _ordenesStreamController =
      StreamController<List<OrdenModel>>.broadcast();

  Function(List<OrdenModel>) get ordenesSink =>
      _ordenesStreamController.sink.add;

  Stream<List<OrdenModel>> get ordenesStream => _ordenesStreamController.stream;

  void disposeStreams() {
    _ordenesStreamController?.close();
  }

  Future<List<OrdenModel>> _procesarRespuesta(String token) async {
    final resp = await http.post(_url, headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": token,
    }, body: {
      //{"grupo":1, "cantGrupo":20, "buscar":"", "fecha":"", "prioridad":"", "estatus":""}
      'json': '{"grupo":' +
          _grupoPage.toString() +
          ',"cantGrupo":' +
          _cantGrupo.toString() +
          ',"buscar": "","fecha":"","prioridad":"","estatus":""' +
          '}',
    });
    final decodeResp = json.decode(resp.body);
    //para tecnico
    final peliculas =
        new OrdenesModel.fromJsonList(decodeResp['ots_secundario']);

    //para admin
    //final peliculas = new OrdenesModel.fromJsonList(decodeResp['ots_directo']);
    return peliculas.items;
  }

  Future<List<OrdenModel>> getOrdenes(String token) async {
    if (_cargando) return [];
    _cargando = true;

    _grupoPage++;
    final resp = await _procesarRespuesta(token);
    _ordenes.addAll(resp);
    ordenesSink(_ordenes);
    _cargando = false;
    return resp;
  }

  Future<int> cantidadOrdenes(String token) async {
    final resp = await http.post(_url, headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": token,
    }, body: {
      //{"grupo":1, "cantGrupo":20, "buscar":"", "fecha":"", "prioridad":"", "estatus":""}
      'json': '{"grupo":' +
          _grupoPage.toString() +
          ',"cantGrupo":' +
          _cantGrupo.toString() +
          ',"buscar": "","fecha":"","prioridad":"","estatus":""' +
          '}',
    });
    final decodeResp = json.decode(resp.body);
    final cantidadTotal = decodeResp['cantTotal_indirecto'];
    return cantidadTotal;
  }

  Future<OrdenFullModel> obtenerOrden(String id, String token) async {
    final resp = await http.get(_urlGlobal + id.toString(), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": token,
    });

    OrdenFullModel ordenfull =
        OrdenFullModel.fromJsonMap(json.decode(resp.body)['rpta']);

    return ordenfull;
  }

  Future cambiarEstado(String idot, String token, String nuevoEstado) async {
    final resp = await http.put(_urlGlobal + idot.toString(), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": token,
    }, body: {
      'json': '{"estado":"' + nuevoEstado.toString() + '"}',
    });

    var jsonconverted = json.decode(resp.body);
    return jsonconverted;
  }
}
