import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../constants/custom_funcs/img_uploader.dart';
import '../../../controllers/admin/teachers_controller.dart';
import 'teachers_hours.dart';

class Teacherinfo extends StatefulWidget {
  final String documentId;

  const Teacherinfo({super.key, required this.documentId});

  @override
  State<Teacherinfo> createState() => _TeacherinfoState();
}

class _TeacherinfoState extends State<Teacherinfo> {
  final TeachersController teachersController = Get.put(TeachersController());
   final uploader = ImageUploader();


  // Upload and update teacher photo
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: const Text(
          "Teacher Info",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('LinguistaTeachers')
            .doc(widget.documentId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CupertinoActivityIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final items = data['items'];
          final photoUrl = items['imgUrl'];

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
              // --- Header with avatar and ID ---
              Obx(()=>              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 38,
                          backgroundColor: const Color(0xFFE9E9EF),
                          backgroundImage: photoUrl != null
                              ? NetworkImage(photoUrl)
                              : const AssetImage('assets/teacher_avatar.png')
                          as ImageProvider,
                        ),
                        if (uploader.isLoading.value)
                          const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.deepPurple,
                          ),
                        if (!uploader.isLoading.value)
                          Positioned(
                            bottom: -2,
                            right: -2,
                            child: InkWell(
                              onTap: ()async {
                                await uploader.uploadTeacherImage(widget.documentId);
                              },
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.deepPurple,
                                ),
                                child: const Icon(
                                  CupertinoIcons.camera_fill,
                                  size: 24,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${items['name']} ${items['surname']}",
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "ID: ${items['uniqueId']}",
                            style: const TextStyle(
                                color: CupertinoColors.systemGrey, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ),
              const SizedBox(height: 16),

              // --- Info Section ---
              _sectionTitle("Information"),
              _infoTile(
                icon: CupertinoIcons.person_crop_circle,
                title: "Status",
                value: items['isBanned'] ? "Chetlashtirilgan" : "Ishlayapti",
                valueColor:
                items['isBanned'] ? Colors.redAccent : Colors.green,
              ),
              const SizedBox(height: 10),
              _infoTile(
                icon: CupertinoIcons.clock,
                title: "Dars soatlari",
                trailing: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Get.to(() => TeachersHours(
                      name: "${items['name']} ${items['surname']}",
                      docId: widget.documentId,
                    ));
                  },
                  child: const Icon(CupertinoIcons.forward,
                      size: 18, color: CupertinoColors.systemGrey),
                ),
              ),
              const SizedBox(height: 20),

              // --- Action Section ---
              _sectionTitle("Actions"),
              GestureDetector(
                onTap: () {
                  teachersController.blockTeacher(
                      widget.documentId, !items['isBanned']);
                },
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        items['isBanned']
                            ? CupertinoIcons.lock_open_fill
                            : CupertinoIcons.lock_fill,
                        color: items['isBanned']
                            ? Colors.green
                            : Colors.redAccent,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        items['isBanned']
                            ? "Blokdan chiqarish"
                            : "Bloklash",
                        style: TextStyle(
                          color: items['isBanned']
                              ? Colors.green
                              : Colors.redAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          );
        },
      ),
    );
  }

  // Section title widget
  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 6),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        color: CupertinoColors.systemGrey,
        fontWeight: FontWeight.w500,
      ),
    ),
  );

  // Info tile widget
  Widget _infoTile({
    required IconData icon,
    required String title,
    String? value,
    Widget? trailing,
    Color? valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: CupertinoColors.systemBlue, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style:
              const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
          if (value != null)
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: valueColor ?? Colors.black87,
              ),
            ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }
}
