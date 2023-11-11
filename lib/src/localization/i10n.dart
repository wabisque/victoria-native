import 'package:flutter/material.dart';

enum I10n {
  en(
    locale: Locale('en'),
    name: 'English'
  );

  final Locale locale;
  final String name;

  const I10n({
    required this.locale,
    required this.name
  });
}
