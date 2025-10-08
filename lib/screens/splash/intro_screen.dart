import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../auth/login.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> pages = [
    {
      'title': 'Manage Budget',
      'desc': 'Easily calculate and control your monthly education budget.',
      'image': 'https://cdn-icons-png.flaticon.com/512/3135/3135706.png',
    },
    {
      'title': 'Track Students',
      'desc': 'View total students and manage their profiles effortlessly.',
      'image': 'https://cdn-icons-png.flaticon.com/512/4140/4140048.png',
    },
    {
      'title': 'Check Attendance',
      'desc': 'Monitor daily attendance and keep accurate records instantly.',
      'image': 'https://cdn-icons-png.flaticon.com/512/4228/4228927.png',
    },
  ];


  GetStorage box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff012931),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (index) => setState(() => currentIndex = index),
                itemBuilder: (context, index) {
                  final page = pages[index];
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(page['image']!, height: 220),
                        const SizedBox(height: 40),
                        Text(
                          page['title']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          page['desc']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Dots + Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      pages.length,
                          (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: currentIndex == index ? 16 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: currentIndex == index
                              ? Colors.orangeAccent
                              : Colors.white54,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      if (currentIndex == pages.length - 1) {
                        Get.offAll(() => Login());
                        box.write('isIntroduced', true);

                      } else {
                        _pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: Text(
                      currentIndex == pages.length - 1 ? "Get Started" : "Next",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
