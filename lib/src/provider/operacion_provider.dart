import 'package:http/http.dart' as http;
import 'package:pmdigital_app/src/models/OperacionFullModel.dart';
import 'dart:convert';
import 'package:pmdigital_app/src/models/OrdenFullModel.dart';

class OperacionMaterialProvider {
  String _url = 'https://innovadis.net.pe/apiPMDigital/public/orden_trabajo/';
  String _urlOperacion =
      'https://innovadis.net.pe/apiPMDigital/public/operacion/';

  Future<List<Operacion>> obtenerOperaciones(String nroOt, String token) async {
    final resp = await http.get(_url + nroOt.toString(), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": token,
    });

    final List<Operacion> listaOperaciones = new List();
    final decode = json.decode(resp.body);
    //print(decode['rpta']['operaciones']);
    (decode['rpta']['operaciones'] as List)
        .map((e) => Operacion.fromJson(e))
        .toList()
        .forEach((element) {
      listaOperaciones.add(element);
    });
    return listaOperaciones;
  }

  Future<List<Materiale>> obtenerMateriales(String nroOt, String token) async {
    final resp = await http.get(_url + nroOt.toString(), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": token,
    });

    final List<Materiale> listaMateriales = new List();
    final decode = json.decode(resp.body);
    //print(decode['rpta']['materiales']);
    (decode['rpta']['materiales'] as List)
        .map((e) => Materiale.fromJson(e))
        .toList()
        .forEach((element) {
      listaMateriales.add(element);
    });
    return listaMateriales;
  }

  Future<OperacionFullModel> obtenerOperacion(String idop, String token) async {
    final resp = await http.get(_urlOperacion + idop.toString(), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": token,
    });

    OperacionFullModel operacionfull =
        OperacionFullModel.fromJson(json.decode(resp.body)['rpta']);
    return operacionfull;
  }

  Future<List<Materiale>> obtenerMaterialesOperacion(
      String idop, String token) async {
    final resp = await http.get(_urlOperacion + idop.toString(), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": token,
    });

    final List<Materiale> listaMateriales = new List();
    final decode = json.decode(resp.body);
    //print(decode['rpta']['materiales']);
    (decode['rpta']['materiales'] as List)
        .map((e) => Materiale.fromJson(e))
        .toList()
        .forEach((element) {
      listaMateriales.add(element);
    });
    return listaMateriales;
  }

  Future<List<Nota>> obtenerNotasOperacion(String idop, String token) async {
    final resp = await http.get(_urlOperacion + idop.toString(), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": token,
    });

    final List<Nota> listaNotas = new List();
    final decode = json.decode(resp.body);
    (decode['rpta']['notas'] as List)
        .map((e) => Nota.fromJson(e))
        .toList()
        .forEach((element) {
      listaNotas.add(element);
    });
    return listaNotas;
  }

  Future<List<Servicio>> obtenerServiciosOperacion(
      String idop, String token) async {
    final resp = await http.get(_urlOperacion + idop.toString(), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": token,
    });

    final List<Servicio> listaServicios = new List();
    final decode = json.decode(resp.body);
    //comentarle que aqui son servicios xd
    (decode['rpta']['sercicios'] as List)
        .map((e) => Servicio.fromJson(e))
        .toList()
        .forEach((element) {
      listaServicios.add(element);
    });
    return listaServicios;
  }
}
