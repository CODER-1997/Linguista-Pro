import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get_storage/get_storage.dart';
import 'package:linguista_ios/constants/text_styles.dart';
import 'package:linguista_ios/screens/auth/sign_up.dart';

import '../../controllers/auth/login_controller.dart';
import '../admin/admin_home_screen.dart';

class Login extends StatelessWidget {
  Rx isLogin = true.obs;
  Rx isVisible = false.obs;

  FireAuth auth = Get.put(FireAuth());
  GetStorage box = GetStorage();

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
              'Login',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: auth.teacherId,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Login:',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 32,
            ),
            TextFormField(
              keyboardType: TextInputType.phone,
              controller: auth.teacherPassword,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Password:',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 32,
            ),
            ElevatedButton(
              onPressed: () {
                if(auth.teacherId.text == 'Linguista9' && auth.teacherPassword.text =='6463070' ){
                  box.write('isLogged', auth.teacherId.text);
                  Get.offAll(AdminHomeScreen());
                }
                else  if (auth.teacherId.text == 'Teacher' || auth.teacherPassword.text.startsWith('+998')){
                  auth.signIn(auth.teacherPassword.text);
                }
                else  if (auth.teacherId.text == 'test' && auth.teacherPassword.text =='123'){
                  box.write('isLogged', 'testuser');
                  Get.offAll(AdminHomeScreen());
                }
              },
              child: Text('login'.tr.capitalizeFirst!),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15.0),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
              TextButton(onPressed: (){
                Get.offAll(SignUp());

              }, child: Text('No account ? Sign up',style: appBarStyle.copyWith(
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
