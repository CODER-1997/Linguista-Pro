import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/admin/teachers_controller.dart';
import 'teachers_hours.dart';

class Teacherinfo extends StatelessWidget {
  final String documentId;
  final TeachersController teachersController = Get.put(TeachersController());

  Teacherinfo({super.key, required this.documentId});

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
            .doc(documentId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CupertinoActivityIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final items = data['items'];

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
              // --- Header with avatar and ID ---
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: const Color(0xFFE9E9EF),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset('assets/teacher_avatar.png'),
                      ),
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
                      name:
                      "${items['name']} ${items['surname']}",
                      docId: documentId,
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
                      documentId, !items['isBanned']);
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
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w500),
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
