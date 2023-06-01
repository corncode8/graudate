import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grad_gg/screen/search_page/select_college_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final db = FirebaseFirestore.instance;
  static List<String> dbSchoolList = [];
  late List<String> displayList = [];

  void collectSearchList() async {
    final collRef = db.collection("대학");
    final querySnapshot = await collRef.get();
    for (var doc in querySnapshot.docs) {
      dbSchoolList.add(doc.id);
    }
    setState(
      () {
        displayList = List.from(dbSchoolList.toSet().toList());
      },
    );
  }

  void updateList(String value) {
    setState(
      () {
        if (value.isEmpty) {
          displayList = dbSchoolList;
        } else {
          displayList = dbSchoolList
              .where(((element) =>
                  element.toLowerCase().contains(value.toLowerCase())))
              .toList();
        }
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    collectSearchList();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _searchController;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
          onPressed: () {
            // showSearch(
            //   context: context,
            //   delegate: CustomSearchDelegate(),
            // );
          },
          icon: const Icon(Icons.search),
        ),
      ]),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Grad.GG',
                    style: TextStyle(
                      //글자 스타일
                      color: Colors.black, //글자 색 설정
                      letterSpacing: 2.0, //글자 자간설정
                      fontSize: 70.0, //폰트크기설정
                      fontWeight: FontWeight.w700, //두께설정
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/myspacePage');
                      },
                      child: const Text("Myspace"),
                    ),
                  ),
                ],
              ),
            ),
            TextField(
              controller: _searchController,
              onChanged: (value) => updateList(value),
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                hintText: 'Search',
                labelStyle: const TextStyle(color: Colors.black),
                prefixIcon: const Icon(Icons.search),
                prefixIconColor: Colors.black,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: displayList.isEmpty
                  ? const Center(
                      child: Text(
                      "No Result",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ))
                  : ListView.builder(
                      itemCount: displayList.length,
                      itemBuilder: (context, index) => ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelectCollegeScreen(
                                displayList[index],
                              ),
                            ),
                          );
                        },
                        contentPadding: const EdgeInsets.all(8.0),
                        title: Text(
                          displayList[index],
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        // subtitle: Text(
                        //   displayList[index],
                        //   style: const TextStyle(color: Colors.black),
                        // ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// class CustomSearchDelegate extends SearchDelegate {
//   List<String> searchItem = ['Apple', 'banana', 'coloa'];

//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: const Icon(Icons.clear),
//         onPressed: () {
//           query = '';
//         },
//       )
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//         onPressed: () {
//           close(context, null);
//         },
//         icon: const Icon(Icons.arrow_back));
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     List<String> matchQuery = [];
//     for (var item in searchItem) {
//       if (item.toLowerCase().contains(query.toLowerCase())) {
//         matchQuery.add(item);
//       }
//     }
//     return ListView.builder(
//       itemCount: matchQuery.length,
//       itemBuilder: (context, index) {
//         var result = matchQuery[index];
//         return ListTile(
//           title: Text(result),
//         );
//       },
//     );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     List<String> matchQuery = [];
//     for (var item in searchItem) {
//       if (item.toLowerCase().contains(query.toLowerCase())) {
//         matchQuery.add(item);
//       }
//     }
//     return ListView.builder(
//       itemCount: matchQuery.length,
//       itemBuilder: (context, index) {
//         var result = matchQuery[index];
//         return ListTile(
//           title: Text(result),
//         );
//       },
//     );
//   }
// }
