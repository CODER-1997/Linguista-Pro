import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../constants/custom_widgets/FormFieldDecorator.dart';
import '../../../constants/custom_widgets/gradient_button.dart';
import '../../../controllers/students/student_controller.dart';

class AddStudent extends StatelessWidget {

  final String groupName;
  final String groupId;

  AddStudent({required this.groupName, required this.groupId, });


  StudentController studentController = Get.put(StudentController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(CupertinoIcons.person_add_solid,color: Colors.white,),
      onPressed:    () {
      studentController.selectedGroup.value = groupName;
      studentController.selectedGroupId.value =  groupId;
      studentController.isFreeOfCharge.value = false;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.white,
            insetPadding: EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            //this right here
            child: Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                width: Get.width,
                height: Get.height/1.5 ,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text("Talaba qo'shish"),
                        SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                            controller: studentController.name,
                            keyboardType: TextInputType.text,
                            decoration: buildInputDecoratione(
                                'Ismi:'
                                    .tr
                                    .capitalizeFirst! ??
                                    ''),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Maydonlar bo'sh bo'lmasligi kerak";
                              }
                              return null;
                            }),
                        SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                            controller: studentController.surname,
                            keyboardType: TextInputType.text,
                            decoration: buildInputDecoratione(
                                'Familiyasi'
                                    .tr
                                    .capitalizeFirst! ??
                                    ''),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Maydonlar bo'sh bo'lmasligi kerak";
                              }
                              return null;
                            }),
                        SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: studentController.phone,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            MaskTextInputFormatter(
                                mask: '+998 ## ### ## ##',
                                filter: {"#": RegExp(r'[0-9]')},
                                type: MaskAutoCompletionType.lazy)
                          ],
                          decoration: buildInputDecoratione(
                              '+998 ## ### ## ##'
                                  .tr
                                  .capitalizeFirst! ??
                                  ''),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Maydonlar bo'sh bo'lmasligi kerak";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Obx(
                                  () => Text(
                                  'Kelgan kuni:  ${studentController.paidDate.value}'),
                            ),
                            IconButton(
                                onPressed: () {
                                  studentController.showDate(
                                      studentController.paidDate);
                                },
                                icon: Icon(Icons.calendar_month))
                          ],
                        ),

                        // SizedBox(
                        //   height: 16,
                        // ),
                        // Row(
                        //   mainAxisAlignment:
                        //   MainAxisAlignment.start,
                        //   children: [
                        //     Text(
                        //       'Choose Group',
                        //       style: appBarStyle,
                        //     ),
                        //   ],
                        // ),

                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          children: [
                            Obx(() => InkWell(
                              onTap: () {
                                studentController
                                    .isFreeOfCharge.value =
                                !studentController
                                    .isFreeOfCharge.value;
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 8),
                                margin: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: studentController
                                        .isFreeOfCharge
                                        .value
                                        ? Colors.green
                                        : Colors.white,
                                    borderRadius:
                                    BorderRadius.circular(
                                        112),
                                    border: Border.all(
                                        color: Colors.green,
                                        width: 1)),
                                child: Text(
                                  "To'lovdan ozod",
                                  style: TextStyle(
                                    color: studentController
                                        .isFreeOfCharge
                                        .value
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            )),
                          ],
                        )
                        // Obx(() => Container(
                        //   alignment: Alignment.topLeft,
                        //   child: SingleChildScrollView(
                        //     scrollDirection: Axis.horizontal,
                        //     child: Row(
                        //       children: [
                        //         for (int i = 0;
                        //         i <
                        //             studentController
                        //                 .PiramidGroups
                        //                 .length;
                        //         i++)
                        //           InkWell(
                        //             onTap: () {
                        //               studentController
                        //                   .selectedGroup
                        //                   .value =
                        //               studentController
                        //                   .PiramidGroups[i]['group_name'];
                        //               studentController
                        //                   .selectedGroupId
                        //                   .value =
                        //               studentController
                        //                   .PiramidGroups[i]['group_id'];
                        //               print(studentController.selectedGroupId.value);
                        //             },
                        //             child: Container(
                        //               padding:
                        //               EdgeInsets.symmetric(
                        //                   horizontal: 18,
                        //                   vertical: 8),
                        //               margin: EdgeInsets.all(8),
                        //               decoration: studentController
                        //                   .selectedGroupId
                        //                   .value !=
                        //                   studentController
                        //                       .PiramidGroups[
                        //                   i]['group_id']
                        //                   ? BoxDecoration(
                        //                   borderRadius:
                        //                   BorderRadius.circular(
                        //                       112),
                        //                   border: Border.all(
                        //                       color: Colors
                        //                           .black,
                        //                       width: 1))
                        //                   : BoxDecoration(
                        //                   color:
                        //                   Colors.green,
                        //                   borderRadius:
                        //                   BorderRadius.circular(
                        //                       112),
                        //                   border: Border.all(
                        //                       color: Colors.green,
                        //                       width: 1)),
                        //               child: Text(
                        //                 "${studentController.PiramidGroups[i]['group_name']}"
                        //                 ,
                        //                 style: TextStyle(
                        //                     color: studentController
                        //                         .selectedGroupId
                        //                         .value !=
                        //                         studentController
                        //                             .PiramidGroups[
                        //                         i]['group_id']
                        //                         ? Colors.black
                        //                         : CupertinoColors
                        //                         .white),
                        //               ),
                        //             ),
                        //           )
                        //       ],
                        //     ),
                        //   ),
                        // ))
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate() &&
                            studentController
                                .selectedGroupId.value.isNotEmpty) {
                          studentController.addNewStudent(  );
                        }
                      },
                      child: Obx(() => CustomButton(
                          isLoading:
                          studentController.isLoading.value,
                          text: "Qo'shish".tr.capitalizeFirst!)),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
    );
  }
}
