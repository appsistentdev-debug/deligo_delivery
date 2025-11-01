import 'package:deligo_delivery/pages/faq_page.dart';
import 'package:deligo_delivery/pages/onboarding_page.dart';
import 'package:flutter/material.dart';

import 'package:deligo_delivery/pages/home_page.dart';
import 'package:deligo_delivery/pages/insight_page.dart';
import 'package:deligo_delivery/pages/message_page.dart';
import 'package:deligo_delivery/pages/order_complete_page.dart';
import 'package:deligo_delivery/pages/order_info_page.dart';
import 'package:deligo_delivery/pages/profile_page.dart';
import 'package:deligo_delivery/pages/ride_complete_page.dart';
import 'package:deligo_delivery/pages/ride_info_page.dart';
import 'package:deligo_delivery/pages/select_language_page.dart';
import 'package:deligo_delivery/pages/send_to_bank_page.dart';
import 'package:deligo_delivery/pages/setting_page.dart';
import 'package:deligo_delivery/pages/support_page.dart';
import 'package:deligo_delivery/pages/tnc_page.dart';
import 'package:deligo_delivery/pages/wallet_page.dart';

class PageRoutes {
  static const String homePage = 'home_page';
  static const String sendToBankPage = 'send_to_bank';
  static const String ridesScreen = 'rides_screen';
  static const String rideInformationScreen = 'ride_information';
  static const String ratingsScreen = 'ratings_screen';
  static const String profilePage = 'profile_page';
  static const String supportPage = 'support_page';
  static const String faqPage = 'faq_page';
  static const String walletPage = 'wallet_page';
  static const String tncPage = 'tnc_page';
  static const String settingPage = 'setting_page';
  static const String changeLanguageScreen = 'change_language_screen';
  static const String rideInfoPage = 'ride_info_page';
  static const String orderInfoPage = 'order_info_page';
  static const String rideCompletePage = 'ride_complete_page';
  static const String messagePage = 'message_page';
  static const String orderCompletePage = 'order_complete_page';
  static const String insightPage = 'insight_page';
  static const String onboardingPage = 'onboarding_page';

  Map<String, WidgetBuilder> routes() => {
        homePage: (context) => const HomePage(),
        profilePage: (context) => const ProfilePage(),
        supportPage: (context) => const SupportPage(),
        walletPage: (context) => const WalletPage(),
        tncPage: (context) => const TncPage(),
        settingPage: (context) => const SettingPage(),
        changeLanguageScreen: (context) => const SelectLanguagePage(),
        rideInfoPage: (context) => const RideInfoPage(),
        orderInfoPage: (context) => const OrderInfoPage(),
        rideCompletePage: (context) => const RideCompletePage(),
        messagePage: (context) => const MessagePage(),
        sendToBankPage: (context) => const SendToBankPage(),
        orderCompletePage: (context) => const OrderCompletePage(),
        insightPage: (context) => const InsightPage(),
        onboardingPage: (context) => const OnboardingScreen(),
        faqPage: (context) => const FaqPage(),
      };
}
