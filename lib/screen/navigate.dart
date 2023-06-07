import 'package:flutter/material.dart';
import 'package:grad_gg/screen/search_page/search_page.dart';
import 'StatusPage.dart';
import 'mainscreen.dart';
import 'package:provider/provider.dart';
import 'Provider.dart';
import 'package:grad_gg/screen//editprofile_screen.dart';
import 'package:grad_gg/screen/graduate_screen.dart';

//void main() => runApp(MyStatus());


class Mynavi extends StatelessWidget {
  const Mynavi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'GG',
        theme: ThemeData(primarySwatch: Colors.grey),
    home: ChangeNotifierProvider(
    create: (context) => NavigationIndexProvider(),
    child: NavPage(),
    ),
    );
  }
}

class NavPage extends StatefulWidget {
  @override
  State<NavPage> createState() => _MyStatusPageState();

}



class _MyStatusPageState extends State<NavPage> { //네비바 화면경로 연결
  int selectedIndex=2;
  final List<Widget> pages = [
    EditProfileScreen(),
    MyStatusPage(),
    MainScreen(),
    SearchScreen(),
    GraduatingScreen()
  ];



  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<NavigationIndexProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: pages[provider.selectedIndex],
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.person), label: "프로필 수정",),
          NavigationDestination(icon: Icon(Icons.calculate), label: "MY STATUS"),
          NavigationDestination(icon: Icon(Icons.home), label: '홈'),
          NavigationDestination(icon: Icon(Icons.search), label: '검색'),
          NavigationDestination(icon: Icon(Icons.done), label: '졸업요소'),
        ],

        selectedIndex: provider.selectedIndex,
        onDestinationSelected: (index) {
          provider.setIndex(index);
        }
      ),
    );
  }
}


