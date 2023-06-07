import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grad_gg/screen/search_page/select_term_screen.dart';

class SelectYearScreen extends StatefulWidget {
  final String departmentid;
  final String inputRoute;
  const SelectYearScreen(this.departmentid, this.inputRoute, {super.key});

  @override
  State<SelectYearScreen> createState() => _SelectYearScreenState();
}

class _SelectYearScreenState extends State<SelectYearScreen> {
  final db = FirebaseFirestore.instance;
  static List<String> dbSubjectList = [];
  late List<String> displayList = [];
  late String lastRoute;

  collectYearList() async {
    print("여기는 년도 선택 페이지");
    lastRoute = "${widget.inputRoute}/${widget.departmentid}/년도";

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
    collectYearList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("년도 선택"),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.tab))],
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
                          builder: (context) => SelectTermScreen(
                            displayList[index],
                            lastRoute,
                          ),
                        ),
                      );
                    },
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.circle,
                          size: 15,
                        ),
                      ],
                    ),
                    //trailing: const Icon(Icons.hub_outlined),
                    title: Text(
                      displayList[index],
                    ),
                    // leading: const Icon(Icons.star, color: Colors.black),
                    // subtitle: const Text("subtitle"),
                  ),
                );
              },
              itemCount: displayList.length,
            ),
    );
  }
}
