import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pmdigital_app/src/models/OrdenModel.dart';

class FiltroPage extends StatefulWidget {
  final List<OrdenModel> lista;
  FiltroPage({this.lista});
  @override
  _FiltroPageState createState() => _FiltroPageState();
}

class _FiltroPageState extends State<FiltroPage> with TickerProviderStateMixin {
  int _selectedIndex;
  List<String> _options = ['Pendiente', 'En proceso', 'Completado'];
  Color _appBarColor = Color(0xff354A5F);
  DateTime selectedDate = DateTime.now();
  String _fecha = '';
  String seleccionado = "";
  List<OrdenModel> listaTemp = new List<OrdenModel>();

  TextEditingController _inputFieldDateController = new TextEditingController();

  Widget _buildChips() {
    List<Widget> chips = new List();

    for (int i = 0; i < _options.length; i++) {
      print('selected=' + _selectedIndex.toString());
      ChoiceChip choiceChip = ChoiceChip(
        selected: _selectedIndex == i,
        label: Text(_options[i], style: TextStyle(color: Colors.white)),
        elevation: 2,
        pressElevation: 2,
        backgroundColor: Colors.grey,
        selectedColor: _selectedIndex == null ? Colors.grey : _appBarColor,
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              _selectedIndex = i;
              if (_selectedIndex == 0) {
                seleccionado = "Pendiente";
                print('Pendiente');
              }
              if (_selectedIndex == 1) {
                seleccionado = "En proceso";
                print('En proceso');
              }
              if (_selectedIndex == 2) {
                seleccionado = "Completado";
                print('Completado');
              }
            }
          });
        },
      );

      chips.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: 7), child: choiceChip));
    }

    return ListView(
      // This next line does the trick.
      scrollDirection: Axis.horizontal,
      children: chips,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
          title: Text('Filtros'),
          backgroundColor: _appBarColor,
          actions: [
            IconButton(
                icon: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
                onPressed: () {
                  widget.lista.forEach((element) {
                    if (element.estado.toLowerCase().contains(seleccionado)) {
                      listaTemp.add(element);
                    }
                    if (element.fechaFinPlan
                        .toString()
                        .contains(_inputFieldDateController.text)) {
                      listaTemp.add(element);
                    }
                  });
                  Navigator.pop(context, listaTemp.toSet().toList());
                })
          ],
        ),
        body: Column(
          children: [
            Text('Filtrar por estado:'),
            Container(
              child: _buildChips(),
              height: 40,
            ),
            Text('Filtrar por fecha:'),
            containerFecha(),
            RaisedButton(
              onPressed: () {
                setState(() {});
                _fecha = "";
                selectedDate = DateTime.now();
                _inputFieldDateController.text = "";
                _selectedIndex = null;
              },
              child: Text('Restablecer'),
            )
          ],
        ));
  }

  Widget containerFecha() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      height: 48,
      child: TextField(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _selectDate(context);
        },
        enableInteractiveSelection: false,
        controller: _inputFieldDateController,
        decoration: InputDecoration(
            hintText: 'Seleccione la fecha',
            hintStyle: TextStyle(
                fontFamily: 'fuente72', fontSize: 14.0, color: Colors.black),
            suffixIcon: Icon(Icons.date_range),
            contentPadding: EdgeInsets.all(10),
            border: OutlineInputBorder()),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    DateTime picked = await showDatePicker(
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: const Color(0xff354A5F),
              accentColor: const Color(0xff354A5F),
              colorScheme: ColorScheme.light(primary: const Color(0xff354A5F)),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child,
          );
        },
        context: context,
        initialDate: selectedDate,
        firstDate: new DateTime(2000),
        lastDate: new DateTime(2030),
        locale: Locale('es', 'ES'));

    if (picked != null && picked != selectedDate) {
      setState(() {
        // _fecha = picked.toString();
        _fecha = DateFormat('yyyy-MM-dd').format(picked);
        print(_fecha);
        _inputFieldDateController.text = _fecha;
        selectedDate = picked;
      });
    }
  }
}
