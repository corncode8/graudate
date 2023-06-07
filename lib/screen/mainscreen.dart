import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:grad_gg/screen/Provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  File? _image;
  final user = FirebaseAuth.instance.currentUser;
  late SharedPreferences prefs;
  String userName='';
  String userSchool='';
  String userdoc='';
  double _gpa = 0.0;
  int _credits = 0;
  int tnum = 0;
 /* Future<void> getStudentData() async {
    FirebaseFirestore.instance.collection("학생").get().then(
          (QuerySnapshot querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          if (docSnapshot['email'] == user!.email) {

              userdoc = docSnapshot.id;
              userName = docSnapshot['name'];
              userSchool = docSnapshot['school'];
              break;
          }
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
  }*/

  getUserUid() {
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        print("uid: ${FirebaseAuth.instance.currentUser?.uid}");
        return (FirebaseAuth.instance.currentUser?.uid)!;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print("user not found in");
        return e.code.toString();
      }
    }
  }


  Stream<QuerySnapshot> getStudentData() {
    print("call getStudentData");
    return FirebaseFirestore.instance.collection("학생").snapshots();
  }

/*
  Future<void> getStudentData() async{
    await FirebaseFirestore.instance.collection("학생").snapshots().listen(
          (QuerySnapshot querySnapshot) {
        print("Data refreshed");
         for (var docSnapshot in querySnapshot.docs) {
          if (docSnapshot['uuid'] == getUserUid()) {
             userdoc = docSnapshot.id;
             userName = docSnapshot['name'];
             userSchool = docSnapshot['school'];
           }
         }
      },
      onError: (e) => print("Error: $e"),
    );
  }

 */


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


  @override
  void initState() {
    super.initState();
    initializeDateFormatting().then((_) => setState((){}));
    _loadData();
    getStudentData();
    initPrefs();
  }


  Future<void> _saveData() async { //gpa credits 임시 변수생성
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('gpa', _gpa);
    await prefs.setInt('credits', _credits);
  }




  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _gpa = prefs.getDouble('gpa') ?? 0.0;
      _credits = prefs.getInt('credits') ?? 0;
      String? imagePath = prefs.getString('imagePath');
      if (imagePath != null) {
        _image = File(imagePath);
      }
    });
  }

  Future _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return ;
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(

            children: <Widget>[
              Container( //stack만 쓰면 높이 제한이 사라져 오류 발생 컨테이너로 묶어서 높이 200으로 지정
                height:800,
                child: Stack(
                    children: [
                      Positioned(
                          top: 70,
                          left: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, //왼쪽정렬
                            children: [
                              Text('졸업.gg',
                                style: TextStyle( //글자 스타일
                                  color: Colors.black, //글자 색 설정
                                  letterSpacing: 2.0, //글자 자간설정
                                  fontSize: 60.0, //폰트크기설정
                                  fontWeight: FontWeight.w600, //두께설정
                                ),
                              ),
                              StreamBuilder<QuerySnapshot>(
                                stream: getStudentData(),
                                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  }

                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                      return CircularProgressIndicator();
                                    default:
                                      var userName, userSchool;
                                      for (var docSnapshot in snapshot.data!.docs) {
                                        if (docSnapshot['uuid'] == getUserUid()) {
                                          userdoc = docSnapshot.id;
                                          userName = docSnapshot['name'];
                                          userSchool = docSnapshot['school'];
                                          print("정상적으로 uuid구분함.");
                                          break;
                                        }
                                      }
                                      print("username: $userName, userSchool: $userSchool");
                                      return Text("$userSchool",
                                        style: TextStyle( //글자 스타일
                                          color: Colors.black, //글자 색 설정
                                          letterSpacing: 2.0, //글자 자간설정
                                          fontSize: 30.0, //폰트크기설정
                                          fontWeight: FontWeight.w700, //두께설정
                                        ),);
                                  }
                                },
                              ),

                              /*FutureBuilder( //userSchool 대기
                                future: getStudentData(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.done) {
                                    print("userschoolinfo: $userSchool");

                                    return Text(userSchool,
                                      style: TextStyle( //글자 스타일
                                        color: Colors.black, //글자 색 설정
                                        letterSpacing: 2.0, //글자 자간설정
                                        fontSize: 30.0, //폰트크기설정
                                        fontWeight: FontWeight.w700, //두께설정
                                      ),);
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                },
                              ),

                               */


                              SizedBox(
                                height: 25.0,
                              ),
                              Text(' MY SPACE',
                                style: TextStyle( //글자 스타일
                                  color: Colors.black, //글자 색 설정
                                  fontSize: 30.0, //폰트크기설정
                                  fontWeight: FontWeight.w400, //두께설정
                                ),
                              ),
                              SizedBox(
                                height: 3.0,
                              ),

                              Row(
                              children: [
                              Container( //USER_NAME DEPARTMENTS
                                width: 170,
                                height: 180,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _showBottomSheet();
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white38),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(height:10),
                                      ClipOval(
                                        child: CircleAvatar(
                                          backgroundImage: _image != null ? FileImage(_image!) : null,
                                          radius: 50,
                                          backgroundColor: Colors.grey, // 이것은 _image가 null일 때 적용됩니다.
                                        ),
                                      ),
                                      SizedBox(height:15),

                                      StreamBuilder<QuerySnapshot>(
                                        stream: getStudentData(),
                                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                          if (snapshot.hasError) {
                                            return Text('Error: ${snapshot.error}');
                                          }

                                          switch (snapshot.connectionState) {
                                            case ConnectionState.waiting:
                                              return CircularProgressIndicator();
                                            default:
                                              var userName, userSchool;
                                              for (var docSnapshot in snapshot.data!.docs) {
                                                if (docSnapshot['uuid'] == getUserUid()) {
                                                  userdoc = docSnapshot.id;
                                                  userName = docSnapshot['name'];
                                                  userSchool = docSnapshot['school'];
                                                  break;
                                                }
                                              }
                                              print("username: $userName, userSchool: $userSchool");
                                              return Text("$userName \n $userSchool",
                                                style: TextStyle( //글자 스타일
                                                  color: Colors.black, //글자 색 설정
                                                  fontSize: 20.0, //폰트크기설정
                                                  fontWeight: FontWeight.w700, //두께설정
                                                ),);
                                          }
                                        },
                                      )

                                      /*
                                      FutureBuilder( //userName 대기
                                        future: getStudentData(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.done) {
                                            return Text(userName,
                                              style: TextStyle( //글자 스타일
                                                color: Colors.black, //글자 색 설정
                                                fontSize: 20.0, //폰트크기설정
                                                fontWeight: FontWeight.w700, //두께설정
                                              ),
                                            );
                                          } else {
                                            return CircularProgressIndicator();
                                          }
                                        },
                                      ),
                                      FutureBuilder( //userSchool 대기
                                        future: getStudentData(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.done) {
                                            return Text(userSchool,
                                              style: TextStyle( //글자 스타일
                                                color: Colors.black, //글자 색 설정
                                                fontSize: 20.0, //폰트크기설정
                                                fontWeight: FontWeight.w700, //두께설정
                                              ),
                                            );
                                          } else {
                                            return CircularProgressIndicator();
                                          }
                                        },
                                      ),
                                      */
                                    ],
                                  ),
                                ),

                              ),

                                SizedBox(width: 20), // 가로 방향으로 간격 추가

                                Container(
                                  width: 180,
                                  height: 170,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start, // 오른쪽 열을 왼쪽 정렬로 만듭니다.
                                  children: [
                                    Text(
                                      DateFormat('yyyy년', 'ko_KR').format(DateTime.now()), // 현재 시간 표시
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),Text(
                                      DateFormat('MM월', 'ko_KR').format(DateTime.now()), // 현재 시간 표시
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),

                                    Align(
                                      alignment: Alignment.bottomRight,
                                    child: Text(
                                      DateFormat('d일', 'ko_KR').format(DateTime.now()), // 현재 일, 요일 표시
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 29.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                        DateFormat('EEEE', 'ko_KR').format(DateTime.now()), // 현재 일, 요일 표시
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 29.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                              ),
                              ],
                              ),



                              SizedBox(height:50),


                              Text(' MY STATUS',
                                style: TextStyle( //글자 스타일
                                  color: Colors.black, //글자 색 설정
                                  fontSize: 30.0, //폰트크기설정
                                  fontWeight: FontWeight.w400, //두께설정
                                ),
                              ),

                              SizedBox(height:5),

                              Container(
                                width: 375,
                                height: 170,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey[200],
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    var provider = Provider.of<NavigationIndexProvider>(context, listen: false);
                                    provider.setIndex(1);
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white38),
                                  ),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 25, bottom: 5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(width: 20),
                                              Text("전체평점",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 17.0,
                                                  fontWeight: FontWeight.w700,),
                                              ),
                                              SizedBox(width: 40),
                                              Text("이수학점     ",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 17.0,
                                                  fontWeight: FontWeight.w700,),),
                                              SizedBox(width: 20),
                                            ],
                                          ),
                                        ),
                                      ),
                                      VerticalDivider(width: 1),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 0, bottom: 50),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(width: 40),
                                              Text("4.2 /4.5",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 26.0,
                                                  fontWeight: FontWeight.w700,),
                                              ),
                                              SizedBox(width: 50),
                                              Text(" 65 /130    ",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 26.0,
                                                  fontWeight: FontWeight.w700,),),
                                              SizedBox(width: 20),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  //onPressed: () {},
                                ),
                              ),

                              SizedBox(height: 15),
                            ],
                          )
                      ),
                    ]
                ),
              ),
            ]
        ),
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
