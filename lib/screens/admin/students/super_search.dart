import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:linguista_ios/screens/admin/students/student_info.dart';

import '../../../../constants/custom_widgets/FormFieldDecorator.dart';
import '../../../../constants/custom_widgets/emptiness.dart';
import '../../../../constants/theme.dart';
import '../../../constants/custom_widgets/student_card.dart';

class SuperSearch extends StatefulWidget {

  final List students ;

  SuperSearch({required this.students});

  @override
  State<SuperSearch> createState() => _SuperSearchState();
}

class _SuperSearchState extends State<SuperSearch> {






  TextEditingController _searchController = TextEditingController();

  List _filteredItems = [];

  void _filterItems(String query) {
    setState(() {
      _filteredItems = widget.students
          .where((item) => item['items']['name']! .toLowerCase() .contains(query.toLowerCase()) ||
          item['items']['group']! .toLowerCase() .contains(query.toLowerCase())||
          item['items']['phone']! .toLowerCase() .contains(query.toLowerCase())||
          item['items']['surname']! .toLowerCase() .contains(query.toLowerCase()))
          .toList();



    });
  }

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.students;
  }







  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffe8e8e8),
        appBar: AppBar(
          title: Text("Students",style: TextStyle(
            color: Colors.white
          ),),
          backgroundColor: dashBoardColor,
          toolbarHeight: 64,
          leading: IconButton(
            onPressed: Get.back,
            icon: Icon(Icons.arrow_back,color: Colors.white,),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: buildInputDecoratione('Search . . .'),
                onChanged: _filterItems,
              ),
              SizedBox(height: 4),
              Expanded(
                child: _filteredItems.length != 0
                    ? ListView.builder(
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, i) {
                      return GestureDetector(
                        onTap: () {
                          print("aaa"  );
                          Get.to(StudentInfo(
                              studentId: _filteredItems[i].id));
                        },
                        child: StudentCard(
                          item: _filteredItems[i]['items'],
                        ),
                      );
                    })
                    : Emptiness(title: 'No data'),
              ),
            ],
          ),
        ));
  }
}
