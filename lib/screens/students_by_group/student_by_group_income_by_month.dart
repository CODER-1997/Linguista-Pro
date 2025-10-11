
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:linguista_ios/constants/theme.dart';

import '../../constants/custom_widgets/student_shimemr.dart';

class StudentByGroupIncomeByMonth extends StatelessWidget {
  final String groupId;
  final String groupName;

  StudentByGroupIncomeByMonth({
    required this.groupId,
    required this.groupName,
  });

  // Convert timestamp → DateTime
  DateTime getDateFromMillis(int millis) {
    return DateTime.fromMillisecondsSinceEpoch(millis);
  }

  // Generate list of months up to now
  List<String> generateMonthList(DateTime startDate) {
    DateTime now = DateTime.now();
    List<String> months = [];

    DateTime current = DateTime(startDate.year, startDate.month);
    while (current.isBefore(now) || current.isAtSameMomentAs(now)) {
      months.add(DateFormat('MMMM, yyyy').format(current));
      current = DateTime(current.year, current.month + 1);
    }
    return months;
  }

  RxList students = [].obs;

  bool isSameMonth(String dateString, String monthString) {
    // Parse first date like "10-06-2025"
    DateTime date = DateFormat('dd-MM-yyyy').parse(dateString);

    // Parse month name like "October, 2025"
    DateTime monthDate = DateFormat('MMMM, yyyy').parse(monthString);

    // Compare year and month
    return date.year == monthDate.year && date.month == monthDate.month;
  }
  String calculateTotalPayments(List students,String month) {
    int value = 0;
    for (int i = 0; i < students.length; i++) {
      var paidMonths = students[i] ['payments'];
      for (int j = 0; j < paidMonths.length; j++) {
        if (isSameMonth(paidMonths[j]['paidDate'].toString(),month) ) {
          value += int.parse(paidMonths[j]['paidSum']);
          if (int.parse(paidMonths[j]['paidSum']) != 0) {}
        }
      }
    }
    final formatter = NumberFormat("#,###", "en_US");
    return formatter.format(value).replaceAll(',', ' ') + " so'm";
  }




  @override
  Widget build(BuildContext context) {
    // Example timestamp (in milliseconds)
     DateTime startDate = getDateFromMillis(int.parse(groupId));
    List<String> monthList = generateMonthList(startDate);

    return Scaffold(
      backgroundColor: homePagebg,
      body:

      StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('LinguistaStudents')
              .where('items.isDeleted', isEqualTo: false)
              .where('items.groupId', isEqualTo: groupId)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: Get.height,
                child: StudentCardShimmer(),
              );
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (snapshot.hasData) {
              var list = snapshot.data!.docs;

              students.clear();
              for (int i = 0; i < list.length; i++) {
                students.add({

                  'payments': list[i]['items']['payments'],

                });
              }

              return students.length != 0
                  ?  Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListView.builder(
                  itemCount: monthList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                      color: Colors.white,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                color: Colors.deepPurple.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    monthList[index],
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Income: ${calculateTotalPayments(students, monthList[index])}',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.grey.shade400,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    );

                  },
                ),
              )
                  : Container(
                alignment: Alignment.center,
                height: Get.height * .8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/empty.png',
                      width: 150,
                    ),
                    Text(
                      'This group has not any students ',
                      style: TextStyle(
                          color: Colors.black, fontSize: 16),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              );
            }
            // If no data available

            else {
              return Text('No data'); // No data available
            }
          }),






    );
  }
}



