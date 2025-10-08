import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import '../../color_utils.dart';



class GradientLetterBox extends StatelessWidget {
  final String letter;
  final String position;
  final double ? w;
  final double ? h;
  final bool ? isBordered;
  const GradientLetterBox({super.key, required this.letter, required this.position, this.w, this.h,   this.isBordered});
  

  
  


  @override
  Widget build(BuildContext context) {
    final gradient = gradientForLetter(letter);

    return    Container(
        width: w ??50,
        height: h ??50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border:Border.all(color: isBordered != null ?Colors.yellow:Colors.transparent ,width: 4),
           gradient: gradient, // 🎨 gradient background
          borderRadius: BorderRadius.circular(161),
        ),
        child: Text(
          letter,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      );


  }
}

