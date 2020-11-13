import 'package:flutter/cupertino.dart';

class _TabInfo {
  const _TabInfo(this.title, this.icon);

  final String title;
  final IconData icon;
}

class CupertinoTabBarDemo extends StatelessWidget {
  const CupertinoTabBarDemo();

  @override
  Widget build(BuildContext context) {
    final _tabInfo = [
      _TabInfo(
        'Home',
        CupertinoIcons.home,
      ),
      _TabInfo(
        'Messages',
        CupertinoIcons.conversation_bubble,
      ),
      _TabInfo(
        'Profile',
        CupertinoIcons.profile_circled,
      ),
    ];

    return DefaultTextStyle(
      style: CupertinoTheme.of(context).textTheme.textStyle,
      child: CupertinoApp(
        debugShowCheckedModeBanner: false,
        home: CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            items: [
              for (final tabInfo in _tabInfo)
                BottomNavigationBarItem(
                  label: tabInfo.title,
                  icon: Icon(tabInfo.icon),
                ),
            ],
          ),
          tabBuilder: (context, index) {
            return CupertinoTabView(
              builder: (context) => CupertinoDemoTab(
                title: _tabInfo[index].title,
                icon: _tabInfo[index].icon,
              ),
              defaultTitle: _tabInfo[index].title,
            );
          },
        ),
      ),
    );
  }
}

class CupertinoDemoTab extends StatelessWidget {
  const CupertinoDemoTab({
    Key key,
    @required this.title,
    @required this.icon,
  }) : super(key: key);

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(),
        backgroundColor: CupertinoColors.systemBackground,
        child: Center(
          child: Icon(
            icon,
            semanticLabel: title,
            size: 100,
          ),
        ),
      );
  }
}