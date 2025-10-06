import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get_storage/get_storage.dart';
import 'package:linguista_ios/constants/text_styles.dart';

import '../../constants/custom_widgets/FormFieldDecorator.dart';
import '../../controllers/admin/teachers_controller.dart';
import '../../controllers/auth/login_controller.dart';
import '../admin/admin_home_screen.dart';
import 'login.dart';

class SignUp extends StatelessWidget {
  Rx isLogin = true.obs;
  Rx isVisible = false.obs;

  FireAuth auth = Get.put(FireAuth());
  GetStorage box = GetStorage();
  TeachersController teachersController = Get.put(TeachersController());
  TextEditingController secretKey = TextEditingController();




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff012931), Color(0xff012931)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            Text(
              'Sign up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            TextFormField(
                controller:
                teachersController.TeacherName,
                keyboardType: TextInputType.text,
                decoration: buildInputDecoratione(
                    'Teacher name'),
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
                controller:
                teachersController.TeacherSurname,
                keyboardType: TextInputType.text,
                decoration: buildInputDecoratione(
                    'Teacher surname'),
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
                controller:secretKey ,
                keyboardType: TextInputType.text,
                decoration: buildInputDecoratione(
                    'Enter keyword given by Admin'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Maydonlar bo'sh bo'lmasligi kerak";
                  }
                  return null;
                }),
            SizedBox(
              height: 32,
            ),
            // test,,,,,,
            ElevatedButton(
              onPressed: () {
                      if(secretKey.text =='maylikir' && teachersController.TeacherName.text.isNotEmpty && teachersController.TeacherSurname.text.isNotEmpty){
                        teachersController.addNewTeacher();
                        Get.offAll(Login());
                        Get.snackbar(
                          duration: Duration(seconds: 5),
                          icon: Icon(Icons.block,color: Colors.white,),
                          "Success",
                          "Your account is created.",
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );


                      }


              },
              child: Text('Sign Up'.tr.capitalizeFirst!),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15.0),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
              TextButton(onPressed: (){
                Get.offAll(Login());

              }, child: Text('Have an account ? Login',style: appBarStyle.copyWith(
                color: Colors.white,
                fontSize: 14
              ),))
            ],)
          ],
        ),
      ),
    );
  }
}
