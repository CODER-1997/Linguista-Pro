
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

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

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  List<String> months = getFormattedMonthsOfCurrentYear();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,

        bottom: TabBar(
          dividerColor: Colors.white,
          labelColor: Colors.red,

          controller: _tabController,
          tabs: [
            Tab(child: Text( "Paid months",style: TextStyle(color: Colors.black),),),
            Tab(child: Text( "Checks",style: TextStyle(color: Colors.black),),),
          ],
        ),
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
      body: TabBarView(
        controller:_tabController,
        children: [
          Container(
            color: homePagebg,
            child: ListView.builder(
            itemCount: months.length,
            itemBuilder: (context, index) {
              return Container(
                color: Colors.white,
                margin: EdgeInsets.only(bottom: 1),
                child: ListTile(
                  tileColor: Colors.white,
                  title: Text(convertDateToMonthYear(months[index])),
                  trailing: hasDebtFromMonth(widget.paidMonths, convertDateToMonthYear(months[index])) == false ? Text("Paid",style: appBarStyle.copyWith(
                    color: Colors.green,
                    fontSize: 12
                  ),):Text("Unpaid",style: appBarStyle.copyWith(
                      color: Colors.red,
                      fontSize: 12
                  ),),
                ),
              );
            },
          ),),
          SingleChildScrollView(
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
                            margin: EdgeInsets.all(2),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: CupertinoColors.white,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    color: Colors.black, width: .5)),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "To'lov qilingan sana: ",
                                          style: appBarStyle.copyWith(
                                              fontSize: 10,
                                              color:
                                              CupertinoColors.systemGrey),
                                        ),
                                        Text(
                                          convertDate(
                                              "${payments[0]['items']['payments'][i]['paidDate']}"),
                                          style: appBarStyle.copyWith(
                                              color: Colors.blue,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "To'lov miqdori: ",
                                          style: appBarStyle.copyWith(
                                              fontSize: 10),
                                        ),
                                        Text(
                                          " ${payments[0]['items']['payments'][i]['paidSum']} so'm",
                                          style: appBarStyle.copyWith(
                                              color: Colors.green,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Dialog(
                                                      backgroundColor:
                                                      Colors.white,
                                                      insetPadding: EdgeInsets
                                                          .symmetric(
                                                          horizontal: 16),
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              12.0)),
                                                      //this right here
                                                      child: Form(
                                                        key: _formKey,
                                                        child: Container(
                                                          padding:
                                                          EdgeInsets.all(
                                                              16),
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .white,
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  12)),
                                                          width: Get.width,
                                                          height: Get.height /
                                                              2.5,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              Text(
                                                                  "Edit course fee"),
                                                              TextFormField(
                                                                  inputFormatters: [
                                                                    ThousandSeparatorInputFormatter(),
                                                                  ],
                                                                  keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                                  controller:
                                                                  studentController
                                                                      .payment,
                                                                  decoration:
                                                                  buildInputDecoratione(
                                                                      'Price'),
                                                                  validator:
                                                                      (value) {
                                                                    if (value!
                                                                        .isEmpty) {
                                                                      return "Maydonlar bo'sh bo'lmasligi kerak";
                                                                    }
                                                                    return null;
                                                                  }),
                                                              TextFormField(
                                                                inputFormatters: [
                                                                  ThousandSeparatorInputFormatter(),
                                                                ],
                                                                keyboardType:
                                                                TextInputType
                                                                    .number,
                                                                controller:
                                                                studentController
                                                                    .paymentComment,
                                                                decoration:
                                                                buildInputDecoratione(
                                                                    'Comment'),
                                                                // validator:
                                                                //     (value) {
                                                                //   if (value!
                                                                //       .isEmpty) {
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
                                                                      onPressed:
                                                                          () {
                                                                        studentController
                                                                            .showDate(studentController.paidDate);
                                                                      },
                                                                      icon: Icon(
                                                                          Icons.calendar_month))
                                                                ],
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  if (_formKey
                                                                      .currentState!
                                                                      .validate() &&
                                                                      studentController
                                                                          .paidDate
                                                                          .value
                                                                          .isNotEmpty) {
                                                                    print(widget.id);
                                                                    print(payments[0]['items']['payments']
                                                                    [
                                                                    i]
                                                                    [
                                                                    'id']);
                                                                    studentController.editPayment(
                                                                        widget.id,
                                                                        payments[0]['items']['payments'][i]
                                                                        [
                                                                        'id']);
                                                                  }
                                                                },
                                                                child: Obx(() => CustomButton(
                                                                    isLoading: studentController
                                                                        .isLoading
                                                                        .value,
                                                                    text: 'Edit'
                                                                        .tr
                                                                        .capitalizeFirst!)),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              icon: Icon(
                                                Icons.edit,
                                                color: Colors.purple,
                                              )),
                                          IconButton(
                                              onPressed: () {
                                                studentController.deletePayment(widget.id,
                                                    payments[0]['items']['payments'][i]
                                                    [
                                                    'id']);
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.redAccent,
                                              )),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                payments[0]['items']['payments'][i]
                                ['paymentCommentary'] !=
                                    null
                                    ? Container(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.warning_amber,
                                        color: Colors.red,
                                      ),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Text(payments[0]['items']
                                      ['payments'][i]
                                      ['paymentCommentary'])
                                    ],
                                  ),
                                )
                                    : SizedBox()
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
        ],
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
