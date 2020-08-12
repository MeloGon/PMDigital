import 'package:flutter/material.dart';

class RoundButtonWidget extends StatefulWidget {
  final Widget contentRb;
  final int actionRb;
  RoundButtonWidget({this.contentRb, this.actionRb});
  @override
  _RoundButtonWidgetState createState() => _RoundButtonWidgetState();
}

class _RoundButtonWidgetState extends State<RoundButtonWidget> {
  List<BoxShadow> _shadowsCards = [
    BoxShadow(
      color: Colors.black26,
      offset: Offset(0.0, 2.0), //(x,y)
      blurRadius: 8.0,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (widget.actionRb == 1) {
            print('vamonos a la pagina 1');
            Navigator.pushNamed(context, 'ordenes');
          }
          if (widget.actionRb == 2) {
            print('vamonos a la pagina 2');
          }
          if (widget.actionRb == 3) {
            print('vamonos a la pagina 3');
          }
        });
      },
      child: ClipRect(
        child: Container(
          height: 188.0,
          margin: EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.0),
            boxShadow: _shadowsCards,
          ),
          child: widget.contentRb,
        ),
      ),
    );
  }
}
