import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userData = "Yam";
  bool isMenuVisible = false; // ใช้ในการควบคุมการแสดงผลเมนู

  // ฟังก์ชันสำหรับการดึงข้อมูลจาก API
  Future<void> fetchUserData() async {
    final response = await http.get(
        Uri.parse('http://localhost:3000/api/user')); // API URL ของ Node.js

    if (response.statusCode == 200) {
      // หากการร้องขอสำเร็จ ให้แปลงข้อมูล JSON
      setState(() {
        userData = json
            .decode(response.body)['name']; // สมมติว่าคุณต้องการแสดงชื่อ user
      });
    } else {
      // หากมีข้อผิดพลาดในการร้องขอ
      setState(() {
        userData = 'Failed to fetch user data';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData(); // ดึงข้อมูลเมื่อเริ่มแอป
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          // รูปภาพด้านซ้ายบน
          Positioned(
            top: 20,
            left: 20,
            child: Image.network(
              'assets/people.jpg', // URL ของรูปภาพ
              width: 100,
              height: 100,
            ),
          ),
          // ปุ่มแผนที่ด้านขวาบน
          Positioned(
            top: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                // ฟังก์ชันแสดงแผนที่
              },
              child: Image.network(
                'assets/map.png', // URL ของรูปภาพ
                width: 50,
                height: 50,
              ),
            ),
          ),
          // ข้อความ hello และชื่อผู้ใช้จาก MongoDB พร้อมรูปรถตรงกลาง
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Hello $userData', // แสดงข้อมูลของ user จาก API
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 20),
                Image.network(
                  'https://example.com/car_image.png', // URL รูปรถ
                  width: 200,
                  height: 150,
                ),
              ],
            ),
          ),
          // ปุ่ม start to add your car ตรงกลางล่าง
          Positioned(
            bottom: 80,
            left: MediaQuery.of(context).size.width / 2 - 100,
            child: ElevatedButton(
              onPressed: () {
                // ฟังก์ชันเพิ่มรถ
              },
              child: const Text('Start to add your car'),
            ),
          ),
        ],
      ),
      // ปุ่ม + ด้านขวาล่าง ซึ่งจะเปิดเมนู setting ขึ้นมา
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isMenuVisible)
            FloatingActionButton(
              heroTag: "settings",
              onPressed: () {
                // ฟังก์ชันสำหรับ Settings
              },
              child: const Icon(Icons.settings),
            ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "add",
            onPressed: () {
              setState(() {
                isMenuVisible = !isMenuVisible; // สลับการแสดงเมนู
              });
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
