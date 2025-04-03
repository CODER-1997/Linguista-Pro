import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:linguista_ios/constants/custom_widgets/gradient_button.dart';
import 'package:linguista_ios/constants/text_styles.dart';
import 'package:linguista_ios/constants/theme.dart';
import 'package:linguista_ios/constants/utils.dart';
import 'package:linguista_ios/controllers/admin/teachers_controller.dart';
import 'package:linguista_ios/controllers/teacher_controller/teacher_controller.dart';
import '';

class TeachersHours extends StatelessWidget {

  final String name;
  final String docId;
   TeachersHours({required this.name, required this.docId});
   TeacherController teachersController = Get.put(TeacherController());


   DateTime _selectedDate = DateTime.now();
   RxString selectedDate = '${DateFormat('MMMM, y').format(DateTime.now())}'.obs;

  void setNextMonth() {
       _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1);

       selectedDate.value =DateFormat('MMMM, y').format(_selectedDate);
   }

  void setPreviousMonth() {
       _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1);
       selectedDate.value =DateFormat('MMMM, y').format(_selectedDate);

   }

   RxList classes = [].obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: homePagebg,
      appBar: AppBar(
        title: Text(name),
      ),
      body: Padding(
          padding: const EdgeInsets.all(1.0),
          child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('LinguistaTeachers')
                  .doc(docId)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.hasData) {
                  var documentData =  snapshot.data!.data() as Map<String, dynamic>;
                  List data = documentData['items']['classHours'] ?? [];
                  classes.clear();
                  for(var item in data){
                    if(DateFormat('MMMM, y').format(_selectedDate).toString() ==convertDateToMonthYear((item['Date'])).toString()){
                      classes.add(item);
                    }
                  }
                  

                  
                  
                  
                   return
                       Obx(()=>  SingleChildScrollView(
                         child: Column(children: [
                           Obx(()=>

                               Row(
                                 children: [
                                   SizedBox(width: 16,),
                                   Container(child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                   IconButton(onPressed: (){
                                     setPreviousMonth();
                                     classes.clear();
                                     for(var item in data){
                                       if(DateFormat('MMMM, y').format(_selectedDate).toString() ==convertDateToMonthYear((item['Date'])).toString()){
                                         classes.add(item);
                                       }
                                     }
                                   }, icon: Icon(Icons.arrow_back_ios)),
                                   Text("${selectedDate.value}"),
                                   IconButton(onPressed: (){
                                     setNextMonth();
                                     classes.clear();
                                     for(var item in data){
                                       if(DateFormat('MMMM, y').format(_selectedDate).toString() ==convertDateToMonthYear((item['Date'])).toString()){
                                         classes.add(item);
                                       }
                                     }


                                   }, icon: Icon(Icons.arrow_forward_ios_rounded))
                                                                ],),),
                                   Container(
                                     padding: EdgeInsets.all(16),
                                     margin: EdgeInsets.all(4),
                                     decoration: BoxDecoration(
                                     color: Colors.white,
                                     borderRadius: BorderRadius.circular(12),
                                     
                                   ),
                                   child: Text('Darslar soni: ${classes.length}'),
                                   )
                                 ],
                               ),
                           ),
                           for(var item in classes)
                             classHour(isPaid: item['isPaid'], date: item['Date'], docId: docId,uniqueId: item['id'], teacherController: teachersController,),

                         ],),
                       )
                       );
                }
                // If no data available

                else {
                  return Text('No data'); // No data available
                }
              })),










      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
            onTap: (){
              teachersController.addTeacherClassHour(docId);
            },
            child: CustomButton(text: "Qo'shish")),
      ),
    );
    
  }
}

class classHour extends StatelessWidget {
  final bool isPaid;
  final String date;
  final String docId;
  final String uniqueId;
  final TeacherController teacherController;

  const classHour({required this.isPaid, required this.date, required this.docId, required this.uniqueId, required this.teacherController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      color: Colors.white
    ),
    child: Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Text("O'tildi"),
        Text("2 soat",style: appBarStyle.copyWith(fontSize: 12),),
      ],),
      SizedBox(height: 8,),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Sana"),
          Text("$date".toString(),style: appBarStyle.copyWith(fontSize: 12,color: Colors.green),),
        ],),
      SizedBox(height: 8,),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("To'lov"),
          Text(isPaid ? "To'langan ":"To'lanmagan",style: appBarStyle.copyWith(fontSize: 12,color: isPaid ? Colors.green :Colors.red),),
        ],),
      SizedBox(height: 8,),

      InkWell(
        onTap: (){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Delete Item"),
                content: Text("Are you sure you want to delete this item?"),
                actions: <Widget>[
                  TextButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                  TextButton(
                    child: Text(
                      "Delete",
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      // Perform the delete action here
                      
                       teacherController.deleteClassHours(docId, uniqueId);
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ],
              );
            },
          );
        },

          child: CustomButton(text: 'Bekor qilish',color: Colors.red,))
    ],),
    );
  }
}
