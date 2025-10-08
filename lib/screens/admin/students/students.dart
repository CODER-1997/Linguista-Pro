import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:linguista_ios/screens/admin/students/student_info.dart';
import 'package:linguista_ios/screens/admin/students/super_search.dart';


import '../../../constants/custom_widgets/emptiness.dart';

import '../../../constants/custom_widgets/student_card_widget/gradient_container.dart';
import '../../../constants/custom_widgets/student_card_widget/leader_student_card.dart';
import '../../../constants/theme.dart';
import '../../../controllers/students/student_controller.dart';

class AdminStudents extends StatefulWidget {
  @override
  State<AdminStudents> createState() => _AdminStudentsState();
}

class _AdminStudentsState extends State<AdminStudents> {

  StudentController studentController = Get.put(StudentController());

  String _searchText = '';
  RxList students = [].obs;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe8e8e8),
      appBar: AppBar(
        backgroundColor: dashBoardColor,
        toolbarHeight: 64,
        centerTitle: true,
        title: Text('Liderboard',style: const TextStyle(
          fontSize: 24,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w800,
          color: Colors.white, // letter color
        ),),

      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('LinguistaStudents')
                    .where('items.isDeleted', isEqualTo: false)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (snapshot.hasData) {
                    students.clear();

                    for(var item in snapshot.data!.docs){
                      students.add(item);


                    }



                    return students.length != 0
                        ? Column(
                      children: [

                        Expanded(
                          flex:11,
                          child: ListView.builder(
                              itemCount: students.length,
                              itemBuilder: (context, i) {
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(  StudentInfo(studentId: students[i].id));
                                  },
                                  child: GradientStudentCard(
                                    item: students[i]['items'], position: '${i+1}',
                                  ),
                                );
                              }),
                        ),
                      ],
                    )
                        : Emptiness(
                        title: 'Our center has not any students ');
                  }
                  // If no data available

                  else {
                    return Text('No data'); // No data available
                  }
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(SuperSearch(students: students.value,));
        },
        backgroundColor: Colors.white,

        child: Icon(Icons.search),
      ),
    );
  }
}

class TopThreeUser extends StatelessWidget {

  final String img;
  final String name;
  final String surname;
  final double h;
  final double w;
  const TopThreeUser({
    super.key, required this.img, required this.h, required this.w, required this.name, required this.surname,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(height: 8,),

      Image.asset('assets/$img.png',width: 32,),
      SizedBox(height: 4,),

      Stack(
        alignment: Alignment.bottomCenter,
        children: [
          GradientLetterBox(
            isBordered: true,
            h: h,
            w: w,

            letter: name.substring(0,1), position: '1',),
          Container (alignment:Alignment.center,
            width: 72,
            height: 24,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [Colors.orangeAccent,Colors.yellowAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
            ),
            child: Text("988 ball",style:
            TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,

            ),
              textAlign: TextAlign.center,),)
        ],
      ),
      SizedBox(height: 4,),

      Text("Bekzod \nNurmurodov",style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 10,
          fontFamily: 'Nunito'

      ),
        textAlign: TextAlign.center,),


    ],);
  }
}
