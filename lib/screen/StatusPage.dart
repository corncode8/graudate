import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:grad_gg/screen/profile_screen.dart';
import 'fuck.dart';
import 'grades_update.dart';


class Season_Category extends StatefulWidget {

  const Season_Category({Key? key}) : super(key: key);

  @override
  State<Season_Category> createState() => _Season_CategoryState();
}
final gradesManager = GradesManager();
final ValueNotifier<String> selectedSeasonNotifier = ValueNotifier<String>("");

class _Season_CategoryState extends State<Season_Category> {

  int selectedCategory = 0;

  List<String> season = ["1학년 1학기", "1학년 2학기", "2학년 1학기", "2학년 2학기", "3학년 1학기",
    "3학년 2학기", "4학년 1학기", "4학년 2학기"];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: season.length,
          itemBuilder: (context, index) => buildCategory(index, context)),
    );
  }


  Padding buildCategory(int index, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: GestureDetector(
        onTap: (){
          setState(() {
            selectedCategory = index;
          });
          selectedSeasonNotifier.value = season[index];


        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
                season[index],
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: index == selectedCategory
                        ? Colors.black
                        : Colors.black.withOpacity(0.4),
                    fontSize: 12.0)
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              height: 6,
              width: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: index == selectedCategory
                      ? Colors.grey
                      : Colors.transparent),
            ),
          ],
        ),
      ),
    );
  }
}

class MyStatusPage extends StatefulWidget {
  MyStatusPage({Key? key}) : super(key: key);

  @override
  _MyStatusPageState createState() => _MyStatusPageState();
}

class _MyStatusPageState extends State<MyStatusPage> {


  List<String> currentSub = [];
  List<String> currentCredit = [];
  List<String> currentGrade = [];
  List<List<String>> subjectGrades = [[]];
  List<String> currentTotalGrade=[];
  List<String> currentTotalScore=[];
  double score=0.0;

  void someFunction(String str) async {
    List<List<String>> result = await printUserFavorite(str);

    if (result != null && result.length >= 5) {
      setState(() {
        currentSub = result[0];
        currentCredit = result[1];
        currentGrade = result[2];
        currentTotalGrade = result[3];
        currentTotalScore = result[4];
        print(currentGrade);

        //print("current: $currentGrade result: ${result[2]}");
      });
    }
  }




  double cal() {
    double total = 0.0;
    int count = 0;
    int fcount = 0;

    for (String grade in currentGrade) {
      switch (grade) {
        case 'A+':
          total += 4.5;
          break;
        case 'A0':
          total += 4.0;
          break;
        case 'B+':
          total += 3.5;
          break;
        case 'B0':
          total += 3.0;
          break;
        case 'C+':
          total += 2.5;
          break;
        case 'C0':
          total += 2.0;
          break;
        case 'D+':
          total += 1.5;
          break;
        case 'D0':
          total += 1.0;
          break;
        case 'F':
          fcount += 1;
          break;
        default:
          fcount+=1;
          break;
      }
      count++;
    }

    double average = total / (count-fcount);
    if((count-fcount)==0){
      return 0.0;
    }
    else {
      return double.parse(average.toStringAsFixed(1));
    }
  }
double calc(){
    double total = 0.0;
    int fcount=0;
    int count=0;
    for (String grade in currentTotalGrade) {

      switch (grade) {
        case 'A+':
          total += 4.5;
          break;
        case 'A0':
          total += 4.0;
          break;
        case 'B+':
          total += 3.5;
          break;
        case 'B0':
          total += 3.0;
          break;
        case 'C+':
          total += 2.5;
          break;
        case 'C0':
          total += 2.0;
          break;
        case 'D+':
          total += 1.5;
          break;
        case 'D0':
          total += 1.0;
          break;
        case 'F':
          fcount += 1;
          break;
        default:
          fcount+=1;
          break;
      }
      count++;
    }
  //currentTotalGrade
    double average = total / (count-fcount);
    if((count-fcount)==0){
      return 0.0;
    }
    else {
      return double.parse(average.toStringAsFixed(1));
    }
}
  int? cald(){
    int total = 0;

    for (String grade in currentTotalScore) {
      int? gradeAsInt = int.tryParse(grade);
      if (gradeAsInt == null) {
        continue;
      }
      else {
        total += int.parse(grade);
      }
    }
    return total;
  }

  int cale(){
    int total = 0;
    for (String grade in currentCredit) {
      int? gradeAsInt = int.tryParse(grade);
      if (gradeAsInt == null) {
        continue;
      }
      else {
        total += int.parse(grade);
      }
    }
    return total;
  }



