import 'package:flutter/material.dart';

import '../widgets/logo_widget.dart';

class SplashView extends StatefulWidget {
  const SplashView({
    super.key
  });

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LogoWidget(
            height: 70.0
          ),
          SizedBox(
            height: 14.0
          ),
          SizedBox(
            height: 21.0,
            width: 21.0,
            child: CircularProgressIndicator(
              strokeWidth: 2.0
            )
          )
        ]
      )
    )
  );

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final NavigatorState navigatorState = Navigator.of(context);

      Future.delayed(
        const Duration(
          seconds: 2
        ),
        () => navigatorState.pushReplacementNamed('/login')
      );
    });
  }
}
