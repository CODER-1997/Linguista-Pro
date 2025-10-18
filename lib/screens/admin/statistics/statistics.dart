import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../controllers/admin/teachers_controller.dart';
import '../../../controllers/groups/group_controller.dart';
import '../../../controllers/students/student_controller.dart';
import '../students/student_types/free_of_charge_students.dart';
import '../students/student_types/paid_students.dart';
import '../students/student_types/unpaid_students.dart';
import '../teachers/teachers.dart';
import '../../../constants/utils.dart';

class Statistics extends StatelessWidget {
  final GroupController groupController = Get.put(GroupController());
  final StudentController studentController = Get.put(StudentController());
  final TeachersController teachersController = Get.put(TeachersController());
  final GetStorage box = GetStorage();

  Statistics({Key? key}) : super(key: key);

  num paidStudents(List students) {
    int value = 0;
    for (var s in students) {
      var paid = s['items']['payments'];
      for (var m in paid) {
        if (currentMonth(m['paidDate'].toString()) &&
            !s['items']['isDeleted'] &&
            !s['items']['isFreeOfcharge']) {
          value++;
          break;
        }
      }
    }
    return value;
  }

  num unpaidStudents(List students) {
    int value = 0;
    for (var s in students) {
      var paid = s['items']['payments'];
      if (hasDebt(paid) &&
          !s['items']['isDeleted'] &&
          !s['items']['isFreeOfcharge']) value++;
    }
    return value;
  }

  num freeOfCharge(List students) =>
      students.where((s) => s['items']['isFreeOfcharge'] && !s['items']['isDeleted']).length;

  num calculateTotalPayments(List students) {
    int total = 0;
    for (var s in students) {
      for (var m in s['items']['payments']) {
        if (currentMonth(m['paidDate'].toString())) {
          total += int.parse(m['paidSum']);
        }
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final radius = 16.0;
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFFF6F6F7),
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Statistics", style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: CupertinoColors.systemGrey6,
        border: Border(bottom: BorderSide(color: Colors.transparent)),
      ),
      child: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('LinguistaStudents').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CupertinoActivityIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData) return const Center(child: Text('No data'));

            final docs = snapshot.data!.docs.toList();

            final cards = [
              _StatItem(
                title: 'Total Students',
                value: "${docs.where((e) => !e['items']['isDeleted']).length}",
                icon: Iconsax.people,
                accent: const Color(0xFF4B9CE2),
                onTap: null,
              ),
              _StatItem(
                title: 'Monthly Income',
                value: '— — —',
                icon: Iconsax.money_4,
                accent: const Color(0xFF2DBF7F),
                onTap: null,
              ),
              _StatItem(
                title: 'Teachers',
                value: "${teachersController.LinguistaTeachers.length}",
                icon: Iconsax.teacher,
                accent: const Color(0xFF7C5CFF),
                onTap: () => Get.to(() => Teachers()),
              ),
              _StatItem(
                title: 'Paid Students',
                value: "${paidStudents(docs)}",
                icon: Iconsax.verify,
                accent: const Color(0xFF00B09B),
                onTap: () {
                  final list = docs
                      .where((d) =>
                  !hasDebt(d['items']['payments']) &&
                      !d['items']['isDeleted'] &&
                      !d['items']['isFreeOfcharge'])
                      .toList();
                  Get.to(() => PaidStudents(students: list));
                },
              ),
              _StatItem(
                title: 'Unpaid Students',
                value: "${unpaidStudents(docs)}",
                icon: Iconsax.warning_2,
                accent: const Color(0xFFF35B5B),
                onTap: () {
                  final list = docs
                      .where((d) =>
                  hasDebt(d['items']['payments']) &&
                      !d['items']['isDeleted'] &&
                      !d['items']['isFreeOfcharge'])
                      .toList();
                  Get.to(() => UnPaidStudents(students: list));
                },
              ),
              _StatItem(
                title: 'Free of Charge',
                value: "${freeOfCharge(docs)}",
                icon: Iconsax.gift,
                accent: const Color(0xFFFFA94D),
                onTap: () => Get.to(() => FreeOfChargeds()),
              ),
            ];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.05,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                physics: const BouncingScrollPhysics(),
                children: cards.map((c) {
                  return _StatCard(radius: radius, item: c);
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StatItem {
  final String title;
  final String value;
  final IconData icon;
  final Color accent;
  final VoidCallback? onTap;
  _StatItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.accent,
    this.onTap,
  });
}

class _StatCard extends StatelessWidget {
  final double radius;
  final _StatItem item;
  const _StatCard({Key? key, required this.radius, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    GetStorage box = GetStorage();
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: const Color(0xFFE8E8EE), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + Icon Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: item.accent.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(item.icon, size: 18, color: item.accent),
                ),
              ],
            ),
          SizedBox(height: 24,),

            // Value text
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
                child: FadeTransition(opacity: animation, child: child),
              ),
              child: Text(
                box.read("isLogged") == 'Linguista9' ? item.value : "- - -",
                key: ValueKey(item.value), // important for AnimatedSwitcher to detect change
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),


            const SizedBox(height: 6),

            // Optional hint
            Text(
              'Tap for details',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }
}
