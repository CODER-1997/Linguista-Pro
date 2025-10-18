import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:linguista_ios/constants/theme.dart';
import 'package:linguista_ios/constants/utils.dart';
import '../../constants/custom_funcs/img_uploader.dart';

class Profil extends StatelessWidget {
  final box = GetStorage();
  final ImageUploader uploader = ImageUploader();

  DateTime _selectedDate = DateTime.now();
  RxString selectedDate =
      '${DateFormat('MMMM, y').format(DateTime.now())}'.obs;
  RxList classes = [].obs;

  void setNextMonth() {
    _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1);
    selectedDate.value = DateFormat('MMMM, y').format(_selectedDate);
  }

  void setPreviousMonth() {
    _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1);
    selectedDate.value = DateFormat('MMMM, y').format(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      appBar: AppBar(
        backgroundColor: CupertinoColors.systemGrey6,
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: CupertinoColors.black,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('LinguistaTeachers')
            .doc(box.read('teacherDocId'))
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("No data available"));
          }

          var documentData = snapshot.data!.data() as Map<String, dynamic>;
          var teacher = documentData['items'];
          var imgUrl = teacher['imgUrl'];
          List data = teacher['classHours'] ?? [];

          classes.clear();
          for (var item in data) {
            if (DateFormat('MMMM, y').format(_selectedDate).toString() ==
                convertDateToMonthYear(item['Date']).toString()) {
              classes.add(item);
            }
          }

          return CupertinoScrollbar(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              children: [
                // Profile Header
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  decoration: BoxDecoration(
                    color: CupertinoColors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 45,
                            backgroundColor: CupertinoColors.systemGrey5,
                            backgroundImage:
                            (imgUrl != null && imgUrl.toString().isNotEmpty)
                                ? NetworkImage(imgUrl)
                                : null,
                            child: (imgUrl == null ||
                                imgUrl.toString().isEmpty)
                                ? Text(
                              teacher['name'][0].toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: CupertinoColors.activeBlue),
                            )
                                : null,
                          ),
                          Positioned(
                            right: 4,
                            bottom: 4,
                            child: Obx(() => uploader.isUploading.value
                                ? const CupertinoActivityIndicator(radius: 8)
                                : CupertinoButton(
                              padding: EdgeInsets.zero,
                              borderRadius: BorderRadius.circular(30),
                              color: CupertinoColors.systemGrey4,
                              child: const Icon(
                                CupertinoIcons.camera_fill,
                                color: CupertinoColors.black,
                                size: 18,
                              ),
                              onPressed: () async {
                                await uploader.uploadTeacherImage(
                                    box.read('teacherDocId'));
                              },
                            )),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "${teacher['name']} ${teacher['surname']}",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "ID: ${box.read('teacherId')}",
                        style: const TextStyle(
                            fontSize: 14, color: CupertinoColors.systemGrey),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                // Month Selector
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    color: CupertinoColors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Obx(
                        () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            setPreviousMonth();
                            classes.clear();
                            for (var item in data) {
                              if (DateFormat('MMMM, y')
                                  .format(_selectedDate)
                                  .toString() ==
                                  convertDateToMonthYear(item['Date'])
                                      .toString()) {
                                classes.add(item);
                              }
                            }
                          },
                          child: const Icon(CupertinoIcons.chevron_left,
                              color: CupertinoColors.activeBlue),
                        ),
                        Text(
                          selectedDate.value,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            setNextMonth();
                            classes.clear();
                            for (var item in data) {
                              if (DateFormat('MMMM, y')
                                  .format(_selectedDate)
                                  .toString() ==
                                  convertDateToMonthYear(item['Date'])
                                      .toString()) {
                                classes.add(item);
                              }
                            }
                          },
                          child: const Icon(CupertinoIcons.chevron_right,
                              color: CupertinoColors.activeBlue),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Classes Summary
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  decoration: BoxDecoration(
                    color: CupertinoColors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(CupertinoIcons.book_solid,
                          color: CupertinoColors.activeBlue, size: 22),
                      const SizedBox(width: 10),
                      Text(
                        "Classes this month: ${classes.length}",
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
