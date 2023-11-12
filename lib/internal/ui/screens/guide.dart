import 'package:flutter/material.dart';
import 'package:villagerio/internal/services/language.dart';
import 'package:villagerio/internal/services/list_of_role.dart';
import 'package:villagerio/internal/ui/screens/list_of_role.dart';

class GuidePage extends StatelessWidget {
  const GuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    final str = LanguageService.str(context);
    return DefaultTabController(
      initialIndex: 1,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(str.guide),
          bottom: TabBar(tabs: [
            Tab(
              text: str.howToPlay,
            ),
            Tab(
              text: str.listOfRoles,
            ),
            Tab(
              text: str.help,
            ),
            Tab(
              text: str.about,
            ),
          ]),
        ),
        body: TabBarView(children: [
          Text(str.howToPlay),
          FutureBuilder(
              future: ListRoleService.getRoleStats(),
              builder: (context, ss) {
                if (!ss.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListOfRolePage(
                  parentContext: context,
                  roles: ss.data,
                );
              }),
          Text(str.help),
          Text(str.about),
        ]),
      ),
    );
  }
}
