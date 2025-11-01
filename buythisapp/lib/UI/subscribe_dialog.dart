// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, prefer_final_fields, use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:buy_this_app/SubscribeBloc/subscribe_cubit.dart';
import 'package:buy_this_app/SubscribeBloc/subscribe_state.dart';
import 'package:buy_this_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SubscribeDialog extends StatefulWidget {
  @override
  _SubscribeDialogState createState() => _SubscribeDialogState();
}

class _SubscribeDialogState extends State<SubscribeDialog> {
  TextEditingController _emailController = TextEditingController();
  late SubscribeCubit _subscribeBloc;

  @override
  void initState() {
    super.initState();
    _subscribeBloc = BlocProvider.of<SubscribeCubit>(context);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SubscribeCubit, SubscribeState>(
      listener: (context, state) {
        if (state.isSubmitting) {
          Fluttertoast.showToast(msg: S.of(context).subscribing);
        } else if (state.isSuccess) {
          Fluttertoast.showToast(msg: S.of(context).subscribed);
          Navigator.pop(context);
        } else if (!state.isEmailValid) {
          Fluttertoast.showToast(msg: S.of(context).emailNotValid);
        } else if (state.isFailure) {
          Fluttertoast.showToast(msg: S.of(context).somethingWentWrong);
        }
      },
      child: Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 120, 20, 24),
                margin: EdgeInsets.only(top: 80),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      S.of(context).stayInTouch,
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      S.of(context).stayConnectedForFuture +
                          '\n' +
                          S.of(context).updatesAndNewProducts,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _emailController,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'\s')),
                      ],
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8)),
                        hintText: S.of(context).enterYourEmailAddress,
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        _subscribeBloc.submit(_emailController.text);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xffF07492),
                                  Color(0xffEF5776),
                                ]),
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0xffF07492),
                                  offset: Offset(0, 4),
                                  blurRadius: 5)
                            ]),
                        padding: EdgeInsets.all(20),
                        child: Text(
                          S.of(context).subscribeNow,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              child: Image.asset(
                "images/popup_img_head.png",
                package: "buy_this_app",
                height: 220,
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.close),
                color: Colors.white,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
