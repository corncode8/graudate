import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grad_gg/screen/search_page/select_subject_screen.dart';

class SelectTermScreen extends StatefulWidget {
  final String subjectid;
  final String inputRoute;
  const SelectTermScreen(this.subjectid, this.inputRoute, {super.key});

  @override
  State<SelectTermScreen> createState() => _SelectTermScreenState();
}

class _SelectTermScreenState extends State<SelectTermScreen> {
  final db = FirebaseFirestore.instance;
  static List<String> dbSubjectList = [];
  late List<String> displayList = [];
  late String lastRoute;

  collectTermList() async {
    print("여기는 학기 선택 페이지");
    lastRoute = "${widget.inputRoute}/${widget.subjectid}/학기";
    print(lastRoute);

    dbSubjectList = [];
    final collRef = await db.collection(lastRoute).get();
    for (var doc in collRef.docs) {
      dbSubjectList.add(doc.id);
    }
    setState(() {
      displayList = List.from(dbSubjectList.toSet().toList());
      lastRoute = lastRoute;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    collectTermList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("학기 선택"),
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         collectTermList();
        //       },
        //       icon: const Icon(Icons.tab))
        // ],
      ),
      body: displayList.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Container(
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
