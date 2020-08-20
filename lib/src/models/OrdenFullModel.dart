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
    fechaFechaIniPlan = DateTime.parse(json["fecha fecha_ini_plan"]);
    fechaFinPlan = DateTime.parse(json["fecha_fin_plan"]);
    revision = json["revision"];
    ubiFuncional = json["ubi_funcional"];
    sortField = json["sort_field"];
  }
}
