import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../../constants/custom_widgets/gradient_button.dart';
import '../../../constants/date_utils.dart';
import '../../../constants/theme.dart';

class UnpaidMonths extends StatelessWidget {
  final List months;
  final String studentPhone;
  final String studentName;
  final String studentSurname;

  UnpaidMonths(
      {required this.months,
      required this.studentPhone,
      required this.studentName,
      required this.studentSurname});

   RxBool messageLoader = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: homePagebg,
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(12),
        child: Column(
          children: [
            SizedBox(
              height: 4,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: months.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: EdgeInsets.all(4),
                    title: Text(months[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),

    );
  }
}
