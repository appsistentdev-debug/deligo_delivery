import 'package:deligo_delivery/localization/app_localization.dart';
import 'package:deligo_delivery/pages/home_page.dart';
import 'package:deligo_delivery/pages/wallet_page.dart';
import 'package:flutter/material.dart';

import 'bottom_tab_account.dart';

class BottomNavigationPage extends StatefulWidget {
  static int tabIndex = 1;

  const BottomNavigationPage({super.key});

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  int _currentIndex = 1;

  @override
  void initState() {
    BottomNavigationPage.tabIndex = 1;
    _currentIndex = BottomNavigationPage.tabIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          WalletPage(),
          HomePage(),
          BottomTabAccount(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: buildActiveIcon(
              context,
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).hintColor,
              'assets/bottom_menu/ic_wallet.png',
              AppLocalization.instance.getLocalizationFor("wallet"),
            ),
            activeIcon: buildActiveIcon(
              context,
              Theme.of(context).colorScheme.surface,
              null,
              'assets/bottom_menu/ic_walletact.png',
              AppLocalization.instance.getLocalizationFor("wallet"),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: buildActiveIcon(
              context,
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).hintColor,
              'assets/bottom_menu/ic_book.png',
              AppLocalization.instance.getLocalizationFor("ride"),
            ),
            activeIcon: buildActiveIcon(
              context,
              Theme.of(context).colorScheme.surface,
              null,
              'assets/bottom_menu/ic_bookact.png',
              AppLocalization.instance.getLocalizationFor("ride"),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: buildActiveIcon(
              context,
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).hintColor,
              'assets/bottom_menu/ic_account.png',
              AppLocalization.instance.getLocalizationFor("account"),
            ),
            activeIcon: buildActiveIcon(
              context,
              Theme.of(context).colorScheme.surface,
              null,
              'assets/bottom_menu/ic_accountact.png',
              AppLocalization.instance.getLocalizationFor("account"),
            ),
            label: '',
          ),
        ],
        selectedFontSize: 8,
        unselectedFontSize: 8,
        showUnselectedLabels: true,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).hintColor,
        currentIndex: _currentIndex,
        onTap: (index) {
          _currentIndex = index;
          setState(() {});
        },
      ),
    );
  }

  Container buildActiveIcon(BuildContext context, Color bgColor,
          Color? titleColor, String icon, String title) =>
      Container(
        margin: const EdgeInsets.only(top: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: bgColor,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              icon,
              height: 18,
              width: 18,
            ),
            const SizedBox(width: 15),
            Flexible(
              child: Text(
                title,
                style: TextStyle(color: titleColor),
              ),
            ),
          ],
        ),
      );
}
