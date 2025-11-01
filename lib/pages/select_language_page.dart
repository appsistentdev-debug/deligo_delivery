// ignore_for_file: deprecated_member_use

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:deligo_delivery/bloc/app_cubit.dart';
import 'package:deligo_delivery/bloc/language_cubit.dart';
import 'package:deligo_delivery/config/app_config.dart';
import 'package:deligo_delivery/localization/app_localization.dart';
import 'package:deligo_delivery/widgets/drawer_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectLanguagePage extends StatefulWidget {
  final bool fromRoot;
  const SelectLanguagePage({super.key, this.fromRoot = false});

  @override
  SelectLanguagePageState createState() => SelectLanguagePageState();
}

class SelectLanguagePageState extends State<SelectLanguagePage> {
  String? _selectedLanguage;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Builder(
            builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: Icon(Icons.menu),
            ),
          ),
        ),
        title: Text(
          AppLocalization.instance.getLocalizationFor("selectLanguage"),
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      drawer: widget.fromRoot ? null : const DrawerWidget(),
      body: SafeArea(
        child: FadedSlideAnimation(
          fadeDuration: const Duration(milliseconds: 300),
          slideDuration: const Duration(milliseconds: 300),
          beginOffset: const Offset(0, 0.3),
          endOffset: const Offset(0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              Expanded(
                child: BlocBuilder<LanguageCubit, Locale>(
                  builder: (context, currentLocale) {
                    _selectedLanguage ??= currentLocale.languageCode;
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: AppConfig.languagesSupported.length,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () => setState(() => _selectedLanguage =
                            AppConfig.languagesSupported.keys.elementAt(index)),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _selectedLanguage ==
                                      AppConfig.languagesSupported.keys
                                          .elementAt(index)
                                  ? theme.primaryColor.withValues(alpha: 0.4)
                                  : theme.hintColor.withValues(alpha: 0.2),
                            ),
                            borderRadius: BorderRadius.circular(10),
                            color: _selectedLanguage ==
                                    AppConfig.languagesSupported.keys
                                        .elementAt(index)
                                ? theme.primaryColor.withValues(alpha: 0.2)
                                : theme.scaffoldBackgroundColor,
                          ),
                          child: Text(
                            AppConfig
                                .languagesSupported[AppConfig
                                    .languagesSupported.keys
                                    .elementAt(index)]!
                                .name,
                            style: theme.textTheme.bodyMedium!.copyWith(
                              color: _selectedLanguage ==
                                      AppConfig.languagesSupported.keys
                                          .elementAt(index)
                                  ? theme.primaryColor
                                  : theme.primaryColorLight,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding:
            const EdgeInsets.only(bottom: 28.0, left: 16, right: 16, top: 8),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            minimumSize: Size(double.infinity, 48),
          ),
          onPressed: () {
            BlocProvider.of<LanguageCubit>(context)
                .setCurrentLanguage(_selectedLanguage!, true);
            if (widget.fromRoot) {
              BlocProvider.of<AppCubit>(context).initApp();
            } else {
              Navigator.pop(context);
            }
          },
          child: Text(
            AppLocalization.instance.getLocalizationFor("update"),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.cardColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
