import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grad_gg/screen/select_subject_screen.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    collectCollegeList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TestPage"),
        actions: [
          IconButton(
              onPressed: () {
                collectCollegeList();
              },
              icon: const Icon(Icons.tab))
        ],
      ),
      body: displayList.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  color: Colors.amber,
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectSubjectScreen(
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
                    leading: IconButton(
                      icon: const Icon(Icons.favorite_border_outlined),
                      onPressed: () {
                        print("isPushed");
                      },
                    ),
                    subtitle: const Text("subtitle"),
                  ),
                );
              },
              itemCount: displayList.length,
            ),
    );
  }
}
