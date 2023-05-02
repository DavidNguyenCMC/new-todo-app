import 'package:flutter/material.dart';

import '../../common/event/event_bus_mixin.dart';
import '../../common/resources/index.dart';
import '../complete/complete_page.dart';
import '../inprogress/inprogress_page.dart';
import '../todo/todo_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> with EventBusMixin {
  int _currentBottomItem = 0;

  late List<Widget> contents = <Widget>[
    const TodoPage(),
    const InProgressPage(),
    const CompletePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        bottom: false,
        child: Container(
          color: AppColors.white,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primaryColor,
            unselectedItemColor: AppColors.gray500,
            selectedLabelStyle: TextStyles.primaryExtraSmallMedium,
            unselectedLabelStyle: TextStyles.greyExtraSmallMedium,
            currentIndex: _currentBottomItem,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            onTap: (int index) => setState(() {
              _currentBottomItem = index;
            }),
            items: [
              BottomNavigationBarItem(
                icon: const SizedBox(),
                label: Strings.localized.todo,
              ),
              BottomNavigationBarItem(
                icon: const SizedBox(),
                label: Strings.localized.inProgress,
              ),
              BottomNavigationBarItem(
                icon: const SizedBox(),
                label: Strings.localized.completed,
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(
        index: _currentBottomItem,
        children: contents,
      ),
    );
  }
}
