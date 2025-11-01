import 'package:deligo_delivery/bloc/fetcher_cubit.dart';
import 'package:deligo_delivery/localization/app_localization.dart';
import 'package:deligo_delivery/models/faq.dart';
import 'package:deligo_delivery/widgets/drawer_widget.dart';
import 'package:deligo_delivery/widgets/error_final_widget.dart';
import 'package:deligo_delivery/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => FetcherCubit(),
        child: const FaqStateful(),
      );
}

class FaqStateful extends StatefulWidget {
  const FaqStateful({super.key});

  @override
  State<FaqStateful> createState() => _FaqStatefulState();
}

class _FaqStatefulState extends State<FaqStateful> {
  bool isLoading = true;
  List<Faq> faqs = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<FetcherCubit>(context).initFetchFaqs();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocListener<FetcherCubit, FetcherState>(
      listener: (context, state) {
        if (state is FaqLoaded) {
          isLoading = false;
          faqs = state.faqs;
          setState(() {});
        }
        if (state is FaqLoadFail) {
          isLoading = false;
          setState(() {});
        }
      },
      child: Scaffold(
        drawer: const DrawerWidget(),
        appBar: AppBar(
          title: Text(AppLocalization.instance.getLocalizationFor("faqs")),
          leading: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Builder(
              builder: (context) => IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: Icon(Icons.menu),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Expanded(
                child: faqs.isNotEmpty
                    ? ListView.separated(
                        itemCount: faqs.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: theme.cardColor,
                            ),
                          ),
                          child: ExpansionTile(
                            iconColor: theme.primaryColor,
                            collapsedIconColor: theme.hintColor,
                            expandedAlignment: Alignment.centerLeft,
                            title: Text(
                              faqs[index].title,
                              style: theme.textTheme.titleMedium,
                            ),
                            shape: Border.all(
                              color: theme.cardColor,
                            ),
                            childrenPadding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            children: [
                              Text(
                                faqs[index].description,
                                style: theme.textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      )
                    : isLoading
                        ? Loader.circularProgressIndicatorPrimary(context)
                        : Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: ErrorFinalWidget.errorWithRetry(
                              context: context,
                              message: AppLocalization.instance
                                  .getLocalizationFor("no_faqs_found"),
                              actionText: AppLocalization.instance
                                  .getLocalizationFor("okay"),
                              action: () => Navigator.pop(context),
                            )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
