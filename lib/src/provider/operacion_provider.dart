import 'dart:io';
import 'package:mime_type/mime_type.dart';
import 'package:http/http.dart' as http;
import 'package:pmdigital_app/src/models/OperacionFullModel.dart';
import 'package:http_parser/http_parser.dart';
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

  Future<List<Foto>> obtenerFotosOperacion(String idop, String token) async {
    final resp = await http.get(_urlOperacion + idop.toString(), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": token,
    });

    final List<Foto> listaFotos = new List();
    final decode = json.decode(resp.body);
    //comentarle que aqui son servicios xd
    (decode['rpta']['fotos'] as List)
        .map((e) => Foto.fromJson(e))
        .toList()
        .forEach((element) {
      listaFotos.add(element);
    });
    return listaFotos;
  }

  Future cambiarEstadoOpe(String idop, String token, String nuevoEstado) async {
    final resp = await http.put(_urlOperacion + idop.toString(), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": token,
    }, body: {
      'json': '{"estado":"' + nuevoEstado.toString() + '"}',
    });

    var jsonconverted = json.decode(resp.body);
    return jsonconverted;
  }

  Future guardarNota(String token, String idop, String nota) async {
    final resp = await http
        .post('https://innovadis.net.pe/apiPMDigital/public/nota', headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": token,
    }, body: {
      'json': '{"operaciones_id":"' +
          idop.toString() +
          '","texto":"' +
          nota.toString() +
          '"}'
    });

    var jsonconverted = json.decode(resp.body);
    return jsonconverted;
  }

  //solo funciona con admin reviar esto con Joel
  Future eliminarNota(String token, String idnota) async {
    final resp = await http.delete(
        'https://innovadis.net.pe/apiPMDigital/public/nota/' +
            idnota.toString(),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          "Authorization": token,
        });

    var jsonconverted = json.decode(resp.body);
    print(jsonconverted);
    return jsonconverted;
  }

//solo funciona con admin reviar esto con Joel
  Future editarNota(String token, String idnota, String contnota) async {
    final resp = await http.put(
        'https://innovadis.net.pe/apiPMDigital/public/nota/' +
            idnota.toString(),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          "Authorization": token,
        },
        body: {
          'json': '{"texto":"' + contnota.toString() + '"}'
        });

    var jsonconverted = json.decode(resp.body);
    print(jsonconverted);
    return jsonconverted;
  }

  Future<String> subirImagen(File imagen) async {
    final urli = Uri.parse(
        'https://api.cloudinary.com/v1_1/dtbk6l4qp/image/upload?upload_preset=feqvszg5');
    final mimeType = mime(imagen.path).split('/'); //image/jpeg

    final imageUploadRequest = http.MultipartRequest('POST', urli);
    final file = await http.MultipartFile.fromPath('file', imagen.path,
        contentType: MediaType(mimeType[0], mimeType[1]));

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);
    if (resp.statusCode != 200 && resp.statusCode != 201) {
      return null;
    }

    final respData = json.decode(resp.body);
    return respData['secure_url'];
  }

  //{ "operaciones_id":"2", "url":"chfokrd.png", "url2":"hfokrd.png", "nombre":"nom", "extension":"jpg", "ancho":"50", "alto":"100", "peso":"500"}

  Future subirImagenServer(String token, String idop, String urlfoto) async {
    final resp = await http.post(
        'https://innovadis.net.pe/apiPMDigital/public/imagen/store2',
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          "Authorization": token,
        },
        body: {
          'json': '{"operaciones_id":"' +
              idop.toString() +
              '","url":"' +
              urlfoto.toString() +
              '","url2":"' +
              urlfoto.toString() +
              '", "nombre":"nom", "extension":"jpg", "ancho":"50", "alto":"100", "peso":"500"}'
        });
    var respData = json.decode(resp.body);
    print(respData);
    return respData;
  }
}
