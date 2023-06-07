import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grad_gg/screen/Widget/input_info_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  final _emailTextController = TextEditingController();
  final _schoolTextController = TextEditingController();
  final _departmentTextController = TextEditingController();
  final _curYearTextController = TextEditingController();
  final _nameTextController = TextEditingController();


  getUserUid() {
    try {
      if (FirebaseAuth.instance.currentUser != null) {
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
    return FirebaseFirestore.instance.collection("학생").snapshots();
  }

  UpdateUserInfo() async {
    String userUid = getUserUid();
    final data = await db.collection("학생").doc(userUid).get();
    try {
      //FirebaseAuth.instance.currentUser?.updateEmail(_emailTextController.text);
      await db.collection("학생").doc(userUid).update(
        {
          //"email": _emailTextController.text,
          "name": _nameTextController.text,
          "school": _schoolTextController.text,
          "department": _departmentTextController.text,
          "curriculumyear": _curYearTextController.text
        },
      );
    } catch (e) {
      print("Erorr Occurred $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          child: Column(
            children: [
              const SizedBox(
                height: 80,
              ),


              Row(
                children: const [
                  Text(
                    '졸업.GG',
                    style: TextStyle(
                      fontSize: 55,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],

              ),

              const SizedBox(
                height: 70,
              ),

              Center(
                child: Column(
                  children: [

                    InputInfoTextField(true, _emailTextController, user!.email,
                        Icons.email, TextInputType.emailAddress),
                    const SizedBox(
                      height: 20,
                    ),
                    InputInfoTextField(false, _nameTextController, "이름",
                        Icons.account_circle, TextInputType.name),
                    const SizedBox(
                      height: 20,
                    ),
                    InputInfoTextField(false, _schoolTextController, "소속학교",
                        Icons.school, TextInputType.name),
                    const SizedBox(
                      height: 20,
                    ),
                    InputInfoTextField(false, _departmentTextController, "소속학과",
                        Icons.book, TextInputType.name)
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InputInfoTextField(false, _curYearTextController, "이수학년",
                  Icons.featured_play_list, TextInputType.name),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  UpdateUserInfo();
                },
                child: const Text("프로필 수정"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  shadowColor: Colors.white38,
                  elevation: 0,
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w300,
                  )

                ),
              ),

              const SizedBox(
                height: 20,
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
                  )),

            ],
          ),
        ),
      ),
    );
  }
}
