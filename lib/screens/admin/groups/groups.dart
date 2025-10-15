import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
 import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:linguista_ios/constants/custom_widgets/group_shimmer.dart';
import 'package:linguista_ios/controllers/auth/login_controller.dart';
import 'package:get_storage/get_storage.dart';
import '../../../constants/custom_widgets/FormFieldDecorator.dart';
 import '../../../constants/custom_widgets/gradient_button.dart';
import '../../../constants/text_styles.dart';
import '../../../constants/theme.dart';
import '../../../controllers/groups/group_controller.dart';
 import '../../students_by_group/students_by_group.dart';

class AdminGroups extends StatefulWidget {
  @override
  State<AdminGroups> createState() => _AdminGroupsState();
}

class _AdminGroupsState extends State<AdminGroups> {
  final _formKey = GlobalKey<FormState>();

  GroupController groupController = Get.put(GroupController());

  FireAuth auth = Get.put(FireAuth());

  int order = 0;
  GetStorage box = GetStorage();

  void _updateOrder(List<QueryDocumentSnapshot> documents, int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final movedDocument = documents.removeAt(oldIndex);
    documents.insert(newIndex, movedDocument);

    // Update Firestore with the new order
    for (int i = 0; i < documents.length; i++) {
      FirebaseFirestore.instance
          .collection('LinguistaGroups')
          .doc(documents[i].id)
          .update({'items.order': i});
    }
  }


   @override
  void initState() {

     super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe8e8e8),
      appBar: AppBar(
        backgroundColor: dashBoardColor,
        toolbarHeight: 64,
        title: Text(
          "Linguista",
          style: appBarStyle.copyWith(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 16,
            ),
            child:  box.read('isLogged') == 'testuser' ? SizedBox():InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      backgroundColor: Colors.white,
                      insetPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
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
                          height: Get.height / 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text("Add Group"),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  TextFormField(
                                      controller: groupController.GroupName,
                                      keyboardType: TextInputType.text,
                                      decoration:
                                          buildInputDecoratione('Group name'),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Maydonlar bo'sh bo'lmasligi kerak";
                                        }
                                        return null;
                                      }),
                                  SizedBox(
                                    height: 16,
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    groupController.addNewGroup();
                                  }
                                },
                                child: Obx(() => CustomButton(
                                    isLoading: groupController.isLoading.value,
                                    text: "Add")),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              child: Container(
                padding: EdgeInsets.all(12),
                child: Text(
                  "Add group",
                  style: TextStyle(color: Colors.white),
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                     borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),

          IconButton(
              onPressed: () {
                auth.logOut();
              },
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8,top:8,right: 8),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('LinguistaGroups').orderBy('items.order')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return GroupListShimmer();
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (snapshot.hasData) {
                var groups = snapshot.data!.docs;
               groupController.order.value = groups.length+1;
                List<QueryDocumentSnapshot> documents = snapshot.data!.docs;




                return ReorderableListView(
                  onReorder: (oldIndex, newIndex) => _updateOrder(documents, oldIndex, newIndex),
                  children: [
                    for (final document in documents)
                      Slidable(
                        key: ValueKey(document.id),
                        endActionPane: box.read('isLogged') == 'testuser'
                            ? null
                            : ActionPane(
                          motion: const DrawerMotion(),
                          extentRatio: 0.45, // width of actions
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                // Edit dialog
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    groupController.setValues(document['items']['name']);
                                    return Dialog(
                                      backgroundColor: Colors.white,
                                      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      child: Form(
                                        key: _formKey,
                                        child: Container(
                                          padding: const EdgeInsets.all(16),
                                          height: Get.height / 3,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                children: [
                                                  const Text("Edit Group"),
                                                  const SizedBox(height: 16),
                                                  TextFormField(
                                                    controller: groupController.GroupEdit,
                                                    decoration:
                                                    buildInputDecoratione('Group name'),
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return "Field cannot be empty";
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ],
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  if (_formKey.currentState!.validate()) {
                                                    groupController
                                                        .editGroup(document.id.toString());
                                                  }
                                                },
                                                child: Obx(() => CustomButton(
                                                  isLoading:
                                                  groupController.isLoading.value,
                                                  text: "Edit",
                                                )),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: 'Edit',
                            ),
                            SlidableAction(
                              onPressed: (context) {

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      backgroundColor: Colors.white,
                                      insetPadding: EdgeInsets.symmetric(horizontal: 16),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12.0)),

                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 12,horizontal: 12),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(12)),
                                        width: Get.width,
                                        height: Get.height/4 ,
                                        child:Container(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,

                                            children: [
                                              Text("Delete Group",
                                                style: TextStyle(
                                                    color: CupertinoColors.black,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold

                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(height: 32,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [

                                                  ElevatedButton(

                                                      onPressed: (){
                                                        if(    box.read('isLogged') == 'Linguista9' ){

                                                          groupController.deleteGroup(document.id);


                                                          Navigator.pop(context);
                                                        }


                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.greenAccent,
                                                        foregroundColor: Colors.white,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(32),
                                                        ),
                                                        padding:   EdgeInsets.symmetric(horizontal: Get.width/7, vertical: 14),
                                                        elevation: 5,
                                                      ),

                                                      child: Text('Yes')),
                                                  ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.red,
                                                        foregroundColor: Colors.white,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(32),
                                                        ),
                                                        padding:   EdgeInsets.symmetric(horizontal: Get.width/7, vertical: 14),
                                                        elevation: 5,
                                                      ),

                                                      onPressed: (){
                                                        Navigator.pop(context);
                                                      }, child: Text("No")),



                                                ],)
                                            ],),


                                        ),
                                      ),
                                    );
                                  },
                                );


                              },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: () {

                              Get.to(StudentsByGroup(
                                groupId: document['items']['uniqueId'],
                                groupName: document['items']['name'],
                              ));

                          },
                          child: Container(
                            width: Get.width,
                            padding: const EdgeInsets.all(20),
                            margin: const EdgeInsets.symmetric(vertical: 1),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.teal,
                                      radius: 16,
                                      child: Text(
                                        "${document['items']['order'] + 1}",
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    SizedBox(
                                      width: Get.width / 1.8,
                                      child: Text(
                                        document['items']['name'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                          fontSize: 12,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),


                  ],
                );

              }
              // If no data available

              else {
                return Text('No data'); // No data available
              }
            }),
      ),

    );
  }
}
