import 'package:deligo_delivery/bloc/fetcher_cubit.dart';
import 'package:deligo_delivery/flavors.dart';
import 'package:deligo_delivery/localization/app_localization.dart';
import 'package:deligo_delivery/utility/helper.dart';
import 'package:deligo_delivery/widgets/custom_button.dart';
import 'package:deligo_delivery/widgets/drawer_widget.dart';
import 'package:deligo_delivery/widgets/entry_field.dart';
import 'package:deligo_delivery/widgets/loader.dart';
import 'package:deligo_delivery/widgets/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => FetcherCubit(),
        child: const SupportStateful(),
      );
}

class SupportStateful extends StatefulWidget {
  const SupportStateful({super.key});

  @override
  State<SupportStateful> createState() => _SupportStatefulState();
}

class _SupportStatefulState extends State<SupportStateful> {
  final TextEditingController _supportController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return BlocListener<FetcherCubit, FetcherState>(
      listener: (context, state) {
        if (state is SupportLoading) {
          Loader.showLoader(context);
        } else {
          Loader.dismissLoader(context);
        }
        if (state is SupportLoaded) {
          Toaster.showToastTop(AppLocalization.instance
              .getLocalizationFor("support_has_been_submitted"));
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        drawer: const DrawerWidget(),
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
          title: Text(AppLocalization.instance.getLocalizationFor("support"),
              style: theme.textTheme.titleMedium!.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              )),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    F.appFlavor == Flavor.deligo
                        ? SvgPicture.asset(
                            isDark
                                ? 'assets/flavors/logo/deligo/logo_light.svg'
                                : 'assets/flavors/logo/deligo/logo.svg',
                            height: 150,
                            width: 150,
                          )
                        : Image.asset(
                            isDark ? F.logoLight : F.logo,
                            height: 150,
                            width: 150,
                          ),
                    SizedBox(height: 60),
                    Text(
                      AppLocalization.instance
                          .getLocalizationFor("letUsKnowYourQueries"),
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 40),
                    EntryField(
                      label: AppLocalization.instance
                          .getLocalizationFor("enterYourMessage"),
                      hintText: AppLocalization.instance
                          .getLocalizationFor("writeSomething"),
                      maxLines: 3,
                      controller: _supportController,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              child: CustomButton(
                label: AppLocalization.instance.getLocalizationFor("submit"),
                onTap: () {
                  if (_supportController.text.trim().length < 10 ||
                      _supportController.text.trim().length > 140) {
                    Toaster.showToastTop(AppLocalization.instance
                        .getLocalizationFor("invalid_length_message"));
                  } else {
                    Helper.clearFocus(context);
                    BlocProvider.of<FetcherCubit>(context)
                        .initSupportSubmit(_supportController.text.trim());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _supportController.dispose();
    super.dispose();
  }
}
