import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:grad_gg/screen/editprofile_screen.dart';
import 'package:grad_gg/screen/search_page/search_page.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MySpaceScreen());

class MySpaceScreen extends StatefulWidget {
  const MySpaceScreen({super.key});

  @override
  State<MySpaceScreen> createState() => _MySpaceScreenState();
}

class _MySpaceScreenState extends State<MySpaceScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'grad.gg',
      theme: ThemeData(primarySwatch: Colors.blue //기본 바탕 색 지정
          ),
      home: const MyCard(),
    );
  }
}

class MyCard extends StatefulWidget {
  const MyCard({super.key});

  @override
  State<MyCard> createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  File? _image;
  final user = FirebaseAuth.instance.currentUser;
  late SharedPreferences prefs;

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final imageFile = prefs.getString('imagePath');
    if (imageFile != null) {
      setState(() {
        _image = File(imageFile);
      });
    } else {
      await prefs.setString('imagePath', "");
    }
  }

  Future _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      String? imageFile = prefs.getString('imagePath');
      File? img = File(image.path);
      setState(() {
        _image = img;
        imageFile = image.path;
        Navigator.of(context).pop();
      });
      //prefs에 선택한 이미지 파일 경로저장
      await prefs.setString('imagePath', imageFile!);
    } on PlatformException catch (e) {
      print(e);
      Navigator.of(context).pop();
    }
  }

  removeImage() {
    setState(() {
      _image = null;
      Navigator.of(context).pop();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
            30.0, 75.0, 20.0, 0.0), //패딩값 설정 double타입 left top right bottom
        //  child: Center( //column 왼쪽 전구모양 -> center 중앙배치
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          //mainAxisAlignment: MainAxisAlignment.center, //상하 중간값
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Grad.GG',
                  style: TextStyle(
                    //글자 스타일
                    color: Colors.black, //글자 색 설정
                    letterSpacing: 2.0, //글자 자간설정
                    fontSize: 60.0, //폰트크기설정
                    fontWeight: FontWeight.w900, //두께설정
                  ),
                ),
                const SizedBox(
                  width: 50,
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        FirebaseAuth.instance.signOut();
                        print("로그아웃후 $user");
                      });
                      //Navigator.pushReplacementNamed(context, '/loginPage');
                    },
                    icon: const Icon(
                      Icons.logout_outlined,
                    ))
              ],
            ),
            const Text(
              '경상국립대학교',
              style: TextStyle(
                //글자 스타일
                color: Colors.black, //글자 색 설정
                fontSize: 30.0, //폰트크기설정
                fontWeight: FontWeight.w500, //두께설정
              ),
            ),
            const SizedBox(
              height: 50.0,
            ),
            const Text(
              'MY SPACE',
              style: TextStyle(
                fontSize: 30.0, //폰트크기설정
                fontWeight: FontWeight.bold, //두께설정
              ),
            ),
            const SizedBox(
              height: 20.0, //여백추가
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfileScreen(),
                      ),
                    )
                  },
                  child: Container(
                    //MYSPACE
                    alignment: Alignment.lerp(Alignment.center,
                        Alignment.bottomCenter, 0.5), // 가로 가운데, 세로 아래 정렬
                    width: MediaQuery.of(context).size.width *
                        0.4, // 화면 가로 길이의 0.4배
                    height: MediaQuery.of(context).size.width *
                        0.4, // 화면 세로 길이의 0.4배
                    padding: const EdgeInsets.only(bottom: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(0),
                    ),
                    // 네모박스 내부에 들어갈 내용
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                            onTap: () {
                              _showBottomSheet();
                            },
                            child: _image == null
                                ? const Icon(
                                    Icons.account_circle,
                                    size: 100,
                                  )
                                : CircleAvatar(
                                    backgroundImage: FileImage(_image!),
                                    radius: 50,
                                  )),
                        const Text(
                          'USER_NAME',
                          style: TextStyle(
                            fontSize: 17.0, //폰트크기설정
                            fontWeight: FontWeight.w800, //두께설정
                          ),
                        ),
                        const Text(
                          'DEPARTMENTS',
                          style: TextStyle(
                            fontSize: 17.0, //폰트크기설정
                            fontWeight: FontWeight.w800, //두께설정
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0, //여백추가
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => const SearchScreen()),
                  ),
                );
              },
              child: Container(
                //졸업요건화면
                alignment: Alignment.center, // 가로, 세로 가운데 정렬
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.width * 0.3,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(0),
                ),
                child: const Text(
                  '졸업요건 화면',
                  style: TextStyle(
                    fontSize: 15.0, //폰트크기설정
                    fontWeight: FontWeight.bold, //두께설정
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              //GPA NOW, CREDITS NOW
              children: [
                Container(
                  alignment: Alignment.lerp(Alignment.topLeft,
                      Alignment.topCenter, 0.5), //글자 가로 가운데, 세로 아래 정렬
                  width: MediaQuery.of(context).size.width *
                      0.4, // 화면 가로 길이의 0.35배
                  height: MediaQuery.of(context).size.width *
                      0.4, // 화면 세로 길이의 0.35배
                  decoration: const BoxDecoration(
                    //박스모양 및 색상설정
                    color: Colors.grey,
                  ),

                  child: Column(// 네모박스 내부에 들어갈 내용

                      children: const [
                    Text(
                      '\nGPA NOW',
                      //textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 17.0, //폰트크기설정
                        fontWeight: FontWeight.w600, //두께설정
                      ),
                    ),
                    Text(
                      '\n\n3.5/4.5',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17.0, //폰트크기설정
                        fontWeight: FontWeight.w600, //두께설정
                      ),
                    ),
                  ]),
                ),
                const SizedBox(width: 20),
                Container(
                  alignment: Alignment.lerp(Alignment.topLeft,
                      Alignment.topCenter, 0.5), //글자 가로 가운데, 세로 아래 정렬
                  width: MediaQuery.of(context).size.width *
                      0.4, // 화면 가로 길이의 0.35배
                  height: MediaQuery.of(context).size.width *
                      0.4, // 화면 세로 길이의 0.35배
                  decoration: BoxDecoration(
                    //박스모양 및 색상설정
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(0),
                  ),

                  child: Column(// 네모박스 내부에 들어갈 내용

                      children: const [
                    Text(
                      '\nCREDITS NOW',
                      //textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 17.0, //폰트크기설정
                        fontWeight: FontWeight.w600, //두께설정
                      ),
                    ),
                    Text(
                      '\n\n18/130',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17.0, //폰트크기설정
                        fontWeight: FontWeight.w600, //두께설정
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ],
        ),
        //),
      ),
    );
  }

  _showBottomSheet() {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                _pickImage(ImageSource.camera);
              },
              child: const Text('사진찍기'),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                _pickImage(ImageSource.gallery);
              },
              child: const Text('라이브러리에서 불러오기'),
            ),
            ElevatedButton(
              onPressed: () {
                removeImage();
              },
              child: const Text('사진 삭제'),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        );
      },
    );
  }
}
