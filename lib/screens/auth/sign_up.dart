import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../constants/custom_widgets/FormFieldDecorator.dart';
import '../../controllers/admin/teachers_controller.dart';
import '../../controllers/auth/login_controller.dart';
import 'login.dart';

class SignUp extends StatelessWidget {
  final TeachersController teachersController = Get.put(TeachersController());
  final FireAuth auth = Get.put(FireAuth());
  final GetStorage box = GetStorage();

  final TextEditingController secretKey = TextEditingController();
  final RxBool isVisible = false.obs;

  SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff012931),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.person_add_alt_1_rounded,
                  color: Colors.white, size: 80),
              const SizedBox(height: 16),
              const Text(
                'Create Teacher Account',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Name
              TextFormField(
                controller: teachersController.TeacherName,
                textInputAction: TextInputAction.next,
                style: const TextStyle(color: Colors.white),
                decoration: buildInputDecoratione('Full Name').copyWith(
                  prefixIcon: const Icon(Icons.person_outline,
                      color: Colors.black),
                ),
              ),
              const SizedBox(height: 16),

              // Username
              TextFormField(
                controller: teachersController.TeacherSurname,
                textInputAction: TextInputAction.next,
                style: const TextStyle(color: Colors.white),
                decoration: buildInputDecoratione('Login').copyWith(
                  prefixIcon:
                  const Icon(Icons.account_circle, color: Colors.black),
                ),
              ),
              const SizedBox(height: 16),

              // Password
              Obx(() => TextFormField(
                controller: secretKey,
                obscureText: !isVisible.value,
                style: const TextStyle(color: Colors.white),
                decoration: buildInputDecoratione('Password').copyWith(
                  prefixIcon: const Icon(Icons.lock_outline,
                      color: Colors.black),
                  suffixIcon: IconButton(
                    onPressed: () =>
                    isVisible.value = !isVisible.value,
                    icon: Icon(
                      isVisible.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.white70,
                    ),
                  ),
                ),
              )),
              const SizedBox(height: 32),

              // Sign Up Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  if (teachersController.TeacherName.text.isEmpty ||
                      teachersController.TeacherSurname.text.isEmpty ||
                      secretKey.text.isEmpty) {
                    Get.snackbar(
                      'Error',
                      'All fields should be filled',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      icon: const Icon(Icons.block, color: Colors.white),
                      snackPosition: SnackPosition.TOP,
                      duration: const Duration(seconds: 3),
                    );
                    return;
                  }

                  teachersController.signUpAsTeacher(secretKey.text);
                  Get.offAll(() => Login());
                  Get.snackbar(
                    'Success',
                    'Your account has been created successfully.',
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                    icon:
                    const Icon(Icons.check_circle_rounded, color: Colors.white),
                    snackPosition: SnackPosition.TOP,
                    duration: const Duration(seconds: 3),
                  );
                },
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const SizedBox(height: 24),

              // Login Redirect
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? ",
                      style: TextStyle(color: Colors.white70, fontSize: 14)),
                  TextButton(
                    onPressed: () => Get.offAll(() => Login()),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.orangeAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
