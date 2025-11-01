import 'package:deligo_delivery/widgets/loader.dart';
import 'package:flutter/material.dart';

class SecondarySplashPage extends StatelessWidget {
  const SecondarySplashPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     fit: BoxFit.fill,
          //     image: AssetImage("assets/bg.png"),
          //   ),
          // ),
          child: Loader.circularProgressIndicatorPrimary(context),
        ),
      );
}
