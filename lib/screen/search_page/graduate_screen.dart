import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const GraduatingScreen());
}

class GraduatingScreen extends StatefulWidget {
  const GraduatingScreen({super.key});

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<GraduatingScreen> {
  String? userUid;

  List<ValueNotifier<bool>> isChecked = [
    ValueNotifier<bool>(false),
    ValueNotifier<bool>(false),
    ValueNotifier<bool>(false),
    ValueNotifier<bool>(false),
    ValueNotifier<bool>(false),
    ValueNotifier<bool>(false),
    ValueNotifier<bool>(false)
  ]; // check box -> list

  getUserUid() {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        return user.uid;
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting user UID: $e");
      return null;
    }
  }

  Future<void> loadCheckboxState() async {
    String userUid = getUserUid();
    QuerySnapshot userSnapshots = await FirebaseFirestore.instance
        .collection('학생')
        .where('uuid', isEqualTo: userUid)
        .get();

    if (userSnapshots.docs.isNotEmpty) {
      DocumentSnapshot userSnapshot = userSnapshots.docs.first;
      if (userSnapshot.exists) {
        try {
          Map<String, dynamic> userData =
              userSnapshot.data() as Map<String, dynamic>;

          if (userData.containsKey('checkboxValues') &&
              userData['checkboxValues'] is List) {
            List<dynamic> firebaseCheckboxValues =
                userData['checkboxValues'].cast<bool>();

            if (firebaseCheckboxValues.length == isChecked.length) {
              for (int i = 0; i < isChecked.length; i++) {
                isChecked[i].value = firebaseCheckboxValues[i];
              }
            }
          }
        } catch (e) {
          print('Error loading checkbox values: $e');
        }
      }
    }
  }

  void saveCheckboxState() async {
    String userUid = getUserUid();
    QuerySnapshot userSnapshots = await FirebaseFirestore.instance
        .collection('학생')
        .where('uuid', isEqualTo: userUid)
        .get();

    for (var docSanpshot in userSnapshots.docs) {
      await docSanpshot.reference.update(
        {'checkboxValues': isChecked.map((box) => box.value).toList()},
      );
    }
  }

  @override
  void initState() {
    super.initState();
    loadCheckboxState();
  }

  @override
  void dispose() {
    for (int i = 0; i < isChecked.length; i++) {
      isChecked[i].dispose();
    }
    saveCheckboxState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'grad page',
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
          ),
          child: Scrollbar(
            thickness: 2, // 스크롤바 size
            child: ListView(
              children: [
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  'Grad.gg',
                  style: TextStyle(
                    fontSize: 55,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const Text(
                  '경상국립대학교',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                const Text(
                  'GRADUATING',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        '필수요소',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                // 체크박스 영어인증제 패딩 시작
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '🔅 영어인증제',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: 25,
                            height: 24,
                            child: ValueListenableBuilder(
                              valueListenable: isChecked[0],
                              builder: (context, value, child) {
                                return Checkbox(
                                  value: isChecked[0].value,
                                  onChanged: (bool? newValue) {
                                    setState(() {
                                      isChecked[0].value = newValue ?? false;
                                    });
                                    saveCheckboxState();
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 35,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            SizedBox(height: 15),
                            Text(
                              '영어 교과목 이수\n'
                              'English-Zone 영어 프로그램 이수\n'
                              '외부시험(공인어학시험) 성적 중 1개',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      // 여기에 SizedBox를 추가하여 영어인증제 단어를 2칸 밑으로 내립니다.
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '🔅 상담인증제',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: ValueListenableBuilder(
                              valueListenable: isChecked[1],
                              builder: (context, value, child) {
                                return Checkbox(
                                  value: isChecked[1].value,
                                  onChanged: (bool? newValue) {
                                    setState(() {
                                      isChecked[1].value = newValue ?? false;
                                    });
                                    saveCheckboxState();
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 35,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              '꿈, 미래 개척 상담지도 과목 이수',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Text CheckBox
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SizedBox(
                        height: 28,
                      ),
                      Text(
                        '선택요소 (택 1)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      // 여기에 SizedBox를 추가하여 영어인증제 단어를 2칸 밑으로 내립니다.
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '▪  사회봉사',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: ValueListenableBuilder(
                              valueListenable: isChecked[2],
                              builder: (context, value, child) {
                                return Checkbox(
                                  value: isChecked[2].value,
                                  onChanged: (bool? newValue) {
                                    setState(() {
                                      isChecked[2].value = newValue ?? false;
                                    });
                                    saveCheckboxState();
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '▪  GNU인성',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: ValueListenableBuilder(
                              valueListenable: isChecked[3],
                              builder: (context, value, child) {
                                return Checkbox(
                                  value: isChecked[3].value,
                                  onChanged: (bool? newValue) {
                                    setState(() {
                                      isChecked[3].value = newValue ?? false;
                                    });
                                    saveCheckboxState();
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '▪  글로벌리더쉽프로그램 참가',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: ValueListenableBuilder(
                              valueListenable: isChecked[4],
                              builder: (context, value, child) {
                                return Checkbox(
                                  value: isChecked[4].value,
                                  onChanged: (bool? newValue) {
                                    setState(() {
                                      isChecked[4].value = newValue ?? false;
                                    });
                                    saveCheckboxState();
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '▪  독서인증 및 평가',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: ValueListenableBuilder(
                              valueListenable: isChecked[5],
                              builder: (context, value, child) {
                                return Checkbox(
                                  value: isChecked[5].value,
                                  onChanged: (bool? newValue) {
                                    setState(() {
                                      isChecked[5].value = newValue ?? false;
                                    });
                                    saveCheckboxState();
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '▪  진로탐색',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: ValueListenableBuilder(
                              valueListenable: isChecked[6],
                              builder: (context, value, child) {
                                return Checkbox(
                                  value: isChecked[6].value,
                                  onChanged: (bool? newValue) {
                                    setState(() {
                                      isChecked[6].value = newValue ?? false;
                                    });
                                    saveCheckboxState();
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // 체크박스 영어인증제 Padding 끝
      ),
    );
  }
}
