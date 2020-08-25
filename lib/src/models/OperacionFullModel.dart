import 'OrdenFullModel.dart';

class OperacionFullModel {
  OperacionFullModel({
    this.descripcion,
    this.operationWorkCenter,
    this.estadoOp,
    this.fechaIniPlan,
    this.fechaFinPlan,
    this.duracionReal,
    this.numberReal,
    this.workReal,
    this.descripcionEquipo,
    this.ubiFuncional,
    this.sortField,
    this.materiales,
  });

  String descripcion;
  String operationWorkCenter;
  String estadoOp;
  DateTime fechaIniPlan;
  DateTime fechaFinPlan;
  dynamic duracionReal;
  dynamic numberReal;
  int workReal;
  dynamic descripcionEquipo;
  dynamic ubiFuncional;
  dynamic sortField;
  List<Materiale> materiales;
  List<Nota> notas;

  OperacionFullModel.fromJson(Map<String, dynamic> json) {
    descripcion = json["descripcion"];
    operationWorkCenter = json["operation_work_center"];
    estadoOp = json["estado_op"];
    fechaIniPlan = DateTime.parse(json["fecha_ini_plan"]);
    fechaFinPlan = DateTime.parse(json["fecha_fin_plan"]);
    duracionReal = json["duracion_real"];
    numberReal = json["number_real"];
    workReal = json["work_real"];
    descripcionEquipo = json["descripcion equipo"];
    ubiFuncional = json["ubi_funcional"];
    sortField = json["sort_field"];
    materiales = List<Materiale>.from(
        json["materiales"].map((x) => Materiale.fromJson(x)));
    notas = List<Nota>.from(json["notas"].map((x) => Nota.fromJson(x)));
  }
}

class Nota {
  Nota({
    this.id,
    this.descripcion,
    this.fecha,
    this.nombre,
    this.apellido,
  });

  int id;
  String descripcion;
  DateTime fecha;
  dynamic nombre;
  dynamic apellido;

  Nota.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    descripcion = json["descripcion"];
    fecha = DateTime.parse(json["fecha"]);
    nombre = json["nombre"];
    apellido = json["apellido"];
  }
}

class Servicio {
  Servicio({
    this.descripcion,
  });

  String descripcion;

  Servicio.fromJson(Map<String, dynamic> json) {
    descripcion = json["descripcion"];
  }
}
