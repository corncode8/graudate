import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grad_gg/screen/search_page/Widget/loading_indicator.dart';
import 'package:grad_gg/screen/search_page/select_department_screen.dart';

class SelectCollegeScreen extends StatefulWidget {
  final String schoolId;
  const SelectCollegeScreen(this.schoolId, {super.key});

  @override
  State<SelectCollegeScreen> createState() => _SelectCollegeScreenState();
}

class _SelectCollegeScreenState extends State<SelectCollegeScreen> {
  final db = FirebaseFirestore.instance;
  static List<String> dbCollegeList = [];
  late List<String> displayList = [];
  late String lastRoute;
  // bool isLiked = false;
  // List favorite = [];

  collectCollegeList() async {
    dbCollegeList = [];
    final collRef =
        await db.collection("대학").doc(widget.schoolId).collection('단과대학').get();
    for (var doc in collRef.docs) {
      dbCollegeList.add(doc.id);
    }
    setState(() {
      displayList = List.from(dbCollegeList.toSet().toList());
      lastRoute = '대학/${widget.schoolId}/단과대학/';
    });
  }

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

  // toggleFavorite(String value) async {
  //   setState(() {
  //     if (favorite.contains(value)) {
  //       favorite.remove(value);
  //     } else {
  //       favorite.add(value);
  //     }
  //   });
  //   late String docid;
  //   String userUid = getUserUid();
  //   // final query =
  //   //     await db.collection("학생").where("uuid", isEqualTo: userUid).get();
  //   // docid = query.docs.first.id;
  //   await db.collection("학생").doc(userUid).update({
  //     "favorite": favorite.toSet().toList(),
  //   });
  // }

  // initFavorite() async {
  //   late String docid;
  //   String userUid = getUserUid();
  //   // final query =
  //   //     await db.collection("학생").where("uuid", isEqualTo: userUid).get();
  //   // docid = query.docs.first.id;
  //   final data = await db.collection("학생").doc(userUid).get();
  //   try {
  //     if (data['favorite'].data() != null) {
  //       setState(() {
  //         favorite = data['favorite'];
  //       });
  //     }
  //   } catch (e) {
  //     await db.collection("학생").doc(userUid).update(
  //       {
  //         "favorite": [],
  //       },
  //     );
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    //initFavorite();
    collectCollegeList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("단과대학 선택"),
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         collectCollegeList();
        //       },
        //       icon: const Icon(Icons.tab))
        // ],
      ),
      body: displayList.isEmpty
          ? const LoadingIndicator()
          : ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  // color: Colors.amber,
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectDepartmentScreen(
                            displayList[index],
                            lastRoute,
                          ),
                        ),
                      );
                    },
                    //trailing: const Icon(Icons.hub_outlined),
                    title: Text(
                      displayList[index],
                    ),
                    leading: const Icon(
                      Icons.circle,
                      size: 15,
                    ),
                  ),
                );
              },
              itemCount: displayList.length,
            ),
    );
  }
}
