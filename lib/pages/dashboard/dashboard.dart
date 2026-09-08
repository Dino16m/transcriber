import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class _SidebarItemWrapper {
  final UniqueKey id;
  final Widget label;
  final IconData? iconData;
  final bool section;

  late SidebarItem unselected;
  late SidebarItem selected;

  new({
    required this.label,
    this.iconData,
    required this.id,
    this.section = false,
  }) {
    unselected = section
        ? SidebarItem(label: label, section: section)
        : SidebarItem(label: label, leading: Icon(iconData));
    selected = SidebarItem(
      label: label,
      leading: Icon(iconData, color: Colors.white),
    );
  }

  SidebarItem build(UniqueKey currentId) {
    if (section || currentId != id) {
      return unselected;
    }
    return selected;
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  @override
  State<StatefulWidget> createState() {
    return _DashboardState();
  }
}

class _DashboardState extends State<Dashboard> {
  int pageIndex = 0;

  List<_SidebarItemWrapper> items = [
    _SidebarItemWrapper(
      label: Text('Dictation'),
      section: true,
      id: UniqueKey(),
    ),
    _SidebarItemWrapper(
      label: Text('General'),
      iconData: CupertinoIcons.slider_horizontal_3,
      id: UniqueKey(),
    ),
    _SidebarItemWrapper(
      label: Text('Models'),
      id: UniqueKey(),
      iconData: CupertinoIcons.cloud,
    ),
    _SidebarItemWrapper(
      label: Text('Formatting'),
      id: UniqueKey(),
      iconData: CupertinoIcons.textformat_abc_dottedunderline,
    ),
    _SidebarItemWrapper(
      label: Text('Personal'),
      id: UniqueKey(),
      section: true,
    ),
    _SidebarItemWrapper(
      label: Text('Dictionary'),
      id: UniqueKey(),
      iconData: CupertinoIcons.book,
    ),
    _SidebarItemWrapper(
      label: Text('History'),
      id: UniqueKey(),
      iconData: CupertinoIcons.clock,
    ),
    _SidebarItemWrapper(
      label: Text('Insights'),
      id: UniqueKey(),
      section: true,
    ),
    _SidebarItemWrapper(
      label: Text('Statistics'),
      id: UniqueKey(),
      iconData: CupertinoIcons.chart_bar,
    ),
    _SidebarItemWrapper(
      label: Text('About'),
      id: UniqueKey(),
      iconData: CupertinoIcons.info_circle,
    ),
  ];

  UniqueKey get pageKey {
    final selected = items
        .where((item) => item.section == false)
        .indexed
        .firstWhere((record) => record.$1 == pageIndex);
    return selected.$2.id;
  }

  @override
  Widget build(BuildContext context) {
    final theme = MacosTheme.of(context);
    final backgroundColor = theme.brightness.isDark
        ? Color(0xFF4F378B)
        : Color(0xFFD9D2F1);
    final sideBarColor = theme.brightness.isDark
        ? Color(0xFF4A4458)
        : Color(0xFFE7E1EE);
    return MacosWindow(
      backgroundColor: backgroundColor,
      sidebar: Sidebar(
        minWidth: 250,
        decoration: BoxDecoration(color: sideBarColor),
        builder: (context, scrollController) {
          return Container(
            color: sideBarColor,
            child: SidebarItems(
              currentIndex: pageIndex,
              scrollController: scrollController,
              selectedColor: Color(0xFF0A84FF),
              itemSize: SidebarItemSize.large,
              onChanged: (i) {
                setState(() => pageIndex = i);
              },
              items: items.map((item) => item.build(pageKey)).toList(),
            ),
          );
        },
      ),
    );
  }
}
