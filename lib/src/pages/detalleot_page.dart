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
  Color _appBarColor = Color(0xff354A5F);
  TextStyle _styleAppBarTitle = TextStyle(
      fontFamily: 'fuente72', fontSize: 14.0, fontWeight: FontWeight.w400);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _appBarColor,
        title: Text('Orden 100711361'),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                panelCabecera(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget panelCabecera() {
    return Container(
      child: Column(
        // mainAxisSize: MainAxisSize.min,
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
}
