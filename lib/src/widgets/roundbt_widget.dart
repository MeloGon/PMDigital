import 'package:flutter/material.dart';
import 'package:pmdigital_app/src/pages/cumplimiento_page.dart';
import 'package:pmdigital_app/src/pages/ordenes_page.dart';

class RoundButtonWidget extends StatefulWidget {
  final Widget contentRb;
  final int actionRb;
  final String token;
  RoundButtonWidget({this.contentRb, this.actionRb, this.token});
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
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return OrdenesPage(
                token: widget.token,
              );
            }));
          }
          if (widget.actionRb == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return CumplimientoPage(
                token: widget.token,
              );
            }));
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
