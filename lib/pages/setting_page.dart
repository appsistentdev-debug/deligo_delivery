// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:deligo_delivery/bloc/app_cubit.dart';
import 'package:deligo_delivery/bloc/language_cubit.dart';
import 'package:deligo_delivery/config/app_config.dart';
import 'package:deligo_delivery/localization/app_localization.dart';
import 'package:deligo_delivery/network/remote_repository.dart';
import 'package:deligo_delivery/widgets/confirm_dialog.dart';
import 'package:deligo_delivery/widgets/custom_button.dart';
import 'package:deligo_delivery/widgets/custom_dropdown_field.dart';
import 'package:deligo_delivery/widgets/drawer_widget.dart';
import 'package:deligo_delivery/widgets/loader.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) => const SettingStateful();
}

class SettingStateful extends StatefulWidget {
  const SettingStateful({super.key});

  @override
  State<SettingStateful> createState() => _SettingStatefulState();
}

class _SettingStatefulState extends State<SettingStateful> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      drawer: const DrawerWidget(),
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          AppLocalization.instance.getLocalizationFor("settings"),
          style: theme.textTheme.titleLarge,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          // _buildAccountSetting(
          //     AppLocalization.instance.getLocalizationFor("displaySettings"),
          //     CustomDropdownField(
          //       label: AppLocalization.instance
          //           .getLocalizationFor("selectAppTheme"),
          //       child: DropdownButton(
          //         hint: Text(
          //           "Select Theme",
          //           style: theme.textTheme.titleSmall?.copyWith(fontSize: 15),
          //         ),
          //         isExpanded: true,
          //         dropdownColor: theme.colorScheme.surface,
          //         underline: const SizedBox.shrink(),
          //         value: BlocProvider.of<ThemeCubit>(context).isDark
          //             ? Constants.themeDark
          //             : Constants.themeLight,
          //         items: <String>[Constants.themeLight, Constants.themeDark]
          //             .map((String value) => DropdownMenuItem<String>(
          //                   value: value,
          //                   child: Text(AppLocalization.instance
          //                       .getLocalizationFor(value)),
          //                 ))
          //             .toList(),
          //         onChanged: (value) => BlocProvider.of<ThemeCubit>(context)
          //             .setTheme(value == Constants.themeDark),
          //       ),
          //     ),
          //     theme),
          // const SizedBox(height: 10),
          _buildAccountSetting(
              AppLocalization.instance.getLocalizationFor("language"),
              CustomDropdownField(
                label: AppLocalization.instance
                    .getLocalizationFor("selectAppLanguage"),
                child: DropdownButton(
                  hint: Text(
                    "Select Language",
                    style: theme.textTheme.titleSmall?.copyWith(fontSize: 15),
                  ),
                  isExpanded: true,
                  dropdownColor: theme.colorScheme.surface,
                  underline: const SizedBox.shrink(),
                  value:
                      BlocProvider.of<LanguageCubit>(context).currentLangCode,
                  items: AppConfig.languagesSupported.keys
                      .map((String value) => DropdownMenuItem<String>(
                            value: value,
                            child:
                                Text(AppConfig.languagesSupported[value]!.name),
                          ))
                      .toList(),
                  onChanged: (value) => BlocProvider.of<LanguageCubit>(context)
                      .setCurrentLanguage(value, true),
                ),
              ),
              theme),
          const SizedBox(height: 10),
          InkWell(
            onTap: () => ConfirmDialog.showConfirmation(
                    context,
                    Text(AppLocalization.instance
                        .getLocalizationFor("delete_account")),
                    Text(AppLocalization.instance
                        .getLocalizationFor("delete_account_msg")),
                    AppLocalization.instance.getLocalizationFor("no"),
                    AppLocalization.instance.getLocalizationFor("yes"))
                .then((value) {
              if (value != null && value == true && mounted) {
                Loader.showLoader(context);
                RemoteRepository().deleteUser().then((value) {
                  Loader.dismissLoader(context);
                  Navigator.pop(context);
                  BlocProvider.of<AppCubit>(context).logOut();
                });
              }
            }),
            child: _buildAccountSetting(
                AppLocalization.instance.getLocalizationFor("accountSetting"),
                Row(
                  children: [
                    const Icon(Icons.delete, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(
                        AppLocalization.instance
                            .getLocalizationFor("deleteAccount"),
                        style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.red, fontWeight: FontWeight.w500)),
                  ],
                ),
                theme),
          ),
          const Spacer(),
          CustomButton(
            label: AppLocalization.instance.getLocalizationFor("submit"),
            margin: const EdgeInsets.all(20),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSetting(String title, Widget child, ThemeData theme) =>
      Container(
        padding: const EdgeInsets.all(20),
        color: theme.cardColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            child,
          ],
        ),
      );
}
