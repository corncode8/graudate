import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grad_gg/screen/search_page/Widget/loading_indicator.dart';
import 'package:grad_gg/screen/search_page/select_year_screen.dart';

class SelectDepartmentScreen extends StatefulWidget {
  final String collegeid;
  final String inputRoute;
  const SelectDepartmentScreen(this.collegeid, this.inputRoute, {super.key});

  @override
  State<SelectDepartmentScreen> createState() => _SelectDepartmentScreenState();
}

class _SelectDepartmentScreenState extends State<SelectDepartmentScreen> {
  final db = FirebaseFirestore.instance;
  static List<String> dbSubjectList = [];
  late List<String> displayList = [];
  late String lastRoute;

  collectDepartmentList() async {
    print("여기는 과 선택 페이지");
    lastRoute = "${widget.inputRoute}${widget.collegeid}/학과";
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
    collectDepartmentList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("학과 선택"),
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         collectDepartmentList();
        //       },
        //       icon: const Icon(Icons.tab))
        // ],
      ),
      body: displayList.isEmpty
          ? const LoadingIndicator()
          : ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectYearScreen(
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
                    subtitle: const Text("subtitle"),
                  ),
                );
              },
              itemCount: displayList.length,
            ),
    );
  }
}
