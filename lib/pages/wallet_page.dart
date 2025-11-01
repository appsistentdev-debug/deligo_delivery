// ignore_for_file: use_build_context_synchronously

import 'package:deligo_delivery/utility/string_extensions.dart';
import 'package:deligo_delivery/widgets/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:deligo_delivery/bloc/fetcher_cubit.dart';
import 'package:deligo_delivery/config/page_routes.dart';
import 'package:deligo_delivery/localization/app_localization.dart';
import 'package:deligo_delivery/models/transaction.dart';
import 'package:deligo_delivery/utility/app_settings.dart';
import 'package:deligo_delivery/widgets/custom_button.dart';
import 'package:deligo_delivery/widgets/drawer_widget.dart';
import 'package:deligo_delivery/widgets/error_final_widget.dart';
import 'package:deligo_delivery/widgets/loader.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (BuildContext context) => FetcherCubit(),
        child: const WalletStateful(),
      );
}

class WalletStateful extends StatefulWidget {
  const WalletStateful({super.key});

  @override
  State<WalletStateful> createState() => _WalletStatefulState();
}

class _WalletStatefulState extends State<WalletStateful> {
  double balance = 0;
  List<Transaction> transactions = [];
  int pageNo = 1;
  bool isLoading = true;
  bool allDone = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<FetcherCubit>(context).initFetchWalletBalance();
    BlocProvider.of<FetcherCubit>(context).initFetchWalletTransactions(1);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = Colors.white;
    final titleColor = theme.dividerColor;

    return BlocListener<FetcherCubit, FetcherState>(
      listener: (context, state) {
        if (state is WalletBalanceLoaded) {
          balance = state.wallet.balance;
          setState(() {});
        }
        if (state is WalletTransactionsLoaded) {
          pageNo = state.transactions.meta.current_page ?? 1;
          allDone = state.transactions.meta.current_page ==
              state.transactions.meta.last_page;
          if (state.transactions.meta.current_page == 1) {
            transactions.clear();
          }
          transactions.addAll(state.transactions.data);
          isLoading = false;
          setState(() {});
        }
        if (state is WalletTransactionsFail) {
          isLoading = false;
          setState(() {});
        }
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.primaryColor,
        drawer: const DrawerWidget(),
        // extendBodyBehindAppBar: false,
        // appBar: AppBar(
        //   leading: Padding(
        //     padding: const EdgeInsets.only(left: 16),
        //     child: CircleAvatar(
        //       backgroundColor: Colors.white,
        //       child: IconButton(
        //         onPressed: () {
        //           scaffoldKey.currentState?.openDrawer();
        //         },
        //         icon: const Icon(Icons.menu),
        //         color: Colors.black,
        //       ),
        //     ),
        //   ),
        //   backgroundColor: Colors.transparent,
        //   title: Text(
        //     AppLocalization.instance.getLocalizationFor("wallet"),
        //     style: theme.textTheme.titleLarge?.copyWith(
        //       fontSize: 18,
        //       fontWeight: FontWeight.w500,
        //       color: theme.scaffoldBackgroundColor,
        //     ),
        //   ),
        // ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
              decoration: BoxDecoration(
                  // gradient: LinearGradient(
                  //   colors: [Color(0xFF10C850), Color(0xFF06B13A)],
                  //   begin: Alignment.topLeft,
                  //   end: Alignment.bottomRight,
                  // ),
                  // borderRadius: BorderRadius.only(
                  //   bottomLeft: Radius.circular(32),
                  //   bottomRight: Radius.circular(32),
                  // ),
                  color: theme.primaryColor,
                  image: DecorationImage(
                    image: AssetImage("assets/wallet_bg_big.png"),
                    fit: BoxFit.cover,
                  )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => scaffoldKey.currentState?.openDrawer(),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.menu,
                              color: Colors.black, size: 28),
                        ),
                      ),
                      // IconButton(
                      //   icon: const Icon(
                      //     Icons.arrow_back_ios,
                      //     size: 24,
                      //   ),
                      //   onPressed: () => Navigator.of(context).pop(),
                      // ),
                      const SizedBox(width: 16),
                      Text(
                        AppLocalization.instance.getLocalizationFor("wallet"),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalization.instance
                                .getLocalizationFor("totalBalance"),
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: titleColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "${AppSettings.currencyIcon} ${balance.toStringAsFixed(2)}",
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      CustomButtonDc(
                        padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
                        // prefixIcon: Icons.add,
                        // prefixIconColor: theme.primaryColor,
                        text: AppLocalization.instance
                            .getLocalizationFor("sendToBank"),
                        textColor: theme.primaryColor,
                        buttonColor: theme.cardColor,
                        onTap: () {
                          if (balance > 0) {
                            Navigator.pushNamed(
                                    context, PageRoutes.sendToBankPage,
                                    arguments: balance)
                                .then((value) {
                              if (mounted) {
                                BlocProvider.of<FetcherCubit>(context)
                                    .initFetchWalletBalance();
                                BlocProvider.of<FetcherCubit>(context)
                                    .initFetchWalletTransactions(1);
                              }
                            });
                          } else {
                            Toaster.showToastCenter(AppLocalization.instance
                                .getLocalizationFor("ins_bal"));
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                      child: Text(
                        AppLocalization.instance
                            .getLocalizationFor("recentTransactions"),
                        style: theme.textTheme.titleSmall
                            ?.copyWith(color: theme.hintColor),
                      ),
                    ),
                    Expanded(
                      child: transactions.isNotEmpty
                          ? ListView.builder(
                              padding: EdgeInsets.zero,
                              // separatorBuilder: (context, index) =>
                              //     const SizedBox(height: 8),
                              itemCount: transactions.length,
                              itemBuilder: (context, index) {
                                if ((index == transactions.length - 1) &&
                                    !isLoading &&
                                    !allDone) {
                                  isLoading = true;
                                  BlocProvider.of<FetcherCubit>(context)
                                      .initFetchWalletTransactions(pageNo + 1);
                                }
                                return ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                  ),
                                  title: Text(
                                    transactions[index].metaDescription ??
                                        "${transactions[index].type}"
                                            .capitalizeFirst(),
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "${transactions[index].createdAtFormatted}",
                                    style: theme.textTheme.bodySmall?.copyWith(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  trailing: Text(
                                    "${AppSettings.currencyIcon} ${transactions[index].amount.toStringAsFixed(2)}",
                                    style:
                                        theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: [
                                        "earnings",
                                        "deposit"
                                      ].contains(transactions[index].type)
                                          ? Colors.green
                                          : Colors.redAccent,
                                    ),
                                  ),
                                );
                              },
                            )
                          : (isLoading
                              ? Loader.circularProgressIndicatorPrimary(context)
                              : Padding(
                                  padding: const EdgeInsets.all(32.0),
                                  child: ErrorFinalWidget.errorWithRetry(
                                    context: context,
                                    message: AppLocalization.instance
                                        .getLocalizationFor(
                                            "no_transactions_found"),
                                    actionText: AppLocalization.instance
                                        .getLocalizationFor("okay"),
                                    action: () => Navigator.pop(context),
                                  ))),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
