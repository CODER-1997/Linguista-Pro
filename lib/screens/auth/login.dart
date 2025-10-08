import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../controllers/auth/login_controller.dart';
import '../admin/admin_home_screen.dart';
import 'sign_up.dart';

class Login extends StatelessWidget {
  final FireAuth auth = Get.put(FireAuth());
  final GetStorage box = GetStorage();

  final RxBool isVisible = false.obs;

  Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff012931),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.lock_outline_rounded,
                  color: Colors.white, size: 80),
              const SizedBox(height: 16),
              const Text(
                'Welcome Back',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Login field
              TextFormField(
                controller: auth.teacherId,
                style: const TextStyle(color: Colors.white),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Login',
                  labelStyle:
                  const TextStyle(color: Colors.white70, fontSize: 15),
                  prefixIcon:
                  const Icon(Icons.person_outline, color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white54),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                    const BorderSide(color: Colors.orangeAccent, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Password field
              Obx(() => TextFormField(
                controller: auth.teacherPassword,
                obscureText: !isVisible.value,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle:
                  const TextStyle(color: Colors.white70, fontSize: 15),
                  prefixIcon:
                  const Icon(Icons.lock_outline, color: Colors.white70),
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
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white54),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: Colors.orangeAccent, width: 2),
                  ),
                ),
              )),
              const SizedBox(height: 32),

              // Login button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  final id = auth.teacherId.text.trim();
                  final pass = auth.teacherPassword.text.trim();

                  if (id.isEmpty || pass.isEmpty) {
                    Get.snackbar(
                      'Error',
                      'All fields must be filled.',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      icon: const Icon(Icons.error, color: Colors.white),
                      snackPosition: SnackPosition.TOP,
                      duration: const Duration(seconds: 3),
                    );
                    return;
                  }

                  if (id == 'Linguista9' && pass == '6463070') {
                    box.write('isLogged', id);
                    Get.offAll(() => AdminHomeScreen());
                  } else if (id == 'test' && pass == '123') {
                    box.write('isLogged', 'testuser');
                    Get.offAll(() => AdminHomeScreen());
                  } else {
                    auth.signIn(pass);
                  }
                },
                child: const Text(
                  'Login',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const SizedBox(height: 24),

              // Sign up redirect
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? ",
                      style: TextStyle(color: Colors.white70, fontSize: 14)),
                  TextButton(
                    onPressed: () => Get.offAll(() => SignUp()),
                    child: const Text(
                      "Sign Up",
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
