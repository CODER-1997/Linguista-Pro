
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:linguista_ios/constants/custom_funcs/snackbar.dart';

import '../../../constants/custom_widgets/FormFieldDecorator.dart';
import '../../../constants/custom_widgets/gradient_button.dart';
import '../../../constants/input_formatter.dart';
import '../../../constants/text_styles.dart';
import '../../../constants/theme.dart';
import '../../../constants/utils.dart';
import '../../../controllers/students/student_controller.dart';

class AdminStudentPaymentHistory extends StatefulWidget {
  final String uniqueId;
  final String id;
  final String name;
  final String surname;
  final List paidMonths;

  AdminStudentPaymentHistory(
      {required this.uniqueId,
        required this.id,
        required this.name,
        required this.surname,
        required this.paidMonths
      });

  @override
  State<AdminStudentPaymentHistory> createState() => _AdminStudentPaymentHistoryState();
}

class _AdminStudentPaymentHistoryState extends State<AdminStudentPaymentHistory>  with SingleTickerProviderStateMixin{
  StudentController studentController = Get.put(StudentController());

  final _formKey = GlobalKey<FormState>();


  List<String> months = getFormattedMonthsOfCurrentYear();

  GetStorage box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,


        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: CupertinoColors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          '${widget.name}'.capitalizeFirst! +
              " " +
              "${widget.surname}".capitalizeFirst! +
              "  payment history",
          style:
          appBarStyle.copyWith(color: CupertinoColors.black, fontSize: 12),
        ),
       
      ),
      body:   SingleChildScrollView(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('LinguistaStudents').where('items.uniqueId',isEqualTo: '${widget.uniqueId}')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                    height: Get.height,
                    width: Get.width,
                    child: Center(child: CircularProgressIndicator()));
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (snapshot.hasData) {
                List payments = snapshot.data!.docs;
                return payments[0]['items']['payments'].isNotEmpty
                    ? Column(
                  children: [
                    for (int i = 0;
                    i < payments[0]['items']['payments'].length;
                    i++)
                      Container(
                        width: Get.width,
                        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          border: Border.all(color: Colors.grey.shade200, width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header row with icons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(CupertinoIcons.money_dollar_circle_fill,
                                        color: Colors.green, size: 24),
                                    const SizedBox(width: 6),
                                    Text(
                                      "Payment Details",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                          color: Colors.grey.shade800),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.deepPurpleAccent, Colors.deepPurple],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(CupertinoIcons.calendar, color: Colors.white, size: 14),
                                      const SizedBox(width: 4),
                                      Text(
                                        convertDate("${payments[0]['items']['payments'][i]['paidDate']}"),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            // Amount section
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(CupertinoIcons.creditcard_fill,
                                        color: Colors.blueAccent, size: 22),
                                    const SizedBox(width: 6),
                                    Text(
                                      "To‘lov miqdori:",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "${payments[0]['items']['payments'][i]['paidSum']} so'm",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),
                            Divider(height: 1, color: Colors.grey.shade200),
                            const SizedBox(height: 8),

                            // Action buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  tooltip: "Edit payment",

                                  disabledColor: Colors.grey,

                                  onPressed:  box.read('isEnabled') !='Linguista9'?null: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          backgroundColor: Colors.white,
                                          insetPadding:
                                          const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.all(20),
                                            height: Get.height / 2.4,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text(
                                                  "Edit Payment",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.deepPurple),
                                                ),
                                                TextFormField(
                                                  inputFormatters: [ThousandSeparatorInputFormatter()],
                                                  keyboardType: TextInputType.number,
                                                  controller: studentController.payment,
                                                  decoration:
                                                  buildInputDecoratione('Enter amount (so‘m)'),
                                                  validator: (value) =>
                                                  value!.isEmpty ? "Required field" : null,
                                                ),
                                                TextFormField(
                                                  controller: studentController.paymentComment,
                                                  decoration: buildInputDecoratione('Comment'),
                                                ),
                                                Row(
                                                  children: [
                                                    Obx(() => Text(
                                                        'Paid date: ${studentController.paidDate.value}')),
                                                    IconButton(
                                                      onPressed: () {
                                                        studentController
                                                            .showDate(studentController.paidDate);
                                                      },
                                                      icon: const Icon(CupertinoIcons.calendar_today,
                                                          color: Colors.deepPurple),
                                                    ),
                                                  ],
                                                ),
                                                Obx(() => CustomButton(
                                                    isLoading: studentController.isLoading.value,
                                                    text: "Save Changes")),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    CupertinoIcons.pencil_circle_fill,
                                    color: Colors.deepPurple,
                                    size: 28,
                                  ),
                                ),
                                IconButton(
                                  tooltip: "Delete payment",
                                  onPressed: () {
                                    if (box.read('isLogged') == 'Linguista9') {
                                      studentController.deletePayment(widget.id,
                                          payments[0]['items']['payments'][i]['id']);
                                    } else {
                                      showCustomSnackBar(
                                        context,
                                        title: 'Warning',
                                        message: 'Only admin can change data',
                                        backgroundColor: CupertinoColors.systemYellow,
                                        icon: Icons.warning_rounded,
                                      );
                                    }
                                  },
                                  icon: const Icon(
                                    CupertinoIcons.trash_fill,
                                    color: Colors.redAccent,
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )

                  ],
                )
                    : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 200,
                      ),
                      Image.asset(
                        'assets/fee_not_charged.png',
                        width: 222,
                      ),
                      Text(
                        '${widget.name}'.capitalizeFirst! +
                            " " +
                            "${widget.surname}".capitalizeFirst! +
                            " has not any payments ",
                        style:
                        TextStyle(color: Colors.black, fontSize: 12),
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,

        child: Icon(CupertinoIcons.add,color: Colors.white,),
        onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              backgroundColor: Colors.white38,
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
                  height: Get.height / 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(),
                          Text("Add fee"),
                          IconButton(
                              onPressed: Get.back,
                              icon: Icon(Icons.close))
                        ],
                      ),
                      TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            ThousandSeparatorInputFormatter(),
                          ],
                          controller: studentController.payment,
                          decoration: buildInputDecoratione('Price'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Maydonlar bo'sh bo'lmasligi kerak";
                            }
                            return null;
                          }),
                      TextFormField(
                        keyboardType: TextInputType.text,

                        controller: studentController.paymentComment,
                        decoration:
                        buildInputDecoratione('Commentary'),
                        // validator: (value) {
                        //   if (value!.isEmpty) {
                        //     return "Maydonlar bo'sh bo'lmasligi kerak";
                        //   }
                        //   return null;
                        // },
                      ),
                      Row(
                        children: [
                          Obx(
                                () => Text(
                                'Paid date:  ${studentController.paidDate.value}'),
                          ),
                          IconButton(
                              onPressed: () {
                                studentController.showDate(
                                    studentController.paidDate);
                              },
                              icon: Icon(Icons.calendar_month))
                        ],
                      ),
                      Container(
                        height: 40,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(children: [
                            for(var item in generateMonths())
                              InkWell(
                                onTap:(){
                                  studentController.paidDate.value  = item;
                                },
                                child: Obx(()=>Container(

                                  padding:EdgeInsets.all(8),
                                  margin:EdgeInsets.only(right: 4),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey,width: 1),
                                      color: studentController.paidDate.value  == item ? Colors.green:Colors.white,
                                      borderRadius: BorderRadius.circular(12)
                                  ),
                                  child: Text(convertDateToMonthYear(item),style: TextStyle(
                                    color: studentController.paidDate.value  == item ? Colors.white:Colors.black,

                                  ),),
                                )),
                              )

                          ],),),
                      ),

                      InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate() &&
                              studentController
                                  .paidDate.value.isNotEmpty) {
                            studentController.addPayment(
                                widget.id, studentController.paidDate.value);
                          }
                        },
                        child: Obx(() => CustomButton(
                            isLoading:
                            studentController.isLoading.value,
                            text: 'confirm'.tr.capitalizeFirst!)),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },),
    );
  }
}
