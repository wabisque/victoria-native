import 'package:flutter/material.dart';

class DashboardView extends StatefulWidget {
  static const String routeName = '/dashboard';

  const DashboardView({
    super.key
  });

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Center(
          child: Text('Dashboard')
        )
      )
    );
  }
}