  @override
  void initState() {
    super.initState();
    selectedSeasonNotifier.value = '1학년 1학기';
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 22.0, top : 30.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 54.0,
            ),
            TextButton(
              onPressed: () {
                print('졸업 시켜줘');
              },
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '졸업.GG\n',
                      style: TextStyle(
                          fontSize: 55.0, //폰트크기설정
                          fontWeight: FontWeight.w700, //두께설정
                          color: Colors.black),
                    ),
                    TextSpan(
                      text: '경상국립대학교',
                      style: TextStyle(fontSize: 25.0, color: Colors.black, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              '\n\nMY STATUS',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            Text('\n     ●  이수학점',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              '       ${cald()} / 130',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text('\n     ● 전체평점',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              '       ${calc()} / 4.5',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            SizedBox(
              height: 20
            ),

            Season_Category(),

            ValueListenableBuilder<String>(
              valueListenable: selectedSeasonNotifier,
              builder: (BuildContext context, String value, Widget? child) {

                String textValue = "";
                //List<String> usergrade = ['a', 'b'];


                Color color = Colors.white;

                if (value == '1학년 1학기') {
                  color = Colors.white;
                  textValue = '이수학점 : ${cale()}           평점 : ${cal()}/4.5';

                  someFunction('1-1');
                  currentGrade = List.from(currentGrades);


                } else if (value == '1학년 2학기') {
                  color = Colors.white;
                  textValue = '이수학점 : ${cale()}           평점 : ${cal()}/4.5';

                  someFunction('1-2');
                  if(currentSub.isEmpty){
                  }



                } else if (value == '2학년 1학기') {
                  color = Colors.white;
                  textValue = '이수학점 : ${cale()}           평점 : ${cal()}/4.5';

                  someFunction('2-1');


                } else if (value == '2학년 2학기') {
                  color = Colors.white;
                  textValue = '이수학점 : ${cale()}           평점 : ${cal()}/4.5';


                  someFunction('2-2');



                } else if (value == '3학년 1학기') {
                  color = Colors.white;
                  textValue = '이수학점 : ${cale()}           평점 : ${cal()}/4.5';


                  someFunction('3-1');


                } else if (value == '3학년 2학기') {
                  color = Colors.white;
                  textValue = '이수학점 : ${cale()}           평점 : ${cal()}/4.5';


                  someFunction('3-2');



                } else if (value == '4학년 1학기') {
                  color = Colors.white;
                  textValue = '이수학점 : ${cale()}           평점 : ${cal()}/4.5';


                  someFunction('4-1');



                } else if (value == '4학년 2학기') {
                  color = Colors.white;
                  textValue = '이수학점 : ${cale()}           평점 : ${cal()}/4.5';


                  someFunction('4-2');


                }

                return Container(
                  height: 234,
                  color: color,
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          textValue,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                          //scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: <DataColumn>[
                              DataColumn(
                                label: Text(
                                  '과목',
                                  style: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  '학점',
                                  style: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  '성적',
                                  style: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ],
                            rows: List<DataRow>.generate(
                              currentSub.length,
                                  (index) =>
                                  DataRow(
                                    cells: <DataCell>[
                                      DataCell(Text(currentSub[index])),
                                      DataCell(Text(currentCredit[index])),
                                      DataCell(
                                        Text(currentGrade[index]),
                                        onTap: () async {
                                          String subject = currentSub[index];
                                          String? grades = await showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                String? tempGrade;
                                                return StatefulBuilder(
                                                    builder: (BuildContext context, StateSetter setState) {
                                                      return AlertDialog(
                                                        title: Text('성적을 입력하세요'),
                                                        content: DropdownButton<String>(
                                                          items: <String>[
                                                            'A+',
                                                            'A0',
                                                            'B+',
                                                            'B0',
                                                            'C+',
                                                            'C0',
                                                            'D+',
                                                            'D0',
                                                            'F'
                                                          ].map((String value) {
                                                            return DropdownMenuItem<String>(
                                                              value: value,
                                                              child: Text(value),
                                                            );
                                                          }).toList(),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              tempGrade = value;
                                                              print(tempGrade);
                                                            });
                                                          },
                                                          hint: Text("선택하세요"),
                                                          value: tempGrade,
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            child: Text('입력'),
                                                            onPressed: () {
                                                              Navigator.of(context).pop(tempGrade);
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    }
                                                );
                                              }
                                          );
                                          if (grades != null && grades.isNotEmpty) {
                                              List<String> parts = value.split(' ');

                                              // 첫번째 부분에서 '학년' 제거, 두번째 부분에서 '학기' 제거
                                              String year = parts[0].replaceAll('학년', '');
                                              String semester = parts[1].replaceAll('학기', '');

                                              // '학기-학기' 형태의 문자열로 만들어 반환
                                              value = '$year-$semester';
                                              print(value);
                                            gradesManager.grade(value, subject, grades); // Use gradesManager to update the grades
                                            cal();
                                          }
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (context) => SelectTermScreen(
                                          //       displayList[index],
                                          //       lastRoute,
                                          //     ),
                                          //   ),
                                          // );
                                        },
                                      ),
                                    ],
                                  ),
                            ).toList(
                            ),
                          ),
                        ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          ]
      ),
    );
}}


