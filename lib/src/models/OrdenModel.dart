class OrdenesModel {
  List<OrdenModel> items = new List();

  OrdenesModel();

  OrdenesModel.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final orden = new OrdenModel.fromJsonMap(item);
      items.add(orden);
    }
  }
}

class OrdenModel {
  int id;
  String descripcion;
  String numeroOt;
  DateTime fechaFinPlan;
  String estado;
  dynamic estadoColor;
  String prioridad;
  dynamic prioridadColor;
  String tipoOt;

  OrdenModel({
    this.id,
    this.descripcion,
    this.numeroOt,
    this.fechaFinPlan,
    this.estado,
    this.estadoColor,
    this.prioridad,
    this.prioridadColor,
    this.tipoOt,
  });

  OrdenModel.fromJsonMap(Map<String, dynamic> json) {
    id = json['id'];
    descripcion = json['descripcion'];
    numeroOt = json['numero_ot'];
    fechaFinPlan = DateTime.parse(json['fecha_fin_plan']);
    estado = json['estado'];
    estadoColor = json['estado_color'];
    prioridad = json['prioridad'];
    prioridadColor = json['prioridad_color'];
    tipoOt = json['tipo_ot'];
  }
}
