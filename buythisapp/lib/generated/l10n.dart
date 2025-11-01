// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Buy this app`
  String get buyThisApp {
    return Intl.message(
      'Buy this app',
      name: 'buyThisApp',
      desc: '',
      args: [],
    );
  }

  /// `Buy this`
  String get buyThis {
    return Intl.message(
      'Buy this',
      name: 'buyThis',
      desc: '',
      args: [],
    );
  }

  /// `Template Now`
  String get templateNow {
    return Intl.message(
      'Template Now',
      name: 'templateNow',
      desc: '',
      args: [],
    );
  }

  /// `Flutter template only, No backend.`
  String get flutterTemplateOnlyNoBackend {
    return Intl.message(
      'Flutter template only, No backend.',
      name: 'flutterTemplateOnlyNoBackend',
      desc: '',
      args: [],
    );
  }

  /// `Buy this App with`
  String get buyThisAppWith {
    return Intl.message(
      'Buy this App with',
      name: 'buyThisAppWith',
      desc: '',
      args: [],
    );
  }

  /// `Complete Backend`
  String get completeBackend {
    return Intl.message(
      'Complete Backend',
      name: 'completeBackend',
      desc: '',
      args: [],
    );
  }

  /// `Full app solution with complete Backend.`
  String get fullAppSolutionWithCompleteBackend {
    return Intl.message(
      'Full app solution with complete Backend.',
      name: 'fullAppSolutionWithCompleteBackend',
      desc: '',
      args: [],
    );
  }

  /// `Message on`
  String get messageOn {
    return Intl.message(
      'Message on',
      name: 'messageOn',
      desc: '',
      args: [],
    );
  }

  /// `Developed by:`
  String get developedBy {
    return Intl.message(
      'Developed by:',
      name: 'developedBy',
      desc: '',
      args: [],
    );
  }

  /// `Subscribing..!`
  String get subscribing {
    return Intl.message(
      'Subscribing..!',
      name: 'subscribing',
      desc: '',
      args: [],
    );
  }

  /// `Subscribed..!`
  String get subscribed {
    return Intl.message(
      'Subscribed..!',
      name: 'subscribed',
      desc: '',
      args: [],
    );
  }

  /// `Email not valid!`
  String get emailNotValid {
    return Intl.message(
      'Email not valid!',
      name: 'emailNotValid',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong..!`
  String get somethingWentWrong {
    return Intl.message(
      'Something went wrong..!',
      name: 'somethingWentWrong',
      desc: '',
      args: [],
    );
  }

  /// `Stay in touch.`
  String get stayInTouch {
    return Intl.message(
      'Stay in touch.',
      name: 'stayInTouch',
      desc: '',
      args: [],
    );
  }

  /// `Stay connected for future`
  String get stayConnectedForFuture {
    return Intl.message(
      'Stay connected for future',
      name: 'stayConnectedForFuture',
      desc: '',
      args: [],
    );
  }

  /// `updates and new products.`
  String get updatesAndNewProducts {
    return Intl.message(
      'updates and new products.',
      name: 'updatesAndNewProducts',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email address`
  String get enterYourEmailAddress {
    return Intl.message(
      'Enter your email address',
      name: 'enterYourEmailAddress',
      desc: '',
      args: [],
    );
  }

  /// `Subscribe Now`
  String get subscribeNow {
    return Intl.message(
      'Subscribe Now',
      name: 'subscribeNow',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'id'),
      Locale.fromSubtags(languageCode: 'it'),
      Locale.fromSubtags(languageCode: 'pt'),
      Locale.fromSubtags(languageCode: 'ro'),
      Locale.fromSubtags(languageCode: 'sw'),
      Locale.fromSubtags(languageCode: 'tr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
