import 'package:flutter/material.dart';

class OrdenesPage extends StatefulWidget {
  @override
  _OrdenesPageState createState() => _OrdenesPageState();
}

class _OrdenesPageState extends State<OrdenesPage> {
  Color _appBarColor = Color(0xff354A5F);
  Color _greyColor = Color(0xff6A6D70);
  TextStyle _appBarStyle = TextStyle(
    fontFamily: 'fuente72',
    fontSize: 14.0,
  );
  TextStyle _expandedBarStyle = TextStyle(
    fontFamily: 'fuente72',
    color: Colors.black,
    fontSize: 20.0,
  );
  TextStyle _oTextStyle =
      TextStyle(fontFamily: 'fuente72', fontSize: 14.0, color: Colors.black);

  TextStyle _titleOtStyle = TextStyle(
      fontFamily: 'fuente72',
      color: Color(0xff32363A),
      fontWeight: FontWeight.w700);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _appBarOrdenes(),
//           SliverList(delegate: SliverChildBuilderDelegate((context, index) {
//   return Container();
// }));
          SliverList(
              delegate: SliverChildListDelegate([
            _spaceSearch(),
            _headerBar(),
            _itemTempList(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(),
            ),
            _itemTempList(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(),
            ),
            _itemTempList(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(),
            ),
            _itemTempList(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(),
            ),
            _itemTempList(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(),
            ),
            _itemTempList(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(),
            ),
          ]))
        ],
      ),
    );
  }

  Widget _appBarOrdenes() {
    return SliverAppBar(
        elevation: 2.0,
        backgroundColor: _appBarColor,
        expandedHeight: 100,
        centerTitle: false,
        actions: [
          CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 20.0,
            child: Icon(
              Icons.supervised_user_circle,
              color: Colors.white,
            ),
          ),
        ],
        title: Text(
          'Estatus de órdenes',
          style: _appBarStyle,
        ),
        floating: true,
        pinned: true,
        collapsedHeight: 100,
        flexibleSpace: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 95.0),
              width: double.infinity,
              color: Colors.white,
              height: 60,
            ),
            FlexibleSpaceBar(
              centerTitle: true,
              title: Container(
                padding: EdgeInsets.only(left: 20),
                width: double.infinity,
                child: Text(
                  'Mis órdenes para hoy',
                  style: _expandedBarStyle,
                ),
              ),
            ),
          ],
        ));
  }

  Widget _spaceSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 23.0),
      child: Row(
        children: [
          Text(
            'Ordenes de Trabajo',
            overflow: TextOverflow.clip,
            style: _oTextStyle,
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              height: 37,
              child: TextField(
                style: TextStyle(fontFamily: 'fuente72', fontSize: 14.0),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.0)),
                  hintText: 'Buscar',
                  suffixIcon: Icon(
                    Icons.search,
                    color: Color(0xff0854a0),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _itemTempList() {
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.0),
          Text(
            '2W Svce Lube Agitator',
            style: _titleOtStyle,
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 5.0,
          ),
          RichText(
            text: TextSpan(style: _oTextStyle, children: [
              TextSpan(
                  text: 'Nro. Orden: ', style: TextStyle(color: _greyColor)),
              TextSpan(text: '100707229'),
            ]),
          ),
          SizedBox(
            height: 5.0,
          ),
          RichText(
            text: TextSpan(style: _oTextStyle, children: [
              TextSpan(
                  text: 'Criticidad: ', style: TextStyle(color: _greyColor)),
              TextSpan(text: 'Alta'),
            ]),
          ),
          SizedBox(
            height: 5.0,
          ),
          RichText(
            text: TextSpan(style: _oTextStyle, children: [
              TextSpan(text: 'Tipo: ', style: TextStyle(color: _greyColor)),
              TextSpan(text: 'PM01'),
            ]),
          ),
        ],
      ),
      trailing: Container(
        width: 100.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Pendiente',
              style: TextStyle(
                  fontWeight: FontWeight.w700, color: Color(0xffBB0000)),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 15.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      width: double.infinity,
      height: 45,
      color: Color(0xffF2F2F2),
      child: Row(
        children: [
          Expanded(child: Text('Descripción')),
          Text('Estatus'),
        ],
      ),
    );
  }
}
