import 'package:flutter/material.dart';

class DetallesOtPage extends StatefulWidget {
  @override
  _DetallesOtPageState createState() => _DetallesOtPageState();
}

class Item {
  Item({
    this.expandedValue,
    this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

List<Item> generateItems(int numberOfItems) {
  return List.generate(numberOfItems, (int index) {
    return Item(
      headerValue: 'Panel $index',
      expandedValue: 'This is item number $index',
    );
  });
}

// ...

List<Item> _data = generateItems(1);

class _DetallesOtPageState extends State<DetallesOtPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orden 100711361'),
      ),
      body: Stack(
        children: [
          detalles(),
          panelCabecera(),
          panelBtn(),
        ],
      ),
    );
  }

  Widget detalles() {
    return Container(
      margin: EdgeInsets.only(top: 80),
      child: ListView(
        children: [
          Text('Detalles de la Orden'),
          ListTile(
            title: Text('Main Work Ctr.:'),
            subtitle: Text('MFLO'),
          ),
          ListTile(
            title: Text('Supervisor:'),
            subtitle: Text('Paul Torres / Jorge Alaluna'),
          ),
          ListTile(
            title: Text('Tipo de Actividad:'),
            subtitle: Text('006 - Inspection'),
          ),
          Text('Programacion'),
          ListTile(
            title: Text('Inicio:'),
            subtitle: Text('Jul 27, 2020'),
          ),
          ListTile(
            title: Text('Fin:'),
            subtitle: Text('Jul 27, 2020'),
          ),
          ListTile(
            title: Text('Revisión:'),
            subtitle: Text('2020W31'),
          ),
          Text('Equipo de referencia'),
          ListTile(
            title: Text('Ubicación Funcional:'),
            subtitle: Text('MFLO'),
          ),
          ListTile(
            title: Text('Sort field:'),
            subtitle: Text('0330-CPB-0002'),
          ),
        ],
      ),
    );
  }

  Widget panelCabecera() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ExpansionPanelList(
            animationDuration: Duration(milliseconds: 300),
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                _data[index].isExpanded = !isExpanded;
              });
            },
            children: _data.map<ExpansionPanel>((Item item) {
              return ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(
                        '2W Ins Mech Blower Air System',
                        style: TextStyle(fontSize: 20, fontFamily: 'fuente72'),
                      ),
                    ),
                  );
                },
                body: creandoFiltros(),
                isExpanded: item.isExpanded,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget creandoFiltros() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('No Orden 1000711361'),
          SizedBox(
            height: 7,
          ),
          Text('Tipo: PM01'),
          SizedBox(
            height: 7,
          ),
          Text('Prioridad: 2-Alta'),
          SizedBox(
            height: 7,
          ),
          Text('Estatus:'),
          SizedBox(
            height: 7,
          ),
          Text(
            'Pendiente',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget panelBtn() {
    return Container(
      margin: EdgeInsets.only(top: 550.0),
      height: 60.0,
      width: double.infinity,
      // child: FlatButton(onPressed: () {}, child: Text('Iniciar')),
      child: Card(
        elevation: 6,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FlatButton(onPressed: () {}, child: Text('Iniciar')),
          ],
        ),
      ),
    );
  }
}
