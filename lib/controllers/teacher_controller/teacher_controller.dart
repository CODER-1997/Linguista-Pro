import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';

import '../../constants/utils.dart';
import '../../models/student_model.dart';

class TeacherController extends GetxController {


  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }





   void addTeacherClassHour(String documentId,) async {
      try {
        // Retrieve the document reference
        DocumentReference documentReference = FirebaseFirestore.instance
            .collection('LinguistaTeachers')
            .doc(documentId);

        // Get the current document snapshot
        DocumentSnapshot documentSnapshot = await documentReference.get();
        Map<String, dynamic> currentMap = Map<String, dynamic>.from(documentSnapshot['items'] ?? {});
        // Get the current array field value
        List<dynamic> currentArray = List<dynamic>.from(currentMap['classHours'] ?? []);
        // Append the new item to the array

        // find element by month and year
        // int index = -1;
        // for (int i = 0; i < currentArray.length; i++) {
        //   if (currentArray[i]['paidMonth'] == month &&
        //       currentArray[i]['paidYear'] == year) {
        //     index = i;
        //     break;
        //   }
        // }
        // if (index == -1) {
        //   currentArray.add({
        //     'paidDate': paidDate,
        //     'paidSum': payment.text,
        //
        //   });
        // }
        // else{
        currentArray.add({
           'Date': DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now()),
           'isPaid': false,
           'id': generateUniqueId()
        });
        // }

        // Update the document with the new array value
        await documentReference.update({
          'items.classHours': currentArray,
        });

        // Optional: Provide feedback to the user
        isLoading.value = false;

      } catch (e) {
        // Handle errors here
        print('Error adding item to array: $e');
        Get.snackbar(
          'Error:${e}',
          e.toString(),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }

  }

  // Edit payment


  void deleteClassHours(
      String documentId,
      String uniqueId,
      ) async {
    try {
      // Retrieve the document reference
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('LinguistaTeachers')
          .doc(documentId);

      // Get the current document snapshot
      DocumentSnapshot documentSnapshot = await documentReference.get();
      Map<String, dynamic> currentMap =
      Map<String, dynamic>.from(documentSnapshot['items'] ?? {});
      // Get the current array field value
      List<dynamic> currentArray =
      List<dynamic>.from(currentMap['classHours'] ?? []);
      // Append the new item to the array

      // find element by month and year
      print('deleting.....');
      int index = -1;
      for (int i = 0; i < currentArray.length; i++) {
        if (currentArray[i]['id'] == uniqueId) {
          index = i;
          break;
        }
      }
      if (index != -1) {
        currentArray.removeAt(index);
      }

      // Update the document with the new array value
      await documentReference.update({
        'items.classHours': currentArray,
      });


    } catch (e) {
      // Handle errors here
      print('Error adding item to array: $e');
      Get.snackbar(
        'Error:${e}',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Check student study inteval by ..


// Edit payment
}
