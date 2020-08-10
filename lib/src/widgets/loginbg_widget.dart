import 'package:flutter/material.dart';

class LoguinBackground extends StatelessWidget {
  final Color _colorGradbeg = Color(0xffDFE3E4);
  final Color _colorGradend = Color(0xffF3F4F5);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [_colorGradbeg, _colorGradend],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
      ),
    );
  }
}
