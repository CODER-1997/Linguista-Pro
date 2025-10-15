import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:linguista_ios/screens/admin/students/student_types/free_of_charge_students.dart';
import 'package:linguista_ios/screens/admin/students/student_types/paid_students.dart';
import '../../../constants/text_styles.dart';
import '../../../constants/theme.dart';
import '../../../constants/utils.dart';
import '../../../controllers/admin/teachers_controller.dart';
import '../../../controllers/groups/group_controller.dart';
import '../../../controllers/students/student_controller.dart';
import '../students/student_types/unpaid_students.dart';
import '../teachers/teachers.dart';

class Statistics extends StatelessWidget {


  num calculateTotalPayments(List students) {
    int value = 0;
    for (int i = 0; i < students.length; i++) {
      var paidMonths = students[i]['items']['payments'];
      for (int j = 0; j < paidMonths.length; j++) {
        if (currentMonth(paidMonths[j]['paidDate'].toString()) ) {
          value += int.parse(paidMonths[j]['paidSum']);
          if (int.parse(paidMonths[j]['paidSum']) != 0) {}
        }
      }
    }
    return value;
  }

  GroupController groupController = Get.put(GroupController());
  final _formKey = GlobalKey<FormState>();


  num paidStudents(List students) {
    int value = 0;
    for (int i = 0; i < students.length; i++) {
      var paidMonths = students[i]['items']['payments'];
      for (int j = 0; j < paidMonths.length; j++) {
        if (currentMonth(paidMonths[j]['paidDate'].toString()) &&
            students[i]['items']['isDeleted'] == false &&
            students[i]['items']['isFreeOfcharge'] == false) {
          value++;
          break;
        }
      }
    }
    return value;
  }

  num UnpaidStudents(List students) {
    int value = 0;
    for (int i = 0; i < students.length; i++) {
      var paidMonths = students[i]['items']['payments'];
      if (hasDebt(paidMonths) &&
          students[i]['items']['isDeleted'] == false &&
          students[i]['items']['isFreeOfcharge'] == false) {
        value++;
      }
    }
    return value;
  }

  num freeOfCharge(List students) {
    int value = 0;
    for (int i = 0; i < students.length; i++) {
      if (students[i]['items']['isFreeOfcharge'] == true &&
          students[i]['items']['isDeleted'] == false) {
        value++;
      }
    }
    return value;
  }

  StudentController studentController = Get.put(StudentController());
  TeachersController teachersController = Get.put(TeachersController());
  GetStorage box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: const Color(0xFFF1F4F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5563DE),
        elevation: 6,
        shadowColor: Colors.black26,
        title: const Text(
          "Linguista Statistics",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('LinguistaStudents').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) return const Center(child: Text('No data'));

          final docs = snapshot.data!.docs.toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildStatCard(
                  context,
                  title: "Total Students",
                  value: "${docs.where((e) => e['items']['isDeleted'] == false).length}",
                  color1: const Color(0xFF6DD5FA),
                  color2: const Color(0xFF2980B9),
                  icon: Iconsax.people,
                ),
                _buildStatCard(
                  context,
                  title: "Monthly Income",
                  value: "*****",
                  color1: const Color(0xFF11998E),
                  color2: const Color(0xFF38EF7D),
                  icon: Iconsax.money_4,
                ),
                _buildStatCard(
                  context,
                  title: "Teachers",
                  value: "${teachersController.LinguistaTeachers.length}",
                  color1: const Color(0xFF8E2DE2),
                  color2: const Color(0xFF4A00E0),
                  icon: Iconsax.teacher,
                  onTap: () => Get.to(Teachers()),
                ),
                _buildStatCard(
                  context,
                  title: "Paid Students",
                  value: paidStudents(docs).toString(),
                  color1: const Color(0xFF00B09B),
                  color2: const Color(0xFF96C93D),
                  icon: Iconsax.verify,
                  onTap: () {
                    final list = docs.where((d) =>
                    !hasDebt(d['items']['payments']) &&
                        !d['items']['isDeleted'] &&
                        !d['items']['isFreeOfcharge']).toList();
                    Get.to(PaidStudents(students: list));
                  },
                ),
                _buildStatCard(
                  context,
                  title: "Unpaid Students",
                  value: UnpaidStudents(docs).toString(),
                  color1: const Color(0xFFFF512F),
                  color2: const Color(0xFFDD2476),
                  icon: Iconsax.warning_2,
                  onTap: () {
                    final list = docs.where((d) =>
                    hasDebt(d['items']['payments']) &&
                        !d['items']['isDeleted'] &&
                        !d['items']['isFreeOfcharge']).toList();
                    Get.to(UnPaidStudents(students: list));
                  },
                ),
                _buildStatCard(
                  context,
                  title: "Free of Charge",
                  value: freeOfCharge(docs).toString(),
                  color1: const Color(0xFFFFC371),
                  color2: const Color(0xFFFF5F6D),
                  icon: Iconsax.gift,
                  onTap: () => Get.to(FreeOfChargeds()),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

























Widget _buildStatCard(
    BuildContext context, {
      required String title,
      required String value,
      required Color color1,
      required Color color2,
      required IconData icon,
      VoidCallback? onTap,
    }) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color1, color2]),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: color2.withOpacity(0.4),
            offset: const Offset(0, 6),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text(value,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white24,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
        ],
      ),
    ),
  );
}


