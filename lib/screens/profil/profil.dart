import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:linguista_ios/constants/theme.dart';

import '../../constants/utils.dart';

class Profil extends StatelessWidget {
  var box = GetStorage();
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
        title: Text(
          "Profil",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: Get.width,
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Teacher info',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          'Id: ',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w700)),    Text(
                          '${box.read('teacherId')}',
                         ),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          'Fullname: ',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w700)),    Text(
                          '${box.read('teacherName')}  ${box.read('teacherSurname')}',
                         ),
                    ],
                  ),
                ],
              ),
            ),
          StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('LinguistaTeachers')
                  .doc(box.read('teacherDocId'))
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
                      SingleChildScrollView(
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
                                Expanded(child: Container()),

                                Container(
                                  padding: EdgeInsets.all(16),
                                  margin: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),

                                  ),
                                  child: Text('Darslar soni: ${classes.length}'),
                                ),
                                SizedBox(width: 16,),
                                
                              ],
                            ),
                        ),

                      ],),
                    );

                }
                // If no data available

                else {
                  return Text('No data'); // No data available
                }
              })
          ],
        ),
      ),
    );
  }
}
