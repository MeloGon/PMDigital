class OrdenFullModel {
  int id;
  String descripcion;
  String numeroOt;
  String tipoOt;
  String estado;
  String estadoColor;
  String prioridad;
  String prioridadColor;
  String mainWork;
  String tipoActividad;
  DateTime fechaFechaIniPlan;
  DateTime fechaFinPlan;
  String revision;
  dynamic ubiFuncional;
  dynamic sortField;
  List<Operacion> operaciones;
  List<Materiale> materiales;

  OrdenFullModel({
    this.id,
    this.descripcion,
    this.numeroOt,
    this.tipoOt,
    this.estado,
    this.estadoColor,
    this.prioridad,
    this.prioridadColor,
    this.mainWork,
    this.tipoActividad,
    this.fechaFechaIniPlan,
    this.fechaFinPlan,
    this.revision,
    this.ubiFuncional,
    this.sortField,
    this.operaciones,
    this.materiales,
  });

  OrdenFullModel.fromJsonMap(Map<String, dynamic> json) {
    id = json["id"];
    descripcion = json["descripcion"];
    numeroOt = json["numero_ot"];
    tipoOt = json["tipo_ot"];
    estado = json["estado"];
    estadoColor = json["estado_color"];
    prioridad = json["prioridad"];
    prioridadColor = json["prioridad_color"];
    mainWork = json["main_work"];
    tipoActividad = json["tipo_actividad"];
    fechaFechaIniPlan = DateTime.parse(json["fecha_ini_plan"]);
    fechaFinPlan = DateTime.parse(json["fecha_fin_plan"]);
    revision = json["revision"];
    ubiFuncional = json["ubi_funcional"];
    sortField = json["sort_field"];
    operaciones = List<Operacion>.from(
        json["operaciones"].map((x) => Operacion.fromJson(x)));
    materiales = List<Materiale>.from(
        json["materiales"].map((x) => Materiale.fromJson(x)));
  }

  factory OrdenFullModel.fromJson(Map<String, dynamic> json) => OrdenFullModel(
        id: json["id"],
        descripcion: json["descripcion"],
        numeroOt: json["numero_ot"],
        tipoOt: json["tipo_ot"],
        estado: json["estado"],
        estadoColor: json["estado_color"],
        prioridad: json["prioridad"],
        prioridadColor: json["prioridad_color"],
        mainWork: json["main_work"],
        tipoActividad: json["tipo_actividad"],
        fechaFechaIniPlan: json["fecha_ini_plan"],
        fechaFinPlan: json["fecha_fin_plan"],
        revision: json["revision"],
        ubiFuncional: json["ubi_funcional"],
        sortField: json["sort_field"],
        operaciones: List<Operacion>.from(json["operaciones"] == null
            ? []
            : json["operionaces"].map((x) => Operacion.fromJson(x))),
        materiales: List<Materiale>.from(json["materiales"] == null
            ? []
            : json["materiales"].map((x) => Materiale.fromJson(x))),
      );
}

class Materiale {
  Materiale({
    this.descripcion,
    this.numero,
    this.reserva,
    this.cantidad,
  });

  String descripcion;
  String numero;
  String reserva;
  int cantidad;

  Materiale.fromJson(Map<String, dynamic> json) {
    descripcion = json["descripcion"];
    numero = json["numero"];
    reserva = json["reserva"];
    cantidad = json["cantidad"];
  }
}

class Operacion {
  Operacion({
    this.id,
    this.descripcion,
    this.actividad,
    this.workPlan,
    this.estadoOp,
  });

  int id;
  String descripcion;
  String actividad;
  int workPlan;
  String estadoOp;

  Operacion.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    descripcion = json["descripcion"];
    actividad = json["actividad"];
    workPlan = json["work_plan"];
    estadoOp = json["estado_op"];
  }
}
