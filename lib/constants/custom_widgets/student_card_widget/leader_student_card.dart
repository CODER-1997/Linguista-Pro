import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'gradient_container.dart';

class GradientStudentCard extends StatelessWidget {
  final Map item;
 final String position;
    GradientStudentCard({super.key, required this.item, required this.position});

  @override
  Widget build(BuildContext context) {
    return Container(

      padding: EdgeInsets.symmetric(vertical: 8,horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
       ),
      child:
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Row(children: [
          SizedBox(width: 4,),

          Text("$position",style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Nunito'

          ),),
          SizedBox(width: 12,),
          GradientLetterBox(letter: item['name'].toString().toUpperCase().substring(0,1)+""+item['surname'].toString().toUpperCase().substring(0,1), position: position,)
          ,SizedBox(width: 16,)
        ,
          Container(
            width: Get.width/2,
            child: Text(item['name'].toString().toUpperCase()+" "+item['surname'].toString().toUpperCase(),style: TextStyle(
              color: CupertinoColors.black,
              fontSize: 12,
               fontFamily: 'Lilita'
            ),
            overflow: TextOverflow.ellipsis,
            ),
          )
        ],),
        SizedBox(width: 8,),
                 Container
        (alignment:Alignment.center,
        width: 56,
        height: 32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.orangeAccent,Colors.yellowAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        ),
        child: Image.asset('assets/icons/ic_star.png',width:16 ,height: 16,color: Colors.white,),)
      ],
    ),);
  }
}
