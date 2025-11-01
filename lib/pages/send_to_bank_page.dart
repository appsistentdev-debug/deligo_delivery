import 'package:deligo_delivery/widgets/regular_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:deligo_delivery/bloc/fetcher_cubit.dart';
import 'package:deligo_delivery/localization/app_localization.dart';
import 'package:deligo_delivery/models/send_to_bank.dart';
import 'package:deligo_delivery/utility/app_settings.dart';
import 'package:deligo_delivery/widgets/custom_button.dart';
import 'package:deligo_delivery/widgets/entry_field.dart';
import 'package:deligo_delivery/widgets/toaster.dart';

class SendToBankPage extends StatelessWidget {
  const SendToBankPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double balance = ModalRoute.of(context)!.settings.arguments as double;
    return BlocProvider(
      create: (context) => FetcherCubit(),
      child: SendToBankStateful(balance: balance),
    );
  }
}

class SendToBankStateful extends StatefulWidget {
  final double balance;
  const SendToBankStateful({super.key, required this.balance});

  @override
  State<SendToBankStateful> createState() => _SendToBankStatefulState();
}

class _SendToBankStatefulState extends State<SendToBankStateful> {
  final TextEditingController _holderNameController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _branchCodeController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocListener<FetcherCubit, FetcherState>(
      listener: (context, state) {
        _isLoading = state is SendtoBankLoading;
        setState(() {});
        if (state is SendtoBankLoaded || state is SendtoBankFail) {
          if (state is SendtoBankLoaded) {
            Toaster.showToast(AppLocalization.instance
                .getLocalizationFor("request_submitted"));
          }
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: RegularAppBar(
          title: AppLocalization.instance.getLocalizationFor("sendToBank"),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          children: [
            const SizedBox(height: 10),
            EntryField(
              label: AppLocalization.instance
                  .getLocalizationFor("enterAmountToSend"),
              hintText:
                  AppLocalization.instance.getLocalizationFor("enterHere"),
              controller: _amountController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            Text(
              "${AppLocalization.instance.getLocalizationFor("avail_bal_is")} ${AppSettings.currencyIcon}${widget.balance}",
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontSize: 11, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            Divider(
              thickness: 1,
              color: theme.highlightColor,
            ),
            Text(
              AppLocalization.instance.getLocalizationFor("bankInformation"),
              style: theme.textTheme.bodyLarge
                  ?.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            EntryField(
              label: AppLocalization.instance
                  .getLocalizationFor("accountHolderName"),
              hintText:
                  AppLocalization.instance.getLocalizationFor("enterHere"),
              controller: _holderNameController,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 24),
            EntryField(
              label: AppLocalization.instance.getLocalizationFor("bankName"),
              hintText:
                  AppLocalization.instance.getLocalizationFor("enterHere"),
              controller: _bankNameController,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 24),
            EntryField(
              label: AppLocalization.instance.getLocalizationFor("branchCode"),
              hintText:
                  AppLocalization.instance.getLocalizationFor("enterHere"),
              controller: _branchCodeController,
              textCapitalization: TextCapitalization.characters,
            ),
            const SizedBox(height: 24),
            EntryField(
              label:
                  AppLocalization.instance.getLocalizationFor("accountNumber"),
              hintText:
                  AppLocalization.instance.getLocalizationFor("enterHere"),
              controller: _accountNumberController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 120),
          ],
        ),
        floatingActionButton: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomButton(
                margin: const EdgeInsets.only(left: 35),
                label:
                    AppLocalization.instance.getLocalizationFor("continueText"),
                onTap: () {
                  if (_bankNameController.text.trim().isEmpty) {
                    Toaster.showToastBottom(AppLocalization.instance
                        .getLocalizationFor("err_field_bank_name"));
                  } else if (_holderNameController.text.trim().isEmpty) {
                    Toaster.showToastBottom(AppLocalization.instance
                        .getLocalizationFor("err_field_bank_account_name"));
                  } else if (_accountNumberController.text.trim().isEmpty) {
                    Toaster.showToastBottom(AppLocalization.instance
                        .getLocalizationFor("err_field_bank_account_number"));
                  } else if (_branchCodeController.text.trim().isEmpty) {
                    Toaster.showToastBottom(AppLocalization.instance
                        .getLocalizationFor("err_field_bank_code"));
                  } else if (double.tryParse(_amountController.text.trim()) ==
                          null ||
                      ((double.tryParse(_amountController.text.trim()) ?? 0)) >
                          widget.balance) {
                    Toaster.showToastBottom(AppLocalization.instance
                        .getLocalizationFor("err_field_amount"));
                  } else {
                    BlocProvider.of<FetcherCubit>(context).initSendToBank(
                      SendToBank(
                          _bankNameController.text,
                          _holderNameController.text,
                          _accountNumberController.text,
                          _branchCodeController.text,
                          double.tryParse(_amountController.text) ?? 0),
                    );
                  }
                },
              ),
      ),
    );
  }
}
